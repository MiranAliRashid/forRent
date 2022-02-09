import 'package:flutter/material.dart';
import 'package:forrent/screens/startScreen/start_screen.dart';
import 'package:forrent/services/auth_handler.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: "/", routes: {
      "/": (context) => const AuthHandlerScreen(),
      "/startScreen": (context) => StartScreen(),
    });
  }
}
