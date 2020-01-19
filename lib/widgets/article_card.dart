import 'package:flutter/material.dart';

import 'confirmation_prompt.dart';

class ArticleCard extends StatefulWidget {
  ArticleCard({
    @required this.lawContents,
    @required this.articleNumber,
    @required this.onArticleSelected,
  });

  final Map<String, String> lawContents;
  final String articleNumber;
  final void Function(int, {int milliseconds}) onArticleSelected;

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  Color _cardColor = Colors.white;

  void _promptForSelectionConfirmation() async {
    int listItemPosition = int.parse(widget.articleNumber);
    widget.onArticleSelected(listItemPosition,
        milliseconds: 200); // shorter duration because short in-screen movement

    setState(() => _cardColor = Colors.lightBlueAccent);

    bool answer = await ConfirmationPrompt(
      question:
          "¿Guardar el artículo ${widget.articleNumber}\n en mis favoritos?",
    ).show(context);

    if (answer == false) {
      setState(() => _cardColor = Colors.white);
    } else if (answer == true) {
      print("saving to Firestore..."); // TODO: Save to firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _promptForSelectionConfirmation,
      child: Card(
        elevation: 5.0,
        color: _cardColor,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                "Art.\n" + widget.articleNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  widget.lawContents[widget.articleNumber],
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
