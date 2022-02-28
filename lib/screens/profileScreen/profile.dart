import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forrent/dataModels/user_model.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_service.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String? _theDlUrl;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedProfileImg;
  @override
  Widget build(BuildContext context) {
    // UserModel user = Provider.of<AuthService>(context).theUser!;
    if (_auth.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user found'),
        ),
      );
    } else {
      Provider.of<AuthService>(context).getUserById(_auth.currentUser!.uid);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 248, 248),
          foregroundColor: const Color.fromARGB(255, 62, 128, 177),
          centerTitle: true,
          elevation: 0,
          title: Text('Profile'),
        ),
        body: FutureBuilder(
          future: Provider.of<AuthService>(context, listen: false)
              .getUserById(_auth.currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Container(
                    color: const Color.fromARGB(255, 239, 248, 248),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 120),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          offset: Offset(0, 5),
                          blurRadius: 8,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 90,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data.username,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("phone : "),
                            ),
                            Text(
                              snapshot.data.phone,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            general_button(
                              onpressed: () {
                                Provider.of<AuthService>(context, listen: false)
                                    .signOut()
                                    .then((value) => Navigator.popUntil(
                                        context, ModalRoute.withName('/')));
                              },
                              text: "logout",
                              backgroundColor:
                                  Color.fromARGB(255, 113, 173, 219),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          const Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 62, 128, 177),
                              radius: 80,
                              child: Text(
                                "image",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              _selectedProfileImg = await _imagePicker
                                  .pickImage(source: ImageSource.gallery);
                            },
                            child: Text("Edit"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(105, 0, 0, 0)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    }
  }

  Future<String?> uploadTheSelectedFile(String uid) async {
    //selected image as file
    File _theImageFile = File(_selectedProfileImg!.path);
    String name = _theImageFile.path.split('/').last;

    //upload the selected image
    await _firebaseStorage
        .ref()
        .child('users/$uid/$name')
        .putFile(_theImageFile)
        .then((p) async {
      _theDlUrl = await p.ref.getDownloadURL();
    });
    return _theDlUrl;
  }
}