import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHotels extends StatefulWidget {
  const MyHotels({super.key});

  @override
  State<MyHotels> createState() => _MyHotelsState();
}

class _MyHotelsState extends State<MyHotels> {
  final noOfRoomsController = TextEditingController();
  final singleRoomPriceController = TextEditingController();
  final doubleRoomPriceController = TextEditingController();
  final hotelTypeController = TextEditingController();
  String? selectedHotelType;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference hotelItems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('Hotels');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 218, 240),
      body: StreamBuilder<QuerySnapshot>(
        stream: hotelItems.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something Wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 29, 165, 153),
            ));
          }

          final sortedDocs = snapshot.data!.docs.where((doc) {
            final adminID = doc['admin_id'];
            final userID = user!.uid;
            return adminID == userID;
          }).toList();

          if (sortedDocs.isEmpty) {
            return const Center(child: Text("No Hotel Created Yet"));
          }

          return ListView.builder(
            itemCount: sortedDocs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = sortedDocs[index];
              final img = document['hotel_imageURLs'];
              String input = document['stars'];
              String numpart = input.replaceAll(RegExp(r'[^0-9]'), '');
              return Card(
                margin: const EdgeInsets.all(4),
                color: const Color(0xffffffff),
                shadowColor: const Color(0xff000000),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image(
                              image: NetworkImage("${img[0]}"),
                              height: 140,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              document['name'],
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: Text(
                              '${document['hotel_location']},${document['hotel_city']}',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: RatingBarIndicator(
                              rating: double.parse(numpart),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              'Active Rooms: ${document['active_rooms']}',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff817f7f),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              document['description'],
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff817f7f),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 29, 165, 153)),
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text("Update Hotel"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    children: [
                                                      DropdownButtonFormField<
                                                          String>(
                                                        value:
                                                            selectedHotelType,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selectedHotelType =
                                                                newValue;
                                                            hotelTypeController
                                                                    .text =
                                                                newValue!;
                                                          });
                                                        },
                                                        items: const [
                                                          DropdownMenuItem(
                                                            value: '1 start',
                                                            child:
                                                                Text('1 start'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: '2 start',
                                                            child:
                                                                Text('2 start'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: '3 start',
                                                            child:
                                                                Text('3 start'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: '4 start',
                                                            child:
                                                                Text('4 start'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: '5 start',
                                                            child:
                                                                Text('5 start'),
                                                          ),
                                                        ],
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Hotel Type',
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Hotel Type Required';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        singleRoomPriceController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Single Room Price'),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Price Required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        doubleRoomPriceController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Connected Room Price'),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Price Required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        noOfRoomsController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Active Rooms'),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Rooms Required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 29, 165, 153)),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    29,
                                                                    165,
                                                                    153)),
                                                    onPressed: () async {
                                                      try {
                                                        if (singleRoomPriceController.text.isNotEmpty &&
                                                            doubleRoomPriceController
                                                                .text
                                                                .isNotEmpty &&
                                                            noOfRoomsController
                                                                .text
                                                                .isNotEmpty &&
                                                            hotelTypeController
                                                                .text
                                                                .isNotEmpty) {
                                                          await firestore
                                                              .collection('app')
                                                              .doc('Services')
                                                              .collection(
                                                                  'Hotels')
                                                              .doc(sortedDocs[
                                                                      index]
                                                                  .id)
                                                              .update({
                                                            'stars':
                                                                selectedHotelType,
                                                            'active_rooms':
                                                                int.parse(
                                                                    noOfRoomsController
                                                                        .text),
                                                            'single_room_price':
                                                                int.parse(
                                                                    singleRoomPriceController
                                                                        .text),
                                                            'connected_room_price':
                                                                int.parse(
                                                                    doubleRoomPriceController
                                                                        .text)
                                                          }).then((value) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Hotel Updated Successfully');
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            noOfRoomsController
                                                                .clear();
                                                            singleRoomPriceController
                                                                .clear();
                                                            doubleRoomPriceController
                                                                .clear();
                                                            setState(() {
                                                              selectedHotelType =
                                                                  null;
                                                            });
                                                          });
                                                        }
                                                      } catch (e) {
                                                        Fluttertoast.showToast(
                                                            msg: e.toString());
                                                      }
                                                    },
                                                    child: const Text("Save"))
                                              ],
                                            ));
                                  },
                                  child: const Text("Update",
                                      style: TextStyle(fontSize: 12)))),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 29, 165, 153),
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0)),
                          border: Border.all(
                              color: const Color(0x4d9e9e9e), width: 1),
                        ),
                        child: const Text(
                          "Bookings",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
