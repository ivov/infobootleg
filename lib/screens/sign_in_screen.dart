import 'package:flutter/material.dart';
import 'package:infobootleg/shared_widgets/sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Infobootleg"),
        ),
        body: _buildBody(),
        backgroundColor: Colors.green[200]);
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Ingresar",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 42.0),
          SignInButton(
            text: "Ingresar con Google",
            asset: Image.asset("assets/images/google.png"),
            onPressed: () {},
          ),
          SizedBox(height: 14.0),
          SignInButton(
            text: "Ingresar con Facebook",
            fontColor: Colors.white,
            buttonColor: Color(0xFF334D92),
            asset: Image.asset("assets/images/facebook.png"),
            onPressed: () {},
          ),
          SizedBox(height: 14.0),
          SignInButton(
            text: "Ingresar con e-mail",
            fontColor: Colors.white,
            buttonColor: Colors.teal[700],
            asset: Image.asset(
              "assets/images/email.png",
              height: 30.0,
              width: 30.0,
            ),
            onPressed: () {},
          ),
          SizedBox(height: 14.0),
          Text(
            "o",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.0),
          SignInButton(
            text: "Ingresar sin identificarse",
            buttonColor: Colors.lime[500],
            asset: Image.asset(
              "assets/images/user.png",
              height: 30.0,
              width: 30.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
