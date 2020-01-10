import 'package:flutter/material.dart';
import 'package:infobootleg/screens/home_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/auth.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        // if first value of stream was received
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          // if value null, have them sign in
          if (user == null) return SignInScreen();
          // if value is user, welcome!
          return HomeScreen();
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
