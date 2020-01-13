import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infobootleg/helpers/hex_color.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/helpers/validators.dart';
import 'package:infobootleg/services/authService.dart';
import 'package:infobootleg/shared_widgets/platform_exception_alert_dialog.dart';

enum EmailSignInFormType { signIn, register }

class SignInWithEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Ingresar con correo electrónico")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SignInWithEmailForm(),
        ),
        backgroundColor: hexColor("f5eaea"));
  }
}

class SignInWithEmailForm extends StatefulWidget
    with EmailAndPasswordValidators {
  @override
  _SignInWithEmailFormState createState() => _SignInWithEmailFormState();
}

class _SignInWithEmailFormState extends State<SignInWithEmailForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _formHasBeenSubmitted = false;
  bool _formIsLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submitForm() async {
    setState(() {
      _formHasBeenSubmitted = true;
      _formIsLoading = true;
    });
    try {
      final authService = Provider.of<AuthService>(context);
      if (_formType == EmailSignInFormType.signIn) {
        await authService.signInWithEmailAndPassword(_email, _password);
      } else {
        await authService.createUserInWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
        title: "Error en ingreso",
        exception: error,
      ).show(context);
    } finally {
      setState(() {
        _formIsLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formHasBeenSubmitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: _buildTextFieldsAndButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFieldsAndButtons() {
    final submitButtonText =
        _formType == EmailSignInFormType.signIn ? "Ingresar" : "Registrarse";
    final toggleButtonText = _formType == EmailSignInFormType.signIn
        ? "O registrarse"
        : "O ingresar";
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_formIsLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 30.0),
      _buildPasswordTextField(),
      SizedBox(height: 35.0),
      _buildSubmitButton(submitButtonText, submitEnabled),
      SizedBox(height: 12.0),
      _buildToggleButton(toggleButtonText),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText =
        _formHasBeenSubmitted && !widget.emailValidator.isValid(_email);
    return TextField(
      style: TextStyle(fontSize: 26.0),
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) =>
          setState(() {}), // rebuild based on enabled/disabled color
      onEditingComplete: _emailEditingComplete,
      decoration: InputDecoration(
          labelText: "Correo electrónico",
          contentPadding: EdgeInsets.only(bottom: 0),
          labelStyle: TextStyle(fontSize: 22.0),
          errorText: showErrorText ? widget.invalidEmailErrorText : null),
      enabled: _formIsLoading == false,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _formHasBeenSubmitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      style: TextStyle(fontSize: 26.0),
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submitForm,
      onChanged: (password) => setState(
          () {}), // setState to rebuild, thus updating enabled/disabled color
      enabled: _formIsLoading == false,
      decoration: InputDecoration(
          labelText: "Contraseña",
          contentPadding: EdgeInsets.only(bottom: 0),
          labelStyle: TextStyle(fontSize: 22.0),
          errorText: showErrorText ? widget.invalidPasswordErrorText : null),
      obscureText: true,
    );
  }

  RaisedButton _buildSubmitButton(String raisedButtonText, bool submitEnabled) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          raisedButtonText,
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      onPressed: submitEnabled ? _submitForm : null,
    );
  }

  FlatButton _buildToggleButton(String toggleButtonText) {
    return FlatButton(
      child: Text(toggleButtonText, style: TextStyle(fontSize: 20.0)),
      onPressed: !_formIsLoading ? _toggleFormType : null,
    );
  }
}
