import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserInWithEmailAndPassword(String email, String password);
  Future<User> getCurrentUser();
  Future<void> signOut();
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
  Future<User> signInWithGoogle() async {
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
      final authResult = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
      );
      return _userFromFirebase(authResult.user);
    } catch (error) {
      throw PlatformException(
        code: "ERROR_MISSING_AUTH_TOKEN",
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(["public_profile"]);
    if (facebookLoginResult != null &&
        facebookLoginResult.accessToken != null) {
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
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await FirebaseAuth.instance.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> getCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return _userFromFirebase(user);
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
