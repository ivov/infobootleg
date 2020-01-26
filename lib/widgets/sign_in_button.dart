import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  SignInButton({
    @required this.buttonColor,
    @required this.textColor,
    @required this.asset,
    @required this.buttonText,
    @required this.signInMethod,
  });

  final Color buttonColor;
  final Color textColor;
  final Widget asset;
  final String buttonText;
  final dynamic signInMethod;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      width: 140.0,
      child: RaisedButton(
        elevation: 15.0,
        onPressed: signInMethod,
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45.0),
            bottomRight: Radius.circular(45.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            asset,
            SizedBox(height: 12.0),
            Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
