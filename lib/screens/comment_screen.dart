import 'package:flutter/material.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen(this.searchState);

  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: Container(),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver a favoritos"),
        onTap: () =>
            searchState.transitionToScreenHorizontally(Screen.favorites),
      ),
      leading: IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        onPressed: () =>
            searchState.transitionToScreenHorizontally(Screen.favorites),
      ),
    );
  }
}
