import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forrent/firebase_options.dart';
import 'package:forrent/routes.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    child: const Routes(),
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthService(),
      ),
    ],
  ));
}
