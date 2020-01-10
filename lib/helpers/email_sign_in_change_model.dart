import 'package:flutter/foundation.dart';
import 'package:infobootleg/helpers/email_sign_in_model.dart';
import 'package:infobootleg/helpers/validators.dart';
import 'package:infobootleg/services/auth.dart';

class SignInWithEmailChangeModel
    with EmailAndPasswordValidators, ChangeNotifier {
  SignInWithEmailChangeModel({
    @required this.auth,
    this.email = "",
    this.password = "",
    this.formType = SignInWithEmailFormType.signIn,
    this.formIsLoading = false,
    this.formHasBeenSubmitted = false,
  });
  final AuthBase auth;
  String email;
  String password;
  SignInWithEmailFormType formType;
  bool formHasBeenSubmitted;
  bool formIsLoading;

  String get raisedButtonText {
    return formType == SignInWithEmailFormType.signIn
        ? "Ingresar"
        : "Registrar una cuenta";
  }

  String get flatButtonText {
    return formType == SignInWithEmailFormType.signIn
        ? "O registrar una cuenta"
        : "O ingresar";
  }

  bool get submitEnabled {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !formIsLoading;
  }

  String get passwordErrorText {
    bool showErrorText =
        formHasBeenSubmitted && !passwordValidator.isValid(email);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = formHasBeenSubmitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == SignInWithEmailFormType.signIn
        ? SignInWithEmailFormType.register
        : SignInWithEmailFormType.signIn;
    updateWith(
      email: "",
      password: "",
      formType: formType,
      formIsLoading: false,
      formHasBeenSubmitted: false,
    );
  }

  Future<void> submitForm() async {
    updateWith(formHasBeenSubmitted: true, formIsLoading: true);
    try {
      if (formType == SignInWithEmailFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserInWithEmailAndPassword(email, password);
      }
    } catch (error) {
      updateWith(formIsLoading: false);
      rethrow;
    }
  }

  void updateWith({
    String email,
    String password,
    SignInWithEmailFormType formType,
    bool formIsLoading,
    bool formHasBeenSubmitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.formIsLoading = formIsLoading ?? this.formIsLoading;
    this.formHasBeenSubmitted =
        formHasBeenSubmitted ?? this.formHasBeenSubmitted;
    notifyListeners();
  }
}
