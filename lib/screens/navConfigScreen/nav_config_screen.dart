import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:provider/provider.dart';

class NavConfigScreen extends StatefulWidget {
  NavConfigScreen({Key? key}) : super(key: key);

  @override
  State<NavConfigScreen> createState() => _NavConfigScreenState();
}

class _NavConfigScreenState extends State<NavConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).signOut().then(
                (value) =>
                    Navigator.popUntil(context, ModalRoute.withName('/')));
          },
          child: Text(
            'logout',
          )),
    );
  }
}
