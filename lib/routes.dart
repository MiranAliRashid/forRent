import 'package:flutter/material.dart';
import 'package:forrent/screens/loginScreen/login_screen.dart';
import 'package:forrent/screens/loginScreen/login_verefication.dart';
import 'package:forrent/screens/navConfigScreen/nav_config_screen.dart';
import 'package:forrent/screens/register/register_screen.dart';
import 'package:forrent/screens/startScreen/start_screen.dart';
import 'package:forrent/services/auth_handler.dart';

import 'screens/register/verify_phone_number.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: "/", routes: {
      "/": (context) => const AuthHandlerScreen(),
      "/login": (context) => LoginScreen(),
      "/register": (context) => RegisterScreen(),
      "/verifPyhoneNumber": (context) => VerifyPhoneNumber(),
      "/Loginvirefication": (context) => LoginVirefication(),
    });
  }
}
