import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/helpers/left_pad.dart';
import 'package:infobootleg/services/authService.dart';
import 'package:infobootleg/services/databaseService.dart';
import 'package:infobootleg/shared_widgets/platform_alert_dialog.dart';

class SearchStartScreen extends StatelessWidget {
  SearchStartScreen({
    @required this.pageController,
    @required this.onLawSelected,
  });
  final PageController pageController;
  final TextEditingController _myTextController = TextEditingController();
  final Function onLawSelected;

  Future<void> _signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    await authService.signOut();
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final signOutConfirmed = await PlatformAlertDialog(
      title: "Salir",
      content: "¿Cerrar sesión?",
    ).show(context);
    if (signOutConfirmed) {
      _signOut(context);
    }
  }

  _onSubmitted(BuildContext context, String userInput) async {
    final dbService = Provider.of<DatabaseService>(context);
    try {
      final law = await dbService.retrieveLaw(leftPad(userInput));
      onLawSelected(law);
      _goToSearchResultScreen();
    } catch (e) {
      // TODO: tell user no law found
    }
  }

  void _goToSearchResultScreen() {
    pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Infobootleg",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          actions: <Widget>[_buildExitButton(context)]),
      body: Container(
          color: hexColor("f5eaea"),
          child: Center(child: _buildSearchCard(context))),
    );
  }

  FlatButton _buildExitButton(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.exit_to_app),
      textColor: Colors.white,
      color: hexColor("5b5656"),
      label:
          Text("Salir", style: TextStyle(fontSize: 18.0, color: Colors.white)),
      onPressed: () => _confirmSignOut(context),
    );
  }

  Card _buildSearchCard(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(26.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Buscar ley por número o título",
                style: Theme.of(context).textTheme.subtitle),
            SizedBox(height: 20),
            _buildSearchBox(context)
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      width: 200,
      alignment: Alignment.center,
      child: TextField(
        controller: _myTextController,
        onSubmitted: (userInput) => _onSubmitted(context, userInput),
        style: TextStyle(fontSize: 25.0),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ley...',
          hintStyle: TextStyle(fontSize: 20.0),
          prefixIcon: Icon(Icons.search, size: 40.0, color: Colors.black),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
