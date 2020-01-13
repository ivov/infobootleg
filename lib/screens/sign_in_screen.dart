import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/shared_widgets/header.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/screens/sign_in_with_email_screen.dart';
import 'package:infobootleg/services/authService.dart';
import 'package:infobootleg/shared_widgets/platform_exception_alert_dialog.dart';

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
      final dispatchSelectedSignInMethod = signInMethods[selectedMethod];
      dispatchSelectedSignInMethod();
    } catch (error) {
      // ERROR_ABORTED_BY_USER is not an actual error and should not be shown to user
      if (error.code != "ERROR_ABORTED_BY_USER") {
        PlatformExceptionAlertDialog(
            title: "Error en ingreso", exception: error);
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
        SecondSignInButton(
          textColor: Colors.black,
          buttonColor: Colors.white,
          asset: Image.asset(
            "assets/images/google.svg",
            height: 60.0,
          ),
          buttonText: "Google",
          signInMethod: () => _dispatchSignIn(context, SignInMethod.Google),
        ),
        SecondSignInButton(
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
        SecondSignInButton(
          buttonColor: hexColor("bac7a7"),
          textColor: Colors.black,
          asset: Image.asset(
            "assets/images/email.svg",
            height: 41.0,
          ),
          buttonText: "Correo",
          signInMethod: () => _dispatchSignIn(context, SignInMethod.Email),
        ),
        SecondSignInButton(
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

class SecondSignInButton extends StatelessWidget {
  SecondSignInButton({
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
