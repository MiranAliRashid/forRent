import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    verificationID = theVerificationID;
    notifyListeners();
  }

  void setTheUserName(String theUserName) {
    userName = theUserName;
    notifyListeners();
  }

  void setTheGUser(UserModel theUserModel) {
    theUser = theUserModel;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint('verification completed');
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('failed ---->${e.toString()}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setTheVerificationID(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> verifySmsCode() async {
    try {
      PhoneAuthCredential _credential = PhoneAuthProvider.credential(
          verificationId: verificationID!, smsCode: smsCode!);

      UserCredential _userCredential =
          await _auth.signInWithCredential(_credential);

      //check if user is in the user collection
      DocumentSnapshot _userDoc = await _firestore
          .collection('users')
          .doc(_userCredential.user!.uid)
          .get();
      if (_userDoc.exists) {
        //find the user in the database
        UserModel usertrylogin = await _firestore
            .collection('users')
            .doc(_userCredential.user!.uid)
            .get()
            .then((value) =>
                UserModel.fromMap(value.data() as Map<String, dynamic>));

        setTheGUser(usertrylogin);
      } else {
        late UserModel _gUser;
        await _firebaseMessaging.getToken().then((token) {
          _gUser = UserModel(
              email: '',
              username: "user_" + Random().nextInt(1000000).toString(),
              id: _userCredential.user!.uid,
              phone: _userCredential.user!.phoneNumber!,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              imgurl: '',
              token: token);
        });
        theUser = _gUser;
        await addtheUserToTheDatabase(_gUser);
        return "success";
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      e.code;
      if (e.code == 'invalid-verification-code') {
        return e.code;
      }
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> addtheUserToTheDatabase(UserModel gUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(gUser.id)
          .set(gUser.toMap(), SetOptions(merge: true));

      setTheGUser(gUser);
    } catch (e) {
      throw (e.toString());
    }
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
      throw (e.toString());
    }
  }

  //get user form usercollection by id
  Future<UserModel> getUserById(String id) async {
    try {
      return await _firestore.collection('users').doc(id).get().then(
          (value) => UserModel.fromMap(value.data() as Map<String, dynamic>));
    } catch (e) {
      throw (e.toString());
    }
  }

  //update imgurl from user collection by id
  Future<void> updateProfile(
      {required String id, String? imgurl, String? username}) async {
    try {
      UserModel user = await getUserById(id);
      if (imgurl != null && username != null) {
        if (user.imgurl!.isNotEmpty) {
          FirebaseStorage.instance.refFromURL(user.imgurl!).delete();
          await _firestore
              .collection('users')
              .doc(id)
              .update({'imgurl': imgurl, 'username': username});
          //update the username from rent_posts colletion
          await _firestore
              .collection('users')
              .doc(id)
              .collection("rent_posts")
              .get()
              .then((doc) {
            for (var element in doc.docs) {
              _firestore
                  .collection('users')
                  .doc(id)
                  .collection("rent_posts")
                  .doc(element.id)
                  .update({'username': username});
            }
          });
        } else {
          await _firestore
              .collection('users')
              .doc(id)
              .update({'imgurl': imgurl, 'username': username});
        }
      } else if (imgurl != null && username == null) {
        if (user.imgurl!.isNotEmpty) {
          FirebaseStorage.instance.refFromURL(user.imgurl!).delete();
          await _firestore
              .collection('users')
              .doc(id)
              .update({'imgurl': imgurl});
        } else {
          await _firestore
              .collection('users')
              .doc(id)
              .update({'imgurl': imgurl});
        }
      } else if (imgurl == null && username != null) {
        await _firestore
            .collection('users')
            .doc(id)
            .update({'username': username});
        await _firestore
            .collection('users')
            .doc(id)
            .collection("rent_posts")
            .get()
            .then((doc) {
          for (var element in doc.docs) {
            _firestore
                .collection('users')
                .doc(id)
                .collection("rent_posts")
                .doc(element.id)
                .update({'username': username});
          }
        });
      } else {
        debugPrint("error on update profile");
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  //logout the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      theUser = null;
      notifyListeners();
    } catch (e) {
      throw (e.toString());
    }
  }

  // check if the user logged in or not
  Future<bool> isLoggedIn() async {
    try {
      final _currentUser = _auth.currentUser;
      if (_currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e.toString());
    }
  }
}
