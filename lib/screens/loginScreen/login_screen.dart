import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String cuntryCode = '+964';
  final TextEditingController _phoneNumberController = TextEditingController();
  late String _phoneNumber;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 248, 248),
          foregroundColor: const Color.fromARGB(255, 62, 128, 177),
          centerTitle: true,
          elevation: 0,
          title: const Text('Login'),
        ),
        body: Container(
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 239, 248, 248),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
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
                        color: Color.fromARGB(255, 47, 101, 248),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 100),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        IntlPhoneField(
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value == null || value.length < 14) {
                              debugPrint(value.toString());

                              return 'Please enter a phone number';
                            }
                            debugPrint(value.toString());

                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'IQ',
                          onCountryChanged: (value) {
                            cuntryCode = "+" + value.dialCode;
                            debugPrint(cuntryCode);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        general_button(
                            onpressed: () async {
                              _phoneNumber = cuntryCode +
                                  _phoneNumberController.text.trim();
                              if (_formKey.currentState!.validate()) {
                                if (_phoneNumberController.text.isNotEmpty) {
                                  Provider.of<AuthService>(context,
                                          listen: false)
                                      .setPhoneNumber(_phoneNumber);
                                  await Provider.of<AuthService>(context,
                                          listen: false)
                                      .verifyPhoneNumber()
                                      .then((value) =>
                                          Navigator.of(context).pushNamed(
                                            "/Loginvirefication",
                                          ));
                                }
                              }
                            },
                            text: "Login"),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
