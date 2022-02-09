import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: "/", routes: {
      //"/": (context) => HomePage(),
      //"/second": (context) => SecondPage(),
      //"/third": (context) => ThirdPage(),
    });
  }
}
