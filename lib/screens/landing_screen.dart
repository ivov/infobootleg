import 'package:flutter/material.dart';
import 'package:infobootleg/screens/home_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/auth.dart';

class LandingScreen extends StatelessWidget {
  final AuthBase auth;
  LandingScreen({this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        // if first value of stream was received
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          // if value null, have them sign in
          if (user == null) return SignInScreen(auth: auth);
          // if value is user, welcome!
          return HomeScreen(auth: auth);
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
