import 'package:flutter/material.dart';
import 'package:forrent/widgets/buttons.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 239, 248, 248),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/FoRent.png'),
            ),
            const Text(
              'FoRent',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 62, 128, 177),
              ),
            ),
            const SizedBox(height: 20),
            general_button(
                onpressed: () {},
                text: "looking for a house",
                backgroundColor: Color.fromARGB(255, 214, 237, 255)),
            const SizedBox(height: 20),
            general_button(
                onpressed: () {},
                text: "login",
                backgroundColor: Color.fromARGB(255, 214, 237, 255)),
            const SizedBox(height: 40),
            Text("you don't have an account?",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 62, 128, 177),
                )),
            const SizedBox(height: 5),
            general_button_withoutshasow(
              onpressed: () {},
              text: "register here!",
              textColor: Color.fromARGB(255, 62, 128, 177),
            ),
          ],
        ),
      ),
    );
  }
}
