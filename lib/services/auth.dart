import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

// this module serves to decouple all auth code from Firebase

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  Future<User> signInWithGoogle();
  Future<void> signInWithFacebook();
}

class Auth implements AuthBase {
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await FirebaseAuth.instance.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: "ERROR_MISSING_AUTH_TOKEN",
          message: "Missing Google auth token",
        );
      }
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<void> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(["public_profile"]);
    if (facebookLoginResult != null) {
      final authResult = await FirebaseAuth.instance.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: facebookLoginResult.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    await FirebaseAuth.instance.signOut();
  }
}
