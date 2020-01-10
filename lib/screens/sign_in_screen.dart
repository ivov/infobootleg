import 'package:flutter/material.dart';
import 'package:infobootleg/blocs/sign_in_manager.dart';
import 'package:infobootleg/screens/sign_in_with_email_screen.dart';
import 'package:infobootleg/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:infobootleg/shared_widgets/platform_exception_alert_dialog.dart';

import 'package:infobootleg/shared_widgets/sign_in_button.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({@required this.manager, @required this.isLoading});
  final SignInManager manager;
  final bool isLoading;

// create SignInPage with Provder of type SignInBloc as parent
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (context) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (context, isLoading, child) => Provider<SignInManager>(
          builder: (context) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, child) => SignInScreen(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: "Error en ingreso",
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (error) {
      if (error.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, error);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (error) {
      if (error.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, error);
      }
    }
  }

  _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SignInWithEmailScreen(),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } catch (error) {
      _showSignInError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Infobootleg"),
        ),
        body: _buildBody(context),
        backgroundColor: Colors.green[200]);
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildHeader(),
          SizedBox(height: 42.0),
          SignInButton(
            text: "Ingresar con Google",
            asset: Image.asset("assets/images/google.png"),
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 14.0),
          SignInButton(
            text: "Ingresar con Facebook",
            fontColor: Colors.white,
            buttonColor: Color(0xFF334D92),
            asset: Image.asset("assets/images/facebook.png"),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
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
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Text(
      "Ingresar",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
