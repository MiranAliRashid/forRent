import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:forrent/widgets/inputs.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  late String username;
  late String phoneNumber;
  String cuntrycode = "+964";
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        foregroundColor: Color.fromARGB(255, 62, 128, 177),
        centerTitle: true,
        elevation: 0,
        title: Text('Register'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 239, 248, 248),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    generalInput(
                        hintText: "User Name",
                        controller: _usernameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    // generalInput(
                    //     hintText: "Phone Number :+964750xxxxxxx",
                    //     controller: _phoneNumberController,
                    //     validator: (value) {
                    //       if (value.isEmpty) {
                    //         return 'Please enter a phone number';
                    //       }
                    //       return null;
                    //     }),
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
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'IQ',
                      onCountryChanged: (value) {
                        cuntrycode = "+" + value.dialCode;
                        debugPrint(cuntrycode);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                              _selectedDate != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(_selectedDate!)
                                  : "Date of birth",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 62, 128, 177),
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 5),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 207, 207, 207),
                                offset: Offset(2, 3),
                                blurRadius: 0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2040),
                                ).then((selectedDate) {
                                  if (selectedDate == null) {
                                    return;
                                  } else {
                                    setState(() {
                                      _selectedDate = (selectedDate);
                                    });
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.date_range,
                                size: 40,
                                color: Color.fromARGB(255, 62, 128, 177),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    general_button(
                        onpressed: () async {
                          if (_formKey.currentState!.validate()) {
                            username = _usernameController.text.trim();
                            phoneNumber =
                                cuntrycode + _phoneNumberController.text.trim();

                            if (username.isNotEmpty &&
                                _phoneNumberController.text.isNotEmpty) {
                              Provider.of<AuthService>(context, listen: false)
                                  .setTheUserName(username);
                              Provider.of<AuthService>(context, listen: false)
                                  .setPhoneNumber(phoneNumber);

                              await Provider.of<AuthService>(context,
                                      listen: false)
                                  .verifyPhoneNumber()
                                  .then((value) =>
                                      Navigator.of(context).pushNamed(
                                        "/verifPyhoneNumber",
                                      ));
                            } else {
                              showErrorDialog("Please fill phone number");
                            }
                          }
                        },
                        text: "Register"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //make alert dialog for error
  void showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('warnining  !'),
        content: Text(error),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
