import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/screens/redirection_screen.dart';
import 'utils/theme_data.dart';
import 'services/auth_service.dart';

void main() => runApp(Infobootleg());

class Infobootleg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (context) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Infobootleg',
        theme: themeData,
        home: RedirectionScreen(),
      ),
    );
  }
}
