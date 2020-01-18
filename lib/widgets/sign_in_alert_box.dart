import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

import 'package:infobootleg/widgets/alert_box.dart';

class SignInAlertBox extends AlertBox {
  SignInAlertBox({
    @required this.title,
    @required this.exception,
  }) : super(
          title: title,
          content: _message(exception),
        );

  final String title;
  final PlatformException exception;

  static Map<String, String> _errors = {
    "ERROR_WEAK_PASSWORD": "La contraseña es demasiado sencilla.",
    "ERROR_INVALID_CREDENTIAL": "Correo o contraseña inválidos.",
    "ERROR_INVALID_EMAIL": "Correo en formato inválido.",
    "ERROR_EMAIL_ALREADY_IN_USE": "Correo ya registrado.",
    "ERROR_WRONG_PASSWORD": "Contraseña inválida.",
    "ERROR_USER_NOT_FOUND": "Usuario inexistente.",
    "ERROR_USER_DISABLED": "Usuario inhabilitado.",
    "ERROR_TOO_MANY_REQUESTS": "Demasiadas solicitudes.",
    "ERROR_OPERATION_NOT_ALLOWED": "Operación no permitida."
  };

  static String _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }
}
