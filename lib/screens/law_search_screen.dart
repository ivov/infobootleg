import 'package:flutter/material.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/helpers/left_pad.dart';
import 'package:infobootleg/services/auth_service.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/shared_widgets/alert_box.dart';

class LawSearchScreen extends StatelessWidget {
  LawSearchScreen(this.searchState);
  final SearchStateModel searchState;
  final TextEditingController _myTextController = TextEditingController();

  Future<void> _signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    await authService.signOut();
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool signOutConfirmed = await AlertBox(
      title: "Salir",
      content: "¿Cerrar sesión?",
      confirmActionText: "Confirmar",
      cancelActionText: "Cancelar",
    ).show(context);

    if (signOutConfirmed) {
      _signOut(context);
    }
  }

  _onSubmitted(BuildContext context, String userInput) async {
    final dbService = Provider.of<DatabaseService>(context);
    try {
      final retrievedLaw = await dbService.retrieveLaw(leftPad(userInput));
      searchState.updateActiveLaw(retrievedLaw);
      searchState.goToLawSummaryScreen();
    } catch (e) {
      AlertBox(
        title: "Sin datos",
        content: "La Ley $userInput no figura en la base de datos.",
        confirmActionText: "Buscar otra ley",
      ).show(context);
    }
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
            // TODO: Search by title using Bing
            Text("Buscar ley por número o título",
                style: Theme.of(context).textTheme.subtitle),
            SizedBox(height: 20),
            _buildSearchBar(context)
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
