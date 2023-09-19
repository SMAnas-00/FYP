import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newui/admin/admin_transport_booking.dart';

class MyTransport extends StatefulWidget {
  const MyTransport({super.key});

  @override
  State<MyTransport> createState() => _MyTransportState();
}

class _MyTransportState extends State<MyTransport> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final priceController = TextEditingController();

  CollectionReference transportitems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('Transport');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 218, 240),
      body: StreamBuilder(
          stream: transportitems.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(255, 29, 165, 153),
              ));
            }

            final sortedDocs = snapshot.data!.docs.where((doc) {
              final adminID = doc['admin_id'];
              final userID = auth.currentUser!.uid;
              return adminID == userID;
            }).toList();

            if (sortedDocs.isEmpty) {
              return const Center(child: Text("No Hotel Created Yet"));
            }
            return ListView.builder(
              itemCount: sortedDocs.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot document = sortedDocs[index];
                final img = document['transport_imageURL'];
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
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Text(
                                'Car: ${document['vehicle_name']} | ${document['vehicle_number']}',
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
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.pin_drop,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    document['pick_up'],
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 0),
                              child: Text(
                                'Fair: Rs ${document['price']} Per Kilometer',
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
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 29, 165, 153)),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        "Update Transport"),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              priceController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Transport Price'),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Price Required';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      29,
                                                                      165,
                                                                      153)),
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
                                                              if (priceController
                                                                  .text
                                                                  .isNotEmpty) {
                                                                await firestore
                                                                    .collection(
                                                                        'app')
                                                                    .doc(
                                                                        'Services')
                                                                    .collection(
                                                                        'Transport')
                                                                    .doc(sortedDocs[
                                                                            index]
                                                                        .id)
                                                                    .update({
                                                                  'price': int.parse(
                                                                      priceController
                                                                          .text),
                                                                }).then((value) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Price Updated Successfully');
                                                                  priceController
                                                                      .clear();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              }
                                                            } catch (e) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Something wrong");
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Save"))
                                                    ],
                                                  ));
                                        },
                                        child: const Text("Update",
                                            style: TextStyle(fontSize: 12))),
                                    IconButton(
                                        onPressed: () async {
                                          await firestore.runTransaction(
                                            (Transaction transaction) async {
                                              transaction.delete(
                                                  sortedDocs[index].reference);
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color:
                                              Color.fromARGB(255, 29, 165, 153),
                                        ))
                                  ],
                                ))
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminTransportBooking(
                                      docId: document.id)));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
