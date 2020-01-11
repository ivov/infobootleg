import 'package:flutter/material.dart';

import 'helpers/hex_color.dart';

class SecondLandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: new BoxDecoration(
            color: HexColor("a3be8c"),
          ),
          child: Column(
            children: <Widget>[
              _buildHeader(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Infobootleg",
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Elegir método de ingreso",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildGoogleAndFacebookButtonsRow(),
          SizedBox(height: 40.0),
          _buildEmailAndAnonButtonsRow()
        ],
      ),
    );
  }

  Row _buildGoogleAndFacebookButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SecondSignInButton(
          textColor: Colors.black,
          buttonColor: Colors.white,
          asset: Image.asset(
            "assets/images/google.svg",
            height: 60.0,
          ),
          buttonText: "Google",
        ),
        SecondSignInButton(
          textColor: Colors.white,
          buttonColor: HexColor("273b70"),
          asset: Image.asset(
            "assets/images/facebook.svg",
            height: 60.0,
          ),
          buttonText: "Facebook",
        ),
      ],
    );
  }
}

Row _buildEmailAndAnonButtonsRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      SecondSignInButton(
        buttonColor: HexColor("DEB887"),
        textColor: Colors.black,
        asset: Image.asset(
          "assets/images/email.svg",
          height: 41.0,
        ),
        buttonText: "Correo",
      ),
      SecondSignInButton(
        buttonColor: HexColor("ebcb8b"),
        textColor: Colors.black,
        asset: Image.asset(
          "assets/images/user.svg",
          height: 60.0,
        ),
        buttonText: "Anónimo",
      ),
    ],
  );
}

class SecondSignInButton extends StatelessWidget {
  SecondSignInButton({
    @required this.buttonColor,
    @required this.textColor,
    @required this.asset,
    @required this.buttonText,
  });

  final Color buttonColor;
  final Color textColor;
  final Widget asset;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      width: 140.0,
      child: RaisedButton(
        elevation: 15.0,
        onPressed: () {},
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
