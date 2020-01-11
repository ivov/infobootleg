import 'package:flutter/material.dart';

import 'auth.dart';

// WARNING: Currently NOT in use. Only for testing and learning about InheritedWidget with scoped access.

class AuthProvider extends InheritedWidget {
  AuthProvider({
    @required this.auth,
    @required this.child,
  });
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider provider = context.inheritFromWidgetOfExactType(AuthProvider);
    return provider.auth;
  }
}
