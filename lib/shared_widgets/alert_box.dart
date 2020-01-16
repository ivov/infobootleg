import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  AlertBox({
    @required this.title,
    @required this.content,
    this.confirmActionText,
    this.cancelActionText,
  });

  final String title;
  final String content;
  final String cancelActionText;
  final String confirmActionText;

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content, style: TextStyle(fontSize: 22.0)),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        AlertDialogButton(actionText: cancelActionText, returnValue: false),
      );
    }
    actions.add(
      AlertDialogButton(actionText: confirmActionText, returnValue: true),
    );
    return actions;
  }
}

class AlertDialogButton extends StatelessWidget {
  AlertDialogButton({
    @required this.actionText,
    @required this.returnValue,
  });

  final String actionText;
  final bool returnValue;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(actionText, style: TextStyle(fontSize: 20.0)),
      onPressed: () => Navigator.of(context).pop(returnValue),
    );
  }
}
