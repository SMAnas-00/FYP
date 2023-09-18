// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class addFlightScreen extends StatefulWidget {
  const addFlightScreen({super.key});

  @override
  State<addFlightScreen> createState() => _addFlightScreenState();
}

class _addFlightScreenState extends State<addFlightScreen> {
  List<XFile> selectedImages = [];
  List<String> imageUrls = [];
  final ImagePicker imagePicker = ImagePicker();
  bool loading = false;

  FirebaseAuth user = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  final flightNameController = TextEditingController();
  final flightNumberController = TextEditingController();
  final flightTypeController = TextEditingController();
  final departureController = TextEditingController();
  final departureDateController = TextEditingController();
  final departureTimeController = TextEditingController();
  final midPointController = TextEditingController();
  final destinationController = TextEditingController();
  final destinationDateController = TextEditingController();
  final destinationTimeController = TextEditingController();
  final economySeatsController = TextEditingController();
  final businessSeatsController = TextEditingController();
  final economyPriceController = TextEditingController();
  final businessPriceController = TextEditingController();
  final departureCityController = TextEditingController();
  final destinationCityController = TextEditingController();
  final dayController = TextEditingController();

  DateTime selectedDateTime = DateTime.now();

  DetailsResult? departurePosition;
  DetailsResult? midPosition;
  DetailsResult? destinationPosition;

  late FocusNode departureFocusNode;
  late FocusNode midFocusNode;
  late FocusNode destinationFocusNode;

  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions = [];
  Timer? debounce;

  String? selectedFlightType;
  var did = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    String apiKey = "AIzaSyDNzkszHrT2L0zwdhK0DzVK46aqO7n5lxk";
    googlePlace = GooglePlace(apiKey);
    departureFocusNode = FocusNode();
    midFocusNode = FocusNode();
    destinationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    departureFocusNode.dispose();
    midFocusNode.dispose();
    destinationFocusNode.dispose();
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

