import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forrent/dataModels/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

    debugPrint('before');

    UserCredential _userCredential =
        await _auth.signInWithCredential(_credential);

    UserModel _gUser = UserModel(
        email: '',
        username: userName ?? 'no name',
        id: _userCredential.user!.uid,
        phone: _userCredential.user!.phoneNumber!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imgurl: '',
        token: '');

    await addtheUserToTheDatabase(_gUser);
  }

  Future<void> addtheUserToTheDatabase(UserModel gUser) async {
    await _firestore
        .collection('users')
        .doc(gUser.id)
        .set(gUser.toMap(), SetOptions(merge: true));

    setTheGUser(gUser);
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
