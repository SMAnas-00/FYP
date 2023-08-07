import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class addFlightScreen extends StatefulWidget {
  const addFlightScreen({super.key});

  @override
  State<addFlightScreen> createState() => _addFlightScreenState();
}

class _addFlightScreenState extends State<addFlightScreen> {
  File? image;
  final picker = ImagePicker();
  String imageUrl = '';
  FirebaseAuth user = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _departure = TextEditingController();
  final _destination = TextEditingController();
  final _flightprice = TextEditingController();
  final _flightname = TextEditingController();
  var did = DateTime.now().millisecondsSinceEpoch;

  addFlight() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      print("Form is vaid ");

      print('Data for login ');

      try {
        await firestore
            .collection('app')
            .doc('Services')
            .collection('Flight')
            .doc('${user.currentUser!.uid}$did')
            .set({
          'airline_name': _flightname.text.toUpperCase(),
          'departure': _departure.text.toUpperCase(),
          'destination': _destination.text.toUpperCase(),
          'ticket_price': int.parse(_flightprice.text),
          'admin_id': user.currentUser!.uid,
          'flight_imageURL': imageUrl,
          'flight_id': 'fl${user.currentUser!.uid}'
        });
        setState(() {
          imageUrl = '';
        });
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: '${e.toString()}');
      }
    }
    _departure.clear();
    _destination.clear();
    _flightname.clear();
    _flightprice.clear();
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
        firebase_storage.FirebaseStorage.instance.ref('/flightimg/$did');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
      Fluttertoast.showToast(msg: 'image uploaded successfully');
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: '${error.toString()}');
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
        title: Text('ADD FLIGHT',
            style: TextStyle(color: Color.fromARGB(255, 29, 165, 153))),
        backgroundColor: Colors.white,
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _flightname,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'AIRLINE NAME',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _departure,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'DEPARTURE'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Departure Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _destination,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'DESTINATION'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'DESTINATION Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _flightprice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'FLIGHT PRICE'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'FLIGHT PRICE Required';
                    }
                    return null;
                  },
                ),
                SizedBox(
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
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      backgroundColor: Color.fromARGB(255, 29, 165, 153)),
                  onPressed: addFlight,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
