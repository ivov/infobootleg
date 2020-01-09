import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infobootleg/helpers/validators.dart';
import 'package:infobootleg/services/auth.dart';

enum SignInWithEmailFormType { signIn, register }

class SignInWithEmailScreen extends StatelessWidget {
  SignInWithEmailScreen({@required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ingresar con e-mail"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                child: SignInWithEmailForm(auth: auth),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.green[200]);
  }
}

class SignInWithEmailForm extends StatefulWidget
    with EmailAndPasswordValidators {
  SignInWithEmailForm({@required this.auth});
  final AuthBase auth;
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
  SignInWithEmailFormType _formType = SignInWithEmailFormType.signIn;
  bool _formHasBeenSubmitted = false;
  bool _formIsLoading = false;

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
      if (_formType == SignInWithEmailFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserInWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (error) {
      print(error.toString());
    } finally {
      setState(() {
        _formIsLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formHasBeenSubmitted = false;
      _formType = _formType == SignInWithEmailFormType.signIn
          ? SignInWithEmailFormType.register
          : SignInWithEmailFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final raisedButtonText = _formType == SignInWithEmailFormType.signIn
        ? "Ingresar"
        : "Registrar una cuenta";
    final flatButtonText = _formType == SignInWithEmailFormType.signIn
        ? "O registrar una cuenta"
        : "O ingresar";
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_formIsLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 12.0),
      _buildPasswordTextField(),
      SizedBox(height: 26.0),
      RaisedButton(
        elevation: 5.0,
        child: Text(
          raisedButtonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        color: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        onPressed: submitEnabled ? _submitForm : null,
      ),
      SizedBox(height: 12.0),
      FlatButton(
        child: Text(flatButtonText),
        onPressed: !_formIsLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText =
        _formHasBeenSubmitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      // setState to rebuild, thus updating enabled/disabled color
      onChanged: (email) => setState(() {}),
      onEditingComplete: _emailEditingComplete,
      decoration: InputDecoration(
          labelText: "Correo electrónico",
          errorText: showErrorText ? widget.invalidEmailErrorText : null),
      enabled: _formIsLoading == false,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _formHasBeenSubmitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submitForm,
      // setState to rebuild, thus updating enabled/disabled color
      onChanged: (password) => setState(() {}),
      enabled: _formIsLoading == false,
      decoration: InputDecoration(
          labelText: "Contraseña",
          errorText: showErrorText ? widget.invalidPasswordErrorText : null),

      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
