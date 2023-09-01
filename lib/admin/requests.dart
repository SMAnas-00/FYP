// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newui/Screens/Transportdetails.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference Transportitems = FirebaseFirestore.instance
      .collection('app')
      .doc('bookings')
      .collection('admin');

  late Stream<QuerySnapshot> _streamTransport;

  @override
  void initState() {
    super.initState();
    _streamTransport = Transportitems.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transport',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff3a57e8),
      ),
      body: StreamBuilder(
          stream: _streamTransport,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> listqureysnap = querySnapshot.docs;
              return ListView.builder(
                itemCount: listqureysnap.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document = listqureysnap[index];
                  //final img = document['Hotel_image'].toString();
                  return SingleChildScrollView(
                    child: GestureDetector(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                document['Transport_type'],
                              ),
                              Text(document['Pick_up'] +
                                  '-' +
                                  document['Destination']),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      document['Fair'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        String type =
                            snapshot.data!.docs[index]['Transport_type'];
                        String destination =
                            snapshot.data!.docs[index]['Destination'];
                        String pickup = snapshot.data!.docs[index]['Pick_up'];
                        int fareprice = snapshot.data!.docs[index]['Fair'];
                        String trans_imgURL =
                            snapshot.data!.docs[index]['transport_imageURL'];
                        String transId = snapshot.data!.docs[index]['Trans_id'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransportDetails(
                                      transtype: type,
                                      destination: destination,
                                      pickup: pickup,
                                      trans_imgURL: trans_imgURL,
                                      fareprice: fareprice,
                                      transId: transId,
                                    )));
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class TransportService extends StatefulWidget {
  const TransportService({super.key});

  @override
  State<TransportService> createState() => _TransportServiceState();
}

class _TransportServiceState extends State<TransportService> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference Transportitems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('Transport');
  late Stream<QuerySnapshot> _streamTransport;

  @override
  void initState() {
    super.initState();
    _streamTransport = Transportitems.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transport',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff3a57e8),
      ),
      body: StreamBuilder(
          stream: _streamTransport,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> listqureysnap = querySnapshot.docs;
              return ListView.builder(
                itemCount: listqureysnap.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document = listqureysnap[index];
                  //final img = document['Hotel_image'].toString();
                  return SingleChildScrollView(
                    child: GestureDetector(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                document['Transport_type'],
                              ),
                              Text(document['Pick_up'] +
                                  '-' +
                                  document['Destination']),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      document['Fair'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        String type =
                            snapshot.data!.docs[index]['Transport_type'];
                        String destination =
                            snapshot.data!.docs[index]['Destination'];
                        String pickup = snapshot.data!.docs[index]['Pick_up'];
                        int fareprice = snapshot.data!.docs[index]['Fair'];
                        String trans_imgURL =
                            snapshot.data!.docs[index]['transport_imageURL'];
                        String transId = snapshot.data!.docs[index]['Trans_id'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransportDetails(
                                      transtype: type,
                                      destination: destination,
                                      pickup: pickup,
                                      trans_imgURL: trans_imgURL,
                                      fareprice: fareprice,
                                      transId: transId,
                                    )));
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
