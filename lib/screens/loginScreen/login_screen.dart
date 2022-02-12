import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        foregroundColor: Color.fromARGB(255, 62, 128, 177),
        centerTitle: true,
        elevation: 0,
        title: Text('Login'),
      ),
      body: Center(
        child: Text('LoginScreen'),
      ),
    );
  }
}
