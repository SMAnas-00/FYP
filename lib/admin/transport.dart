// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addTransportScreen extends StatefulWidget {
  const addTransportScreen({super.key});

  @override
  State<addTransportScreen> createState() => _addTransportScreenState();
}

class _addTransportScreenState extends State<addTransportScreen> {
  List<XFile> selectedImages = [];
  List<String> imageUrls = [];
  final ImagePicker imagePicker = ImagePicker();
  bool loading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth user = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  var did = DateTime.now().millisecondsSinceEpoch;
  final _formKey = GlobalKey<FormState>();
  final vehicleNameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final numberOfSeatsControleer = TextEditingController();
  final priceController = TextEditingController();
  final pickupCntroller = TextEditingController();
  final cityController = TextEditingController();

  DetailsResult? pickupPosition;

  late FocusNode pickupFocusNode;

  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions = [];
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    String apiKey = "AIzaSyDNzkszHrT2L0zwdhK0DzVK46aqO7n5lxk";
    googlePlace = GooglePlace(apiKey);
    pickupFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pickupFocusNode.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future<void> selectImages() async {
    final pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages = pickedFiles;
      });
    }
  }

  Future<void> uploadImages(String hotelId) async {
    try {
      for (var imageFile in selectedImages) {
        final Reference storageReference = storage.ref().child(
            'transport_image/$hotelId/${DateTime.now().millisecondsSinceEpoch}');
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

  Future<void> addTransport() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      debugPrint("Form is vaid ");
      debugPrint('Data for login ');
      var did = DateTime.now().microsecondsSinceEpoch;

      final userData = await firestore
          .collection('app')
          .doc('Users')
          .collection('Signup')
          .doc(user.currentUser!.uid)
          .get();

      try {
        setState(() {
          loading = true;
        });
        await firestore
            .collection('app')
            .doc('Services')
            .collection('Transport')
            .doc('${user.currentUser!.uid}$did')
            .set({
          'vehicle_name': vehicleNameController.text,
          'vehicle_number': vehicleNumberController.text,
          'pick_up': pickupCntroller.text,
          'pickup_lat': pickupPosition!.geometry!.location!.lat!,
          'pickup_lng': pickupPosition!.geometry!.location!.lng!,
          'price': int.parse(priceController.text),
          'total_seats': numberOfSeatsControleer.text,
          'city': cityController.text,
          'driver_number': userData['First_name'],
          'driver_contact': userData['Contact'],
          'trans_id': 'tr${did.toString()}',
          'admin_id': user.currentUser!.uid,
          'transport_imageURL': imageUrls,
        });

        Fluttertoast.showToast(msg: 'Transport Created successfully');
      } catch (e) {
        debugPrint(e.toString());
      }
      vehicleNameController.clear();
      vehicleNumberController.clear();
      numberOfSeatsControleer.clear();
      priceController.clear();
      pickupCntroller.clear();
      cityController.clear();
      setState(() {
        selectedImages.clear();
        imageUrls.clear();
        loading = false;
      });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

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
                  controller: vehicleNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Name Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: vehicleNumberController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Number Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: pickupCntroller,
                  focusNode: pickupFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Pickup Location',
                    suffixIcon: pickupCntroller.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                predictions = [];
                                pickupCntroller.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.clear_outlined,
                              color: Color.fromARGB(255, 29, 165, 153),
                            ))
                        : null,
                  ),
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) debounce!.cancel();
                    debounce = Timer(const Duration(milliseconds: 1000), () {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                        setState(() {
                          predictions = [];
                        });
                      } else {
                        setState(() {
                          predictions = [];
                          pickupPosition = null;
                        });
                      }
                    });
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 29, 165, 153),
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(predictions[index].description.toString()),
                      onTap: () async {
                        final placeId = predictions[index].placeId!;
                        final details = await googlePlace.details.get(placeId);
                        if (details != null &&
                            details.result != null &&
                            mounted) {
                          if (pickupFocusNode.hasFocus) {
                            setState(() {
                              pickupPosition = details.result;
                              pickupCntroller.text = details.result!.name!;
                              predictions = [];
                            });
                          }
                        }
                      },
                    );
                  },
                ),
                TextFormField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: numberOfSeatsControleer,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Number of Seats'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seats Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Fair for the trip per day'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fair Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
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
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      backgroundColor: const Color.fromARGB(255, 29, 165, 153),
                    ),
                    onPressed: () {
                      addTransport();
                    },
                    child: loading == true
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Add Transport',
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
