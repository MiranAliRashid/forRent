import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forrent/routes.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    child: Routes(),
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthService(),
      ),
    ],
  ));
}
