import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';

class AddRentPost extends StatefulWidget {
  AddRentPost({Key? key}) : super(key: key);

  @override
  State<AddRentPost> createState() => _AddRentPostState();
}

class _AddRentPostState extends State<AddRentPost> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedProfileImg;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String? _theDlUrl;

  // Initial Selected Value
  String dropdownvalue = 'City';

  // List of items in our dropdown menu
  var items = [
    'City',
    'Suli',
    'Hawler',
  ];
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Center(
                        child: const Text(
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
                  child: Text('upload house image')),
              DropdownButton(
                isExpanded: true,
                underline: Container(
                  height: 1,
                  color: Colors.black,
                ),
                style: TextStyle(
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
                  onpressed: () {
                    if (_selectedProfileImg != null) {
                      if (dropdownvalue != "City") {
                        if (_addressController.text.isNotEmpty &&
                            _priceController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty) {
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

    //upload the selected image
    await _firebaseStorage
        .ref()
        .child('users/$uid')
        .putFile(_theImageFile)
        .then((p) async {
      _theDlUrl = await p.ref.getDownloadURL();
      debugPrint("dl =======> " + _theDlUrl!);
    });
    return _theDlUrl;
  }
}
