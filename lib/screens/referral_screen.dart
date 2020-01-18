import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/screens/master_search_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/auth_service.dart';
import 'package:infobootleg/services/database_service.dart';

/// Refers user to MasterSearchScreen if they have signed in, or to SignInScreen if they have not signed in.
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
          return _buildMasterSearchScreenWithMultiProvider(user);
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

  _buildMasterSearchScreenWithMultiProvider(FirebaseUser user) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          builder: (context) => DatabaseService(userId: user.uid),
        ),
        ChangeNotifierProvider<SearchStateModel>(
          builder: (context) => SearchStateModel(),
        )
      ],
      child: MasterSearchScreen(),
    );
  }
}
