import 'package:flutter/material.dart';
import 'package:infobootleg/services/auth.dart';

import 'package:infobootleg/shared_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final signOutConfirmed = await PlatformAlertDialog(
      title: "Salir",
      content: "¿Confirmar cerrar sesión?",
    ).show(context);
    if (signOutConfirmed) {
      _signOut(context);
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
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
    );
  }
}
