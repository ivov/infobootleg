import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:infobootleg/helpers/email_sign_in_model.dart';
import 'package:infobootleg/services/auth.dart';

class SignInWithEmailBloc {
  SignInWithEmailBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<SignInWithEmailModel> _modelController =
      StreamController<SignInWithEmailModel>();
  Stream<SignInWithEmailModel> get modelStream => _modelController.stream;
  SignInWithEmailModel _model = SignInWithEmailModel();

  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  Future<void> submitForm() async {
    updateWith(formhasBeenSubmitted: true, formIsLoading: true);
    try {
      if (_model.formType == SignInWithEmailFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserInWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (error) {
      updateWith(formIsLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == SignInWithEmailFormType.signIn
        ? SignInWithEmailFormType.register
        : SignInWithEmailFormType.signIn;
    updateWith(
      email: "",
      password: "",
      formType: formType,
      formIsLoading: false,
      formhasBeenSubmitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    SignInWithEmailFormType formType,
    bool formIsLoading,
    bool formhasBeenSubmitted,
  }) {
    // update model
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        formIsLoading: formIsLoading,
        formHasBeenSubmitted: formhasBeenSubmitted);

    // add updated model to stream
    _modelController.add(_model);
  }
}