  Future<void> uploadImages(String flightId) async {
    try {
      for (var imageFile in selectedImages) {
        final Reference storageReference = storage.ref().child(
            'flight_images/$flightId/${DateTime.now().millisecondsSinceEpoch}');
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

  Future<void> addFlight() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        User? checkuser = user.currentUser;

        if (checkuser != null) {
          final flightId = '${user.currentUser!.uid}$did';
          final userDOc = await firestore
              .collection('app')
              .doc('Users')
              .collection('Signup')
              .doc(checkuser.uid)
              .get();
          await uploadImages(flightId);

          await firestore
              .collection('app')
              .doc('Services')
              .collection('Flight')
              .doc('${user.currentUser!.uid}$did')
              .set({
            'airline_name': flightNameController.text,
            'airline_number': flightNumberController.text,
            'type': selectedFlightType,
            'departure': departureController.text,
            'departure_lng': departurePosition!.geometry!.location!.lng!,
            'departure_lat': departurePosition!.geometry!.location!.lat!,
            'destination_lng': destinationPosition!.geometry!.location!.lng!,
            'destination_lat': destinationPosition!.geometry!.location!.lat!,
            'departure_time': departureTimeController.text,
            'mid_point': midPointController.text,
            'destination': destinationController.text,
            'destination_date': destinationDateController.text,
            'destination_time': destinationTimeController.text,
            'economy_price': int.parse(economyPriceController.text),
            'economy_seats': int.parse(economySeatsController.text),
            'business_price': int.parse(businessPriceController.text),
            'business_seats': int.parse(businessSeatsController.text),
            'total_seats': int.parse(economySeatsController.text) +
                int.parse(businessSeatsController.text),
            'admin_id': user.currentUser!.uid,
            'flight_imageURL': imageUrls,
            'flight_id': 'fo$did',
            'departure_city': departureCityController.text,
            'destination_city': destinationCityController.text,
            'day': dayController.text,
            'manager_name': userDOc.data()?['First_name'],
            'manager_phone': userDOc.data()?['Contact'],
          });
          setState(() {
            selectedFlightType = null;
          });
          Fluttertoast.showToast(msg: 'Flight created successfully');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error adding flight: $e');
      }

      flightNameController.clear();
      flightNumberController.clear();
      flightTypeController.clear();
      departureController.clear();
      departureTimeController.clear();
      midPointController.clear();
      destinationController.clear();
      destinationTimeController.clear();
      economySeatsController.clear();
      economyPriceController.clear();
      businessSeatsController.clear();
      businessPriceController.clear();
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
        title: const Text('ADD FLIGHT',
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
                  controller: flightNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Arline Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: flightNumberController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Airline Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Flight number required';
                    }
                    return null;
                  },
                ),
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedFlightType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedFlightType = newValue;
                          flightTypeController.text = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'Connected',
                          child: Text('Connected'),
                        ),
                        DropdownMenuItem(
                          value: 'Direct',
                          child: Text('Direct'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Flight Type',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Flight Type Required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: departureController,
                  focusNode: departureFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Departure',
                    suffixIcon: departureController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                predictions = [];
                                departureController.clear();
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
                          departurePosition = null;
                        });
                      }
                    });
                  },
                ),
                if (departureFocusNode.hasFocus)
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
                          final details =
                              await googlePlace.details.get(placeId);
                          if (details != null &&
                              details.result != null &&
                              mounted) {
                            if (departureFocusNode.hasFocus) {
                              setState(() {
                                setState(() {
                                  departurePosition = details.result;
                                  departureController.text =
                                      details.result!.name!;
                                  predictions = [];
                                });
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                TextFormField(
                  controller: midPointController,
                  focusNode: midFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Connected Airport',
                    suffixIcon: midPointController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                predictions = [];
                                midPointController.clear();
                              });
                            },
                            icon: const Icon(Icons.clear_outlined,
                                color: Color.fromARGB(255, 29, 165, 153)))
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
                          midPosition = null;
                        });
                      }
                    });
                  },
                ),
                if (midFocusNode.hasFocus)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 29, 165, 153),
                          child: Icon(Icons.pin_drop, color: Colors.white),
                        ),
                        title: Text(predictions[index].description.toString()),
                        onTap: () async {
                          final placeId = predictions[index].placeId!;
                          final details =
                              await googlePlace.details.get(placeId);
                          if (details != null &&
                              details.result != null &&
                              mounted) {
                            if (midFocusNode.hasFocus) {
                              setState(() {
                                setState(() {
                                  midPosition = details.result;
                                  midPointController.text =
                                      details.result!.name!;
                                  predictions = [];
                                });
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                TextFormField(
                  controller: destinationController,
                  focusNode: destinationFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    suffixIcon: destinationController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                predictions = [];
                                destinationController.clear();
                              });
                            },
                            icon: const Icon(Icons.clear_outlined,
                                color: Color.fromARGB(255, 29, 165, 153)))
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
                          destinationPosition = null;
                        });
                      }
                    });
                  },
                ),
                if (destinationFocusNode.hasFocus)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 29, 165, 153),
                          child: Icon(Icons.pin_drop, color: Colors.white),
                        ),
                        title: Text(predictions[index].description.toString()),
                        onTap: () async {
                          final placeId = predictions[index].placeId!;
                          final details =
                              await googlePlace.details.get(placeId);
                          if (details != null &&
                              details.result != null &&
                              mounted) {
                            if (destinationFocusNode.hasFocus) {
                              setState(() {
                                setState(() {
                                  destinationPosition = details.result;
                                  destinationController.text =
                                      details.result!.name!;
                                  predictions = [];
                                });
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                TextFormField(
                  controller: departureCityController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Departure City',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Departure city required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: destinationCityController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Destination City',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Destination city required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dayController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Enter Day',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Day required';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2024));
                    if (datePicked != null) {
                      setState(() {
                        departureDateController.text =
                            '${datePicked.day}-${datePicked.month}-${datePicked.year}';
                      });
                    }
                  },
                  child: TextFormField(
                    controller: departureDateController,
                    enabled: false,
                    showCursor: false,
                    decoration: const InputDecoration(
                      labelText: 'Select Departure Date',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? timePicked = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (timePicked != null) {
                      String setTime =
                          "${timePicked.hour}:${timePicked.minute}:00";
                      setState(() {
                        departureTimeController.text = DateFormat.jm()
                            .format(DateFormat("hh:mm:ss").parse(setTime));
                      });
                    }
                  },
                  child: TextFormField(
                    controller: departureTimeController,
                    enabled: false,
                    showCursor: false,
                    decoration: const InputDecoration(
                      labelText: 'Select Departure Time',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? timePicked = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (timePicked != null) {
                      String setTime =
                          "${timePicked.hour}:${timePicked.minute}:00";
                      setState(() {
                        destinationTimeController.text = DateFormat.jm()
                            .format(DateFormat("hh:mm:ss").parse(setTime));
                      });
                    }
                  },
                  child: TextFormField(
                    controller: destinationTimeController,
                    enabled: false,
                    showCursor: false,
                    decoration: const InputDecoration(
                      labelText: 'Select Destination Time',
                    ),
                  ),
                ),
                TextFormField(
                  controller: economySeatsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Economy Seats'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seats Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: businessSeatsController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Business Class Seats'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seats Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: economyPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Economy Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: businessPriceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Business Class Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price Required';
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
                      addFlight();
                    },
                    child: loading == true
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Add Flight',
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
