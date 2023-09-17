import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Flightdetails.dart';

class SearchFlight extends StatefulWidget {
  final String departureDat;
  final String departureCity;
  final String destinationCity;
  const SearchFlight(
      {super.key,
      required this.departureDat,
      required this.departureCity,
      required this.destinationCity});

  @override
  State<SearchFlight> createState() => _SearchFlightState();
}

class _SearchFlightState extends State<SearchFlight> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference flightitems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('Flight');
  late Stream<QuerySnapshot> _streamflightlist;

  @override
  void initState() {
    super.initState();
    _streamflightlist = flightitems.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights'),
        backgroundColor: const Color(0xff3a57e8),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _streamflightlist,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff3a57e8),
              ));
            }
            final sortedDocs = snapshot.data!.docs.where((doc) {
              final departureDate = doc['departure_date'];
              final departureCity = doc['departure_city'];
              final destinationCity = doc['destination_city'];
              return widget.departureDat == departureDate ||
                  (widget.departureCity == departureCity &&
                      widget.destinationCity == destinationCity);
            }).toList();

            if (sortedDocs.isEmpty) {
              return const Center(child: Text("Please select another filter"));
            }
            return ListView.builder(
              itemCount: sortedDocs.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot document = sortedDocs[index];
                final img = document['flight_imageURL'];
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
                                document['airline_name'],
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
                                '${document['departure']}',
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
                                '${document['destination']}',
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
                                  builder: (context) => FlightDetails(
                                        FlightImageURL:
                                            document['flight_imageURL'],
                                        FlightPriceEco:
                                            document['economy_price'],
                                        FlightPriceBus:
                                            document['business_price'],
                                        departure: document['departure'],
                                        destination: document['destination'],
                                        departure_time:
                                            document['departure_time'],
                                        destination_time:
                                            document['destination_time'],
                                        flight_id: document['flight_id'],
                                        flight_name: document['airline_name'],
                                        latitude: document['departure_lat'],
                                        longitude: document['departure_lng'],
                                        adminid: document['admin_id'],
                                        docid: document.id,
                                        userid: auth.currentUser!.uid,
                                      )));
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
