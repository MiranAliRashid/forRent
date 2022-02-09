import 'package:flutter/material.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:provider/provider.dart';

class AuthHandlerScreen extends StatelessWidget {
  const AuthHandlerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.data == true) {
            //user is logged in so redirect to home
            return Text("User is logged in");
          }
          //user is not logged in so redirect to login
          return Text("not logged in");
        },
      ),
    );
  }
}
