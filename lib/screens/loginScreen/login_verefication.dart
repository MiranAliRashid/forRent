import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_service.dart';
import '../../widgets/buttons.dart';

class LoginVirefication extends StatefulWidget {
  LoginVirefication({Key? key, this.verificationID, this.userName})
      : super(key: key);
  final String? verificationID;
  final String? userName;

  @override
  State<LoginVirefication> createState() => _LoginVireficationState();
}

class _LoginVireficationState extends State<LoginVirefication> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String? smsCode;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    String phoneNumber =
        Provider.of<AuthService>(context, listen: true).phoneNumber!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 248, 248),
          foregroundColor: Color.fromARGB(255, 62, 128, 177),
          centerTitle: true,
          elevation: 0,
          title: const Text('Confirm Phone Number'),
        ),
        body: loading == false
            ? SafeArea(
                child: Container(
                  color: const Color.fromARGB(255, 239, 248, 248),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'A Verification Code is sent to \n $phoneNumber',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      const Text(
                        'Enter Verification Code',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 62, 128, 177),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // text field for recieved code from firebase auth
                      TextField(
                        onChanged: (code) {
                          smsCode = code;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Verification code',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
                      // verify button

                      general_button(
                        onpressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (smsCode == null || smsCode!.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter the code",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 247, 150, 143),
                                textColor: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16.0);
                            setState(() {
                              loading = false;
                            });
                          } else {
                            smsCode = smsCode!.trim();
                            Provider.of<AuthService>(context, listen: false)
                                .setTheSmsCode(smsCode!);
                            await Provider.of<AuthService>(context,
                                    listen: false)
                                .verifySmsCode()
                                .then((value) {
                              if (value == "success") {
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              } else if (value == "invalid-verification-code") {
                                Fluttertoast.showToast(
                                    msg: value,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 247, 150, 143),
                                    textColor: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16.0);
                                setState(() {
                                  loading = false;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "there is an error please check your internet connetion and try again",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 247, 150, 143),
                                    textColor: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16.0);
                                setState(() {
                                  loading = false;
                                });
                              }
                            });
                          }
                        },
                        text: 'Verify Phone Number',
                      )
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
