import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/models/law_model.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/helpers/left_pad.dart';
import 'package:infobootleg/services/auth_service.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/widgets/alert_box.dart';

class LawSearchScreen extends StatelessWidget {
  LawSearchScreen(this.searchState, this.dbService);
  final SearchStateModel searchState;
  final DatabaseService dbService;
  final TextEditingController _myTextController = TextEditingController();

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
      body: Center(child: _buildSearchCard(context)),
    );
  }

  FlatButton _buildExitButton(BuildContext context) {
    return FlatButton.icon(
      icon: Transform.rotate(angle: 180 * 3.14 / 180, child: Icon(Icons.close)),
      textColor: Colors.white,
      // color: hexColor("5b5656"),
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
      // color: hexColor("5b5656"),
      label: Text("Favoritos",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          )),
      onPressed: () =>
          searchState.transitionToScreenHorizontally(Screen.favorites),
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
            // TODO: Search by title using Bing
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

  _onSubmitted(BuildContext context, String userInput) async {
    final dbService = Provider.of<DatabaseService>(context);
    try {
      final snapshot = await dbService.readLaw(id: leftPad(userInput));
      searchState.updateActiveLaw(Law(snapshot.data));
      searchState.transitionToScreenVertically(Screen.summary);
    } catch (e) {
      AlertBox(
        title: "Sin datos",
        content: "La Ley $userInput no figura en la base de datos.",
        confirmActionText: "Buscar otra ley",
      ).show(context);
    }
  }
}
