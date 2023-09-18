// ignore_for_file: file_names, non_constant_identifier_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newui/Screens/Flightdetails.dart';

Color flightBorderColor = const Color(0xFFE6E6E6);
Color chipBackgroundColor = const Color(0xFFF6F6F6);

final formatCurrency = NumberFormat.simpleCurrency();

class FlightList extends StatefulWidget {
  const FlightList({super.key});

  @override
  State<FlightList> createState() => _FlightListState();
}

class _FlightListState extends State<FlightList> {
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/flightkeyword');
                ;
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _streamflightlist,
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: Text(
                                    'Departure:  ${document['departure']},' +
                                        '${document['departure_city']}',
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
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: Text(
                                    'Destination:  ${document['destination']},' +
                                        '${document['destination_city']}',
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
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 0),
                                child: Text(
                                  'PKR: ' '${document['economy_price']}/-',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
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
                                          dep_time: document['departure_time'],
                                          adminid: document['admin_id'],
                                          manager_name:
                                              document['manager_name'],
                                          manager_phone:
                                              document['manager_phone'],
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
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}

class FlightCard extends StatefulWidget {
  int disc_price;
  int price;
  String flight_name;
  String flight_day;
  String flight_time;
  String departure_city;

  FlightCard({
    super.key,
    required this.disc_price,
    required this.price,
    required this.flight_day,
    required this.flight_time,
    required this.flight_name,
    required this.departure_city,
  });

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 214, 218, 240),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: flightBorderColor)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      formatCurrency.format(widget.disc_price),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    Text(
                      formatCurrency.format(widget.price),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey),
                    )
                  ],
                ),
                Wrap(
                  spacing: 12.0,
                  runSpacing: -8.0,
                  children: <Widget>[
                    FlightDetailChip(Icons.calendar_today, widget.flight_day),
                    FlightDetailChip(Icons.flight, widget.flight_name),
                    FlightDetailChip(
                        Icons.timelapse_outlined, widget.flight_time),
                    FlightDetailChip(
                        Icons.flight_takeoff, widget.departure_city),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class FlightDetailChip extends StatelessWidget {
  final IconData iconData;
  final String label;

  const FlightDetailChip(this.iconData, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
      backgroundColor: chipBackgroundColor,
      avatar: Icon(
        iconData,
        size: 14.0,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }
}
