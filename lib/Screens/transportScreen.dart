import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newui/Screens/Transportdetails.dart';

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

  void initState() {
    super.initState();
    _streamTransport = Transportitems.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final String user = auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transport',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/searchtransport');
              },
              icon: const Icon(Icons.search))
        ],
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
              List<QueryDocumentSnapshot> listqurey = querySnapshot.docs;
              return ListView.builder(
                itemCount: listqurey.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document = listqurey[index];
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
                                child:

                                    ///***If you have exported images you must have to copy those images in assets/images directory.
                                    Image(
                                  image: NetworkImage("${img[0]}"),
                                  height: 140,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Text(
                                  document['vehicle_name'],
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
                                  '${document['pick_up']},${document['city']}',
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
                                child: Text(
                                  'Seating Capacity: ${document['total_seats']}',
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 0),
                                child: Text(
                                  'PKR: ' + '${document['price']}/-',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff3a57e8),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0)),
                              border: Border.all(
                                  color: const Color(0x4d9e9e9e), width: 1),
                            ),
                            child: const Text(
                              "View More",
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
                                    builder: (context) => TransportDetails(
                                          adminid: document['admin_id'],
                                          userid: user,
                                          transId: document['trans_id'],
                                          trans_imgURL: img,
                                          fareprice: document['price'],
                                          transtype: document['vehicle_name'],
                                          pickup: document['pick_up'],
                                          latitude: document['pickup_lat'],
                                          longitude: document['pickup_lng'],
                                          total_seats: document['total_seats'],
                                          number: document['driver_contact'],
                                          driver_name: document['driver_name'],
                                          docid: document.id,
                                        )));
                          },
                        ),
                      ],
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
