import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service for signing in a user with Google, Facebook, Email or Anonymously, and signing them out.
/// It also provides access to a stream of sign-in/out events and to the currently signed-in user.
class AuthService {
  /// Getter for a FirebaseUser on every sign-in or sign-out event.
  Stream<FirebaseUser> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    await FirebaseAuth.instance.signOut();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();

    if (googleAccount == null) {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
      );
    }

    try {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
      );
      return authResult.user;
    } catch (error) {
      throw PlatformException(
        code: "ERROR_MISSING_AUTH_TOKEN",
      );
    }
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(["public_profile"]);
    if (facebookLoginResult != null &&
        facebookLoginResult.accessToken != null) {
      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: facebookLoginResult.accessToken.token,
        ),
      );
      return authResult.user;
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return authResult.user;
  }

  Future<FirebaseUser> createUserInWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return authResult.user;
  }

  Future<FirebaseUser> signInAnonymously() async {
    final AuthResult authResult =
        await FirebaseAuth.instance.signInAnonymously();
    return authResult.user;
  }
}
