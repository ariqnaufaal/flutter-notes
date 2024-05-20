import 'package:flutter/material.dart';
import 'package:note_flutter/screens/signin.dart';
import 'package:note_flutter/screens/signup.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInScreen(onTap: togglePages);
    } 
    else {
      return SignUpScreen(onTap: togglePages);
    }
  }
}