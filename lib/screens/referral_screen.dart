import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/screens/search_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/authService.dart';
import 'package:infobootleg/services/databaseService.dart';

/// Refers user to HomeScreen if they have signed in, or to SecondSignInScreen if they have not signed in.
class ReferralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<FirebaseUser>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) return SignInScreen();
          return Provider<DatabaseService>(
            builder: (context) => DatabaseService(userId: user.uid),
            child: SearchScreen(),
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
