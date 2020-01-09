import 'package:flutter/material.dart';
import 'package:infobootleg/services/auth.dart';

class HomeScreen extends StatelessWidget {
  final AuthBase auth;
  final VoidCallback onSignOut;

  HomeScreen({
    @required this.onSignOut,
    @required this.auth,
  });

  Future<void> _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Salir",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }
}

class Authbase {}
