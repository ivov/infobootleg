import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infobootleg/blocs/sign_in_with_email_bloc.dart';
import 'package:infobootleg/helpers/email_sign_in_model.dart';

import 'package:infobootleg/services/auth.dart';
import 'package:infobootleg/shared_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class SignInWithEmailFormBlocBased extends StatefulWidget {
  SignInWithEmailFormBlocBased({
    @required this.bloc,
  });
  final SignInWithEmailBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<SignInWithEmailBloc>(
      builder: (context) => SignInWithEmailBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInWithEmailBloc>(
        builder: (context, bloc, child) =>
            SignInWithEmailFormBlocBased(bloc: bloc),
      ),
    );
  }

  @override
  _SignInWithEmailFormBlocBasedState createState() =>
      _SignInWithEmailFormBlocBasedState();
}

class _SignInWithEmailFormBlocBasedState
    extends State<SignInWithEmailFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete(SignInWithEmailModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submitForm() async {
    try {
      await widget.bloc.submitForm();
      Navigator.of(context).pop();
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
        title: "Error en ingreso",
        exception: error,
      ).show(context);
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(SignInWithEmailModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 12.0),
      _buildPasswordTextField(model),
      SizedBox(height: 26.0),
      RaisedButton(
        elevation: 5.0,
        child: Text(
          model.raisedButtonText,
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
        onPressed: model.submitEnabled ? _submitForm : null,
      ),
      SizedBox(height: 12.0),
      FlatButton(
        child: Text(model.flatButtonText),
        onPressed: !model.formIsLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField(SignInWithEmailModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(model),
      decoration: InputDecoration(
        labelText: "Correo electrónico",
        errorText: model.emailErrorText,
      ),
      enabled: model.formIsLoading == false,
    );
  }

  TextField _buildPasswordTextField(SignInWithEmailModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submitForm,
      onChanged: widget.bloc.updatePassword,
      enabled: model.formIsLoading == false,
      decoration: InputDecoration(
        labelText: "Contraseña",
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SignInWithEmailModel>(
        stream: widget.bloc.modelStream,
        initialData: SignInWithEmailModel(),
        builder: (context, snapshot) {
          final SignInWithEmailModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
