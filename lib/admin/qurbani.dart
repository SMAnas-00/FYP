import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Qurbani extends StatefulWidget {
  const Qurbani({super.key});

  @override
  State<Qurbani> createState() => _QurbaniState();
}

class _QurbaniState extends State<Qurbani> {
  List<XFile> selectedImages = [];
  List<String> imageUrls = [];
  final ImagePicker imagePicker = ImagePicker();
  bool loading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  var did = DateTime.now().millisecondsSinceEpoch;
  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedAnimalType;

  Future<void> selectImages() async {
    final pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages = pickedFiles;
      });
    }
  }

  Future<void> uploadImages(String animalId) async {
    try {
      for (var imageFile in selectedImages) {
        final Reference storageReference = storage.ref().child(
            'animal_image/$animalId/${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask =
            storageReference.putFile(File(imageFile.path));

        final TaskSnapshot downloadUrl = await uploadTask;
        final String imageUrl = await downloadUrl.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error uploading images: $e');
    }
  }

  Future<void> addAnimal() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      debugPrint("Form is vaid ");
      debugPrint('Data for login ');
      var did = DateTime.now().microsecondsSinceEpoch;
      try {
        setState(() {
          loading = true;
        });
        final animalId = '${auth.currentUser!.uid}$did';
        final userDOc = await firestore
            .collection('app')
            .doc('Users')
            .collection('Signup')
            .doc(auth.currentUser!.uid)
            .get();
        await uploadImages(animalId);
        await firestore
            .collection('app')
            .doc('Services')
            .collection('Animal')
            .doc('${auth.currentUser!.uid}$did')
            .set({
          'admin_id': auth.currentUser!.uid,
          'animal_price': int.parse(priceController.text),
          'weight': int.parse(weightController.text),
          'animal_images': imageUrls,
          'animal_name': selectedAnimalType,
          'animal_id': 'an$did',
          'manager_name': userDOc.data()?['First_name'],
          'manager_phone': userDOc.data()?['Contact'],
        });
        setState(() {
          selectedAnimalType = null;
        });
        Fluttertoast.showToast(msg: 'Animal Created successfully');
      } catch (e) {
        Fluttertoast.showToast(msg: "Something wrong");
      }
      priceController.clear();
      weightController.clear();
      setState(() {
        selectedImages.clear();
        imageUrls.clear();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[300],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Add Animal',
            style: TextStyle(color: Color.fromARGB(255, 29, 165, 153))),
        backgroundColor: Colors.white,
      ),
      body: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedAnimalType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedAnimalType = newValue;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'Sheep',
                          child: Text('Sheep'),
                        ),
                        DropdownMenuItem(
                          value: 'Goat',
                          child: Text('Goat'),
                        ),
                        DropdownMenuItem(
                          value: 'Camel',
                          child: Text('Camel'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Animal Type',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Animal Type Required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Animal Weight in KG',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Animal Weight Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Animal Price',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Animal Price Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    backgroundColor: const Color.fromARGB(255, 29, 165, 153),
                  ),
                  onPressed: () {
                    selectImages();
                  },
                  child: const Text(
                    'Select Images',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 10),
                // Display Selected Images
                Wrap(
                  children: selectedImages.map((image) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.file(
                        File(image.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      backgroundColor: const Color.fromARGB(255, 29, 165, 153),
                    ),
                    onPressed: () {
                      addAnimal();
                    },
                    child: loading == true
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Add Animal',
                            style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
