import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forrent/dataModels/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  UserModel? theUser;

  String? phoneNumber;
  String? smsCode;
  String? verificationID;
  String? userName;

  void setPhoneNumber(String phoneNum) {
    phoneNumber = phoneNum;
    notifyListeners();
  }

  void setTheSmsCode(String theSmsCode) {
    smsCode = theSmsCode;
    notifyListeners();
  }

  void setTheVerificationID(String theVerificationID) {
    debugPrint(theVerificationID);
    verificationID = theVerificationID;
    notifyListeners();
  }

  void setTheUserName(String theUserName) {
    debugPrint(theUserName);
    userName = theUserName;
    notifyListeners();
  }

  void setTheGUser(UserModel theUserModel) {
    debugPrint(theUserModel.phone);
    theUser = theUserModel;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint('verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('failed ${e.toString()}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setTheVerificationID(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifySmsCode() async {
// returns a user credential
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: verificationID!, smsCode: smsCode!);

    UserCredential _userCredential =
        await _auth.signInWithCredential(_credential);
    late UserModel _gUser;
    await _firebaseMessaging.getToken().then((token) {
      _gUser = UserModel(
          email: '',
          username: userName,
          id: _userCredential.user!.uid,
          phone: _userCredential.user!.phoneNumber!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          imgurl: '',
          token: token);
    });

    await addtheUserToTheDatabase(_gUser);
  }

  verifySmsCodeLogin() async {
// returns a user credential
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: verificationID!, smsCode: smsCode!);

    UserCredential _userCredential =
        await _auth.signInWithCredential(_credential);
  }

  Future<void> addtheUserToTheDatabase(UserModel gUser) async {
    await _firestore
        .collection('users')
        .doc(gUser.id)
        .set(gUser.toMap(), SetOptions(merge: true));

    setTheGUser(gUser);
  }

  //singin anonymously
  Future<void> signInAnonymously() async {
    try {
      UserCredential _userCredential = await _auth.signInAnonymously();
      late UserModel _gUser;
      await _firebaseMessaging.getToken().then((token) {
        _gUser = UserModel(
            email: '',
            username: 'Guest',
            id: _userCredential.user!.uid,
            phone: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            imgurl: '',
            token: token);
      });

      await addtheUserToTheDatabase(_gUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //loout the user
  Future<void> signOut() async {
    await _auth.signOut();
    theUser = null;
    notifyListeners();
  }

  // check if the user logged in or not
  Future<bool> isLoggedIn() async {
    final _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
