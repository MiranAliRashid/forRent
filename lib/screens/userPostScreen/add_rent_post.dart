import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forrent/dataModels/rent_model.dart';
import 'package:forrent/dataModels/user_model.dart';
import 'package:forrent/providers/auth_service.dart';
import 'package:forrent/services/rent_services.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddRentPost extends StatefulWidget {
  const AddRentPost({Key? key}) : super(key: key);

  @override
  State<AddRentPost> createState() => _AddRentPostState();
}

class _AddRentPostState extends State<AddRentPost> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedProfileImg;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _theDlUrl;

  // Initial Selected Value
  String dropdownvalue = 'City';

  // List of items in our dropdown menu
  var items = ['City', 'Sulaimaniyah', 'Hawler', 'Karkwk', 'Dhok', 'Halabja'];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User? theUser = _auth.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        foregroundColor: const Color.fromARGB(255, 62, 128, 177),
        centerTitle: true,
        elevation: 0,
        title: const Text('Add Rent Post'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 239, 248, 248),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              _selectedProfileImg == null
                  ? Container(
                      alignment: Alignment.center,
                      height: 200,
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
                  : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            File(_selectedProfileImg!.path),
                          ),
                        ),
                      ),
                    ),
              TextButton(
                  onPressed: () async {
                    // add image picker package
                    _selectedProfileImg = await _imagePicker.pickImage(
                        source: ImageSource.gallery);

                    setState(() {});
                    // pick an image from the gallery
                  },
                  child: const Text('upload house image')),
              DropdownButton(
                isExpanded: true,
                underline: Container(
                  height: 1,
                  color: Colors.black,
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rent Price',
                ),
              ),
              const SizedBox(height: 20),
              general_button(
                  onpressed: () async {
                    if (_selectedProfileImg != null) {
                      if (dropdownvalue != "City") {
                        if (_addressController.text.isNotEmpty &&
                            _priceController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty) {
                          await uploadTheSelectedFile(theUser!.uid);
                          RentServices _rentServices = RentServices();
                          RentModel newpost = RentModel(
                            address: _addressController.text,
                            discreption: _descriptionController.text,
                            rentprice: _priceController.text,
                            city: dropdownvalue,
                            imgurl: _theDlUrl!,
                            postdate: Timestamp.now(),
                            id: "",
                          );
                          await _rentServices
                              .addNewRentPost(theUser.uid, newpost)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 125, 125),
                                content: Text('please fill out the inputs')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 125, 125),
                              content: Text('please select a City')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Color.fromARGB(255, 255, 125, 125),
                            content: Text('please upload an image')),
                      );
                    }
                  },
                  text: 'Add Post'),
            ],
          ),
        ),
      ),
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
      debugPrint("dl =======> " + _theDlUrl!);
    });
    return _theDlUrl;
  }
}
