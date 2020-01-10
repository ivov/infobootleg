import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infobootleg/helpers/email_sign_in_change_model.dart';
import 'package:infobootleg/services/auth.dart';
import 'package:infobootleg/shared_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class SignInWithEmailFormChangeNotifier extends StatefulWidget {
  SignInWithEmailFormChangeNotifier({
    @required this.model,
  });
  final SignInWithEmailChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<SignInWithEmailChangeModel>(
      builder: (context) => SignInWithEmailChangeModel(auth: auth),
      child: Consumer<SignInWithEmailChangeModel>(
        builder: (context, model, child) =>
            SignInWithEmailFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _SignInWithEmailFormChangeNotifierState createState() =>
      _SignInWithEmailFormChangeNotifierState();
}

class _SignInWithEmailFormChangeNotifierState
    extends State<SignInWithEmailFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInWithEmailChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submitForm() async {
    try {
      await model.submitForm();
      Navigator.of(context).pop();
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
        title: "Error en ingreso",
        exception: error,
      ).show(context);
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 12.0),
      _buildPasswordTextField(),
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

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
      decoration: InputDecoration(
        labelText: "Correo electrónico",
        errorText: model.emailErrorText,
      ),
      enabled: model.formIsLoading == false,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submitForm,
      onChanged: model.updatePassword,
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
