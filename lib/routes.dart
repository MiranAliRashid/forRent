import 'package:flutter/material.dart';
import 'package:forrent/screens/loginScreen/login_screen.dart';
import 'package:forrent/screens/loginScreen/login_verefication.dart';
import 'package:forrent/screens/register/register_screen.dart';
import 'package:forrent/screens/userPostScreen/add_rent_post.dart';
import 'package:forrent/services/auth_handler.dart';
import 'screens/register/verify_phone_number.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => const AuthHandlerScreen(),
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          "/verifPyhoneNumber": (context) => const VerifyPhoneNumber(),
          "/Loginvirefication": (context) => const LoginVirefication(),
          "/addrentpost": (context) => const AddRentPost(),
        });
  }
}
