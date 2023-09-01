// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class addTransportScreen extends StatefulWidget {
  const addTransportScreen({super.key});

  @override
  State<addTransportScreen> createState() => _addTransportScreenState();
}

class _addTransportScreenState extends State<addTransportScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var did = DateTime.now().millisecondsSinceEpoch;
  final _formKey = GlobalKey<FormState>();
  final _WhereTo = TextEditingController();
  final _WhereFrom = TextEditingController();
  final _Fairforthetrip = TextEditingController();
  final _Transtype = TextEditingController();
  FirebaseAuth user = FirebaseAuth.instance;
  File? image;
  final picker = ImagePicker();
  String imageUrl = '';

  addTransport() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      debugPrint("Form is vaid ");
      debugPrint('Data for login ');
      var did = DateTime.now().microsecondsSinceEpoch;

      try {
        await firestore
            .collection('app')
            .doc('Services')
            .collection('Transport')
            .doc('$did')
            .set({
          'Pick_up': _WhereFrom.text,
          'Destination': _WhereTo.text,
          'Fair': int.parse(_Fairforthetrip.text),
          'Transport_type': _Transtype.text,
          'Trans_id': 'tr${did.toString()}',
          'admin_id': user.currentUser!.uid,
          'transport_imageURL': imageUrl,
        });
        setState(() {
          imageUrl = '';
        });
      } on FirebaseException catch (e) {
        debugPrint(e.toString());
      }
      _WhereFrom.clear();
      _WhereTo.clear();
      _Fairforthetrip.clear();
      _Transtype.clear();
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> setImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/transportimg/$did');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
      Fluttertoast.showToast(msg: 'image uploaded successfully');
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
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
        title: const Text('Add New Transport',
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _WhereTo,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Destination Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _WhereFrom,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Pick Up'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Destination Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _Fairforthetrip,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Fair for the trip'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fair Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _Transtype,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Type of Transit'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.teal[300],
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.teal[300],
                                borderRadius: BorderRadius.circular(100)),
                            child: imageUrl == ""
                                ? ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(48.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.teal[300],
                                      ),
                                    ),
                                  )
                                : ClipOval(
                                    child: SizedBox.fromSize(
                                        size: const Size.fromRadius(48.0),
                                        child: Image.network(imageUrl)),
                                  )),
                      ),
                      Positioned(
                          bottom: 0,
                          right: -25,
                          child: RawMaterialButton(
                            onPressed: () {
                              setImage();
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(15.0),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.teal,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      backgroundColor: const Color.fromARGB(255, 29, 165, 153)),
                  onPressed: addTransport,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
