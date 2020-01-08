import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  SignInButton({
    @required this.text,
    this.fontColor = Colors.black,
    this.buttonColor = Colors.white,
    @required this.asset,
    @required this.onPressed,
  })  : assert(text != null),
        assert(asset != null),
        assert(onPressed != null);

  final String text;
  final Color buttonColor;
  final Color fontColor;
  final dynamic asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: RaisedButton(
        elevation: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            asset,
            Text(
              text,
              style: TextStyle(
                color: fontColor,
                fontSize: 18.0,
              ),
            ),
            Opacity(opacity: 0.0, child: asset),
          ],
        ),
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
