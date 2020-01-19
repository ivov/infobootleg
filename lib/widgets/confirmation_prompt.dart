import 'package:flutter/material.dart';

class ConfirmationPrompt extends StatelessWidget {
  ConfirmationPrompt({this.question});

  final String question;

  Future<bool> show(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => this,
      isDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration modalBottomSheetDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    );

    return Container(
      height: 70.0,
      decoration: modalBottomSheetDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(question, style: TextStyle(fontSize: 18.0)),
            Row(
              children: [
                ConfirmationPromptButton(
                  buttonText: "Sí",
                  returnValue: true,
                ),
                SizedBox(width: 20.0),
                ConfirmationPromptButton(
                  buttonText: "No",
                  returnValue: false,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmationPromptButton extends StatelessWidget {
  ConfirmationPromptButton({
    @required this.buttonText,
    @required this.returnValue,
  });

  final String buttonText;
  final bool returnValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: SizedBox(
        height: 40,
        width: 80.0,
        child: FlatButton(
          color: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: () => Navigator.of(context).pop(returnValue),
        ),
      ),
    );
  }
}
