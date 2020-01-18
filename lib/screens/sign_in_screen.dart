import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/screens/sign_in_with_email_screen.dart';
import 'package:infobootleg/services/auth_service.dart';
import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/widgets/header.dart';
import 'package:infobootleg/widgets/sign_in_alert_box.dart';

enum SignInMethod { Google, Facebook, Email, Anonymous }

class SignInScreen extends StatelessWidget {
  Future<void> _dispatchSignIn(
      BuildContext context, SignInMethod selectedMethod) async {
    try {
      final authService = Provider.of<AuthService>(context);

      Map<SignInMethod, dynamic> signInMethods = {
        SignInMethod.Google: authService.signInWithGoogle,
        SignInMethod.Facebook: authService.signInWithFacebook,
        SignInMethod.Anonymous: authService.signInAnonymously,
        SignInMethod.Email: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SignInWithEmailScreen(),
          ));
        },
      };
      signInMethods[selectedMethod]();
    } catch (error) {
      // ERROR_ABORTED_BY_USER is not an actual error, so it is not shown to the user.
      if (error.code != "ERROR_ABORTED_BY_USER") {
        SignInAlertBox(title: "Error en ingreso", exception: error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Header(context: context, subtitleText: "Elegir método de ingreso"),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildGoogleAndFacebookButtonsRow(context),
          SizedBox(height: 40.0),
          _buildEmailAndAnonButtonsRow(context)
        ],
      ),
    );
  }

  Row _buildGoogleAndFacebookButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SignInButton(
          textColor: Colors.black,
          buttonColor: Colors.white,
          asset: Image.asset(
            "assets/images/google.svg",
            height: 60.0,
          ),
          buttonText: "Google",
          signInMethod: () => _dispatchSignIn(context, SignInMethod.Google),
        ),
        SignInButton(
          textColor: Colors.white,
          buttonColor: hexColor("273b70"),
          asset: Image.asset(
            "assets/images/facebook.svg",
            height: 60.0,
          ),
          buttonText: "Facebook",
          signInMethod: () => _dispatchSignIn(context, SignInMethod.Facebook),
        ),
      ],
    );
  }

  Row _buildEmailAndAnonButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SignInButton(
          buttonColor: hexColor("bac7a7"),
          textColor: Colors.black,
          asset: Image.asset(
            "assets/images/email.svg",
            height: 41.0,
          ),
          buttonText: "Correo",
          signInMethod: () => _dispatchSignIn(context, SignInMethod.Email),
        ),
        SignInButton(
          buttonColor: hexColor("ebcb8b"),
          textColor: Colors.black,
          asset: Image.asset(
            "assets/images/user.svg",
            height: 60.0,
          ),
          buttonText: "Anónimo",
          signInMethod: () => _dispatchSignIn(context, SignInMethod.Anonymous),
        ),
      ],
    );
  }
}

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
