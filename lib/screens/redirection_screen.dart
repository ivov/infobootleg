import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/screens/master_search_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/auth_service.dart';

/// Redirects user to MasterSearchScreen or to SignInScreen based on user's sign-in status.
/// User's sign-in status is provided by Firebase's onAuthStateChanged stream.
class RedirectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<FirebaseUser>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) return SignInScreen();
          return MasterSearchScreen.createWithMultiProvider(context, user);
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
