import 'package:flutter/material.dart';
import 'package:infobootleg/screens/home_screen.dart';
import 'package:infobootleg/screens/sign_in_screen.dart';
import 'package:infobootleg/services/auth.dart';

class LandingScreen extends StatefulWidget {
  final AuthBase auth;
  LandingScreen({this.auth});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User _user;

  @override
  void initState() {
    super.initState(); // called when this widget is inserted into widget tree
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInScreen(
          onSignIn: _updateUser,
          auth: widget.auth // implicit passing of FirebaseUser user
          );
    }
    return HomeScreen(onSignOut: () => _updateUser(null), auth: widget.auth);
  }
}
