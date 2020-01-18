import 'package:flutter/material.dart';
import 'package:infobootleg/screens/referral_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/theme_data.dart';
import 'services/auth_service.dart';

void main() => runApp(Infobootleg());

// TODO: Save favorite articles and laws for user.

class Infobootleg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (context) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Infobootleg',
        theme: themeData,
        home: ReferralScreen(),
      ),
    );
  }
}
