// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_place/google_place.dart';

class addHotelScreen extends StatefulWidget {
  const addHotelScreen({super.key});

  @override
  State<addHotelScreen> createState() => _addHotelScreenState();
}

class _addHotelScreenState extends State<addHotelScreen> {
  List<XFile> _selectedImages = [];
  List<String> _imageUrls = [];
  final ImagePicker _imagePicker = ImagePicker();
  bool loading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth user = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  final hotelNameController = TextEditingController();
  final hotelTypeController = TextEditingController();
  final singleRoomPriceController = TextEditingController();
  final connectedRoomPriceController = TextEditingController();
  final personPerRoomController = TextEditingController();
  final cityController = TextEditingController();
  final hotelImageController = TextEditingController();
  final hotelLocationController = TextEditingController();
  final descriptionController = TextEditingController();

  DetailsResult? locationPosition;

  late FocusNode locationFocusNode;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? debounce;

  String? selectedHotelType;
  var did = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    String apiKey = "AIzaSyDNzkszHrT2L0zwdhK0DzVK46aqO7n5lxk";
    googlePlace = GooglePlace(apiKey);
    locationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    locationFocusNode.dispose();
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
    final pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles;
      });
    }
  }

  Future<void> uploadImages(String hotelId) async {
    try {
      for (var imageFile in _selectedImages) {
        final Reference storageReference = _storage.ref().child(
            'hotel_images/$hotelId/${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask =
            storageReference.putFile(File(imageFile.path));

        final TaskSnapshot downloadUrl = await uploadTask;
        final String imageUrl = await downloadUrl.ref.getDownloadURL();
        _imageUrls.add(imageUrl);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error uploading images: $e');
    }
  }

  Future<void> addHotel() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        User? checkuser = user.currentUser;
        if (checkuser != null) {
          final hotelId = 'ho${user.currentUser!.uid}$did';
          await uploadImages(hotelId);

          await FirebaseFirestore.instance
              .collection('app')
              .doc('Services')
              .collection('Hotels')
              .doc(hotelId)
              .set({
            'name': hotelNameController.text,
            'single_room_price': int.parse(singleRoomPriceController.text),
            'connected_room_price':
                int.parse(connectedRoomPriceController.text),
            'hotel_location': hotelLocationController.text,
            'hotel_city': cityController.text,
            'active_rooms': '3',
            'stars': selectedHotelType,
            'room_capacity': personPerRoomController.text,
            'admin_id': checkuser.uid,
            'hotel_imageURLs': _imageUrls,
            'hotel_id': 'ho$did',
            'location': hotelLocationController.text,
            'hotel_lng': locationPosition!.geometry!.location!.lng!,
            'hotel_lat': locationPosition!.geometry!.location!.lat!,
            'description': descriptionController.text,
          });
          setState(() {
            selectedHotelType = null;
          });
          Fluttertoast.showToast(msg: 'Hotel added successfully');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding hotel: $e');
      }

      // Clear form fields and selected images after adding the hotel
      hotelNameController.clear();
      singleRoomPriceController.clear();
      connectedRoomPriceController.clear();
      hotelTypeController.clear();
      personPerRoomController.clear();
      cityController.clear();
      hotelLocationController.clear();
      setState(() {
        _selectedImages.clear();
        _imageUrls.clear();
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
        title: const Text('Add New Hotel',
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
                // Hotel Name Feild
                TextFormField(
                  controller: hotelNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Hotel Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hotel Name Required';
                    }
                    return null;
                  },
                ),
                //Hotel Type
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedHotelType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedHotelType = newValue;
                          hotelTypeController.text = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: '5 start',
                          child: Text('5 start'),
                        ),
                        DropdownMenuItem(
                          value: '3 start',
                          child: Text('3 start'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Hotel Type',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hotel Type Required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: hotelLocationController,
                  focusNode: locationFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    suffixIcon: hotelLocationController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                predictions = [];
                                hotelLocationController.clear();
                              });
                            },
                            icon: const Icon(Icons.clear_outlined))
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
                          locationPosition = null;
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
                        child: Icon(Icons.pin_drop),
                      ),
                      title: Text(predictions[index].description.toString()),
                      onTap: () async {
                        final placeId = predictions[index].placeId!;
                        final details = await googlePlace.details.get(placeId);
                        if (details != null &&
                            details.result != null &&
                            mounted) {
                          if (locationFocusNode.hasFocus) {
                            setState(() {
                              locationPosition = details.result;
                              hotelLocationController.text =
                                  details.result!.name!;
                              predictions = [];
                            });
                          }
                        }
                      },
                    );
                  },
                ),

                // Hotel City
                TextFormField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hotel City  Required';
                    }
                    return null;
                  },
                ),
                // Single Room Price Field
                TextFormField(
                  controller: singleRoomPriceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Single Room Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price Required';
                    }
                    return null;
                  },
                ),
                // Connected Room Price Field
                TextFormField(
                  controller: connectedRoomPriceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Connected Room Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price Required';
                    }
                    return null;
                  },
                ),
                // Person per room
                TextFormField(
                  controller: personPerRoomController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Persons per Room'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description Required';
                    }
                    return null;
                  },
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
                  children: _selectedImages.map((image) {
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
                      addHotel();
                    },
                    child: loading == true
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Add Hotel',
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
