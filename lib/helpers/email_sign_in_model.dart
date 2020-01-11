import 'package:infobootleg/helpers/validators.dart';

enum SignInWithEmailFormType { signIn, register }

class SignInWithEmailModel with EmailAndPasswordValidators {
  SignInWithEmailModel({
    this.email = "",
    this.password = "",
    this.formType = SignInWithEmailFormType.signIn,
    this.formIsLoading = false,
    this.formHasBeenSubmitted = false,
  });

  final String email;
  final String password;
  final SignInWithEmailFormType formType;
  final bool formHasBeenSubmitted;
  final bool formIsLoading;

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

  SignInWithEmailModel copyWith({
    String email,
    String password,
    SignInWithEmailFormType formType,
    bool formIsLoading,
    bool formHasBeenSubmitted,
  }) {
    return SignInWithEmailModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      formIsLoading: formIsLoading ?? this.formIsLoading,
      formHasBeenSubmitted: formHasBeenSubmitted ?? this.formHasBeenSubmitted,
    );
  }
}
