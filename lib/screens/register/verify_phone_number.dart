import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNumber extends StatelessWidget {
  VerifyPhoneNumber({Key? key, this.verificationID, this.userName})
      : super(key: key);
  FirebaseAuth _auth = FirebaseAuth.instance;
  final String? verificationID;
  final String? userName;

  String? smsCode;

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
      body: SafeArea(
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              // verify button

              general_button(
                onpressed: () async {
                  smsCode = smsCode!.trim();
                  Provider.of<AuthService>(context, listen: false)
                      .setTheSmsCode(smsCode!);
                  await Provider.of<AuthService>(context, listen: false)
                      .verifySmsCode();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                text: 'Verify Phone Number',
              )
            ],
          ),
        ),
      ),
    );
  }
}
