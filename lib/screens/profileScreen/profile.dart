import 'dart:io';
import 'dart:math';

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
    if (_auth.currentUser!.phoneNumber != null) {
      // UserModel user = Provider.of<AuthService>(context).theUser!;
      if (_auth.currentUser == null) {
        return const Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Text('No user found'),
          ),
        );
      } else {
        Provider.of<AuthService>(context).getUserById(_auth.currentUser!.uid);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 239, 248, 248),
            foregroundColor: const Color.fromARGB(255, 62, 128, 177),
            centerTitle: true,
            elevation: 0,
            title: Text('Profile'),
          ),
          body: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: Provider.of<AuthService>(context, listen: false)
                  .getUserById(_auth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 239, 248, 248),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 120),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 87),
                            alignment: Alignment.topLeft,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(105, 0, 0, 0),
                                  offset: Offset(0, -2),
                                  blurRadius: 1,
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
                                          fontSize: 40,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("phone : "),
                                      ),
                                      Text(
                                        snapshot.data.phone,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    general_button(
                                      onpressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return EditProfileImage();
                                            }).then((value) => setState(() {}));
                                      },
                                      text: 'Edit Profile ',
                                      backgroundColor:
                                          Color.fromARGB(255, 189, 221, 245),
                                      //child: Text("Edit"),
                                      // style: ButtonStyle(
                                      //   backgroundColor:
                                      //       MaterialStateProperty.all<Color>(
                                      //           Color.fromARGB(105, 0, 0, 0)),
                                      //   shape: MaterialStateProperty.all<
                                      //           RoundedRectangleBorder>(
                                      //       RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(12.0),
                                      //   )),
                                      // ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    general_button(
                                      onpressed: () {
                                        Provider.of<AuthService>(context,
                                                listen: false)
                                            .signOut()
                                            .then((value) => Navigator.popUntil(
                                                context,
                                                ModalRoute.withName('/')));
                                      },
                                      text: "logout",
                                      backgroundColor:
                                          Color.fromARGB(255, 113, 173, 219),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              snapshot.data.imgurl != ""
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 62, 128, 177),
                                        radius: 80,
                                        backgroundImage: NetworkImage(
                                          snapshot.data.imgurl,
                                        ),
                                      ),
                                    )
                                  : const Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 62, 128, 177),
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
          ),
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 248, 248),
          foregroundColor: const Color.fromARGB(255, 62, 128, 177),
          centerTitle: true,
          elevation: 0,
          title: const Text('ForRent'),
        ),
        body: Container(
          color: const Color.fromARGB(255, 216, 216, 216),
          child: Center(
            child: Card(
                elevation: 1,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You don\'t have an account \n Please Register or login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("for you to able to see your profile"),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: general_button(
                          text: 'Register',
                          onpressed: () {
                            Navigator.pushNamed(context, '/register')
                                .then((value) {
                              setState(() {});
                            });
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 136, 191, 233),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: general_button(
                          text: 'Login',
                          onpressed: () {
                            Navigator.pushNamed(context, '/login')
                                .then((value) {
                              setState(() {});
                            });
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 136, 191, 233),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
    }
  }
}

class EditProfileImage extends StatefulWidget {
  EditProfileImage({Key? key}) : super(key: key);

  @override
  State<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  TextEditingController _usernameController = TextEditingController();
  String? _theDlUrl;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedProfileImg;
  @override
  Widget build(BuildContext context) {
    User? theUser = _auth.currentUser;
    return AlertDialog(
      title: Center(child: Text('Edit Profile Image')),
      content: Container(
        height: 300,
        child: Column(
          children: [
            _selectedProfileImg == null
                ? Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 200,
                    child: const Center(
                      child: Text(
                        'No Image Selected',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 62, 128, 177),
                      radius: 80,
                      backgroundImage:
                          FileImage(File(_selectedProfileImg!.path)),
                    ),
                  ),
            OutlinedButton(
                onPressed: () async {
                  // add image picker package
                  _selectedProfileImg =
                      await _imagePicker.pickImage(source: ImageSource.gallery);

                  setState(() {});
                  // pick an image from the gallery
                },
                child: const Text('change your profile image')),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'change your username',
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            general_button(
              width: 120,
              text: 'Save',
              onpressed: () async {
                String username = _usernameController.text;
                if (_selectedProfileImg != null && username.isNotEmpty) {
                  await uploadTheSelectedFile(theUser!.uid);
                  Provider.of<AuthService>(context, listen: false)
                      .updateProfile(
                          id: theUser.uid,
                          imgurl: _theDlUrl,
                          username: username)
                      .then((value) => Navigator.pop(context));
                } else if (_selectedProfileImg != null && username.isEmpty) {
                  await uploadTheSelectedFile(theUser!.uid);
                  Provider.of<AuthService>(context, listen: false)
                      .updateProfile(id: theUser.uid, imgurl: _theDlUrl)
                      .then((value) => Navigator.pop(context));
                } else if (_theDlUrl == null && username.isNotEmpty) {
                  Provider.of<AuthService>(context, listen: false)
                      .updateProfile(id: theUser!.uid, username: username)
                      .then((value) => Navigator.pop(context));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Color.fromARGB(255, 255, 125, 125),
                        content: Text('there was an error')),
                  );
                }
              },
              backgroundColor: Color.fromARGB(255, 113, 189, 219),
            ),
            const SizedBox(
              width: 20,
            ),
            general_button(
              width: 120,
              text: 'Cancel',
              onpressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Color.fromARGB(255, 113, 173, 219),
            ),
          ],
        )
      ],
    );
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
