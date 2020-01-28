import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/utils/exceptions.dart';
import 'package:infobootleg/services/google_search_service.dart';
import 'package:infobootleg/models/law_model.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/services/auth_service.dart';
import 'package:infobootleg/services/firestore_database_service.dart';
import 'package:infobootleg/widgets/alert_box.dart';

class LawSearchScreen extends StatelessWidget {
  LawSearchScreen(this.searchState, this.dbService);
  final SearchStateModel searchState;
  final FirestoreDatabaseService dbService;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        actions: [
          _buildExitButton(context),
          Expanded(child: Container()), // fill up space between buttons
          FutureBuilder(
              future: dbService.readAllFavoritesOfUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data.data != null) {
                  return _buildFavoritesButton(context);
                }
                return Container(); // show nothing instead of favorites button
              }),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: FractionallySizedBox(
          heightFactor: 0.9,
          child: Center(
            child: _buildSearchCard(context),
          )),
    );
  }

  FlatButton _buildExitButton(BuildContext context) {
    return FlatButton.icon(
      icon: Transform.rotate(angle: 180 * 3.14 / 180, child: Icon(Icons.close)),
      textColor: Colors.white,
      label: Text("Salir",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          )),
      onPressed: () => _confirmSignOut(context),
    );
  }

  FlatButton _buildFavoritesButton(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.star),
      textColor: Colors.white,
      label: Text("Favoritos",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          )),
      onPressed: () => searchState.transitionHorizontallyTo(Screen.favorites),
    );
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

  Future<void> _signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    await authService.signOut();
  }

  Card _buildSearchCard(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(26.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Infobootleg", style: Theme.of(context).textTheme.title),
            SizedBox(height: 20),
            Text("Buscar ley por número o título",
                style: Theme.of(context).textTheme.subtitle),
            SizedBox(height: 20),
            _buildSearchInput(context)
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Container(
      width: 200,
      alignment: Alignment.center,
      child: TextField(
        controller: _textController,
        onSubmitted: (userInput) => _onSubmitted(userInput, context),
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

  _onSubmitted(String userInput, BuildContext context) async {
    bool isAlphabeticInput = RegExp(r'[a-zA-Z]+').hasMatch(userInput);
    bool isNumericInput = RegExp(r'[0-9]+').hasMatch(userInput);

    if (isAlphabeticInput) {
      _processAlphabeticInput(userInput, context);
    } else if (isNumericInput) {
      _processNumericInput(userInput, context);
    }
  }

  _processAlphabeticInput(String userInput, BuildContext context) async {
    try {
      String lawId = await GoogleSearchService.fetchLawId(userInput);
      DocumentSnapshot snapshot =
          await dbService.retrieveLawDocumentById(lawId);
      searchState.updateActiveLaw(Law(snapshot.data));
      searchState.transitionVerticallyTo(Screen.summary);
    } on NoResultsFromGoogleSearchAPIException {
      AlertBox(
        title: "Sin datos",
        content: "No hay una ley referida a «$userInput» en la base de datos.",
        confirmActionText: "Buscar otra ley",
      ).show(context);
    }
  }

  _processNumericInput(String userInput, BuildContext context) async {
    String _leftPad(userInput) {
      while (userInput.length < 5) {
        userInput = "0" + userInput;
      }
      return userInput;
    }

    String lawNumber = _leftPad(userInput);

    try {
      final snapshot = await dbService.retrieveLawDocumentByNumber(lawNumber);
      searchState.updateActiveLaw(Law(snapshot.data));
      searchState.transitionVerticallyTo(Screen.summary);
    } catch (e) {
      AlertBox(
        title: "Sin datos",
        content: "La Ley $userInput no figura en la base de datos.",
        confirmActionText: "Buscar otra ley",
      ).show(context);
    }
  }
}
