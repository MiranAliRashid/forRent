import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:provider/provider.dart';

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
        color: const Color.fromARGB(255, 239, 248, 248),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
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
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  general_button(
                      onpressed: () {
                        Provider.of<AuthService>(context, listen: false)
                            .signInAnonymously()
                            .then((value) => Navigator.popUntil(
                                context, ModalRoute.withName('/')));
                      },
                      text: "looking for a house",
                      backgroundColor:
                          const Color.fromARGB(255, 214, 237, 255)),
                  const SizedBox(height: 20),
                  general_button(
                      onpressed: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      text: "login",
                      backgroundColor:
                          const Color.fromARGB(255, 214, 237, 255)),
                  const SizedBox(height: 40),
                  const Text("you don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 62, 128, 177),
                      )),
                  const SizedBox(height: 5),
                  general_button_withoutshasow(
                    onpressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    text: "register here!",
                    textColor: const Color.fromARGB(255, 62, 128, 177),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
