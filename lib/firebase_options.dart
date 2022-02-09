// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfX3bHKXXXrFtgwkoKmf-KZ2q_aCkoEVQ',
    appId: '1:725281008499:web:15cb0a953525b831b73306',
    messagingSenderId: '725281008499',
    projectId: 'forrent-ffe06',
    authDomain: 'forrent-ffe06.firebaseapp.com',
    storageBucket: 'forrent-ffe06.appspot.com',
    measurementId: 'G-YGR0VDCLGM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfwi3bQIGzjIkTLEiHyNsw8q1ip6EPTNs',
    appId: '1:725281008499:android:90a0ea485514a098b73306',
    messagingSenderId: '725281008499',
    projectId: 'forrent-ffe06',
    storageBucket: 'forrent-ffe06.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAY9HgvMRX2pfwp8R9otkoY0qmuguAG8Cs',
    appId: '1:725281008499:ios:35a4ccec31316ce9b73306',
    messagingSenderId: '725281008499',
    projectId: 'forrent-ffe06',
    storageBucket: 'forrent-ffe06.appspot.com',
    iosClientId: '725281008499-qg3fom368fio803rihblaerh67a62omn.apps.googleusercontent.com',
    iosBundleId: 'com.example.forrent',
  );
}
