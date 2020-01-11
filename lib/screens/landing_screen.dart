import 'package:flutter/material.dart';
import 'package:infobootleg/screens/home_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/auth.dart';
import 'package:infobootleg/services/databaseService.dart';
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
          if (user == null) return SignInScreen.create(context);
          // if value is user, welcome!
          return Provider<DatabaseService>(
            builder: (context) => FirestoreDatabaseService(uid: user.uid),
            child: HomeScreen(),
          );
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
