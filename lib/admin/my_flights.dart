// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color flightBorderColor = const Color(0xFFE6E6E6);
Color chipBackgroundColor = const Color(0xFFF6F6F6);

final formatCurrency = NumberFormat.simpleCurrency();

class MyFlights extends StatefulWidget {
  const MyFlights({super.key});

  @override
  State<MyFlights> createState() => _MyFlightsState();
}

class _MyFlightsState extends State<MyFlights> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference flightitems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('Flight');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return SingleChildScrollView(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: flightitems.snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something wrong"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 29, 165, 153),
                ));
              }
              final now = DateTime.now();
              final sortedDocs = snapshot.data!.docs.where((doc) {
                final airlineDate =
                    DateFormat('dd-MM-yyyy').parse(doc['departure_date']);
                final airlineDateTime = DateTime(
                    airlineDate.year, airlineDate.month, airlineDate.day);
                final adminID = doc['admin_id'];
                final userID = user!.uid;
                return userID == adminID &&
                    airlineDateTime
                        .isAfter(now.subtract(const Duration(days: 1)));
              }).toList();

              if (sortedDocs.isEmpty) {
                return const Center(child: Text("No Airline Created Yet"));
              }

              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: sortedDocs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot document = sortedDocs[index];
                          return GestureDetector(
                            child: FlightCard(
                              economy_seats: document['economy_seats'],
                              business_Seats: document['business_seats'],
                              economy_price: document['economy_price'],
                              business_price: document['business_price'],
                              departure: document['departure'],
                              destination: document['destination'],
                              departure_date: document['departure_date'],
                              departure_time: document['departure_time'],
                              destination_date: document['destination_date'],
                              destination_time: document['destination_time'],
                              flight_name: document['airline_name'],
                              flight_type: document['type'],
                              flight_number: document['airline_number'],
                              mid_point: document['mid_point'],
                            ),
                            onTap: () {},
                          );
                        })
                  ],
                ),
              );
            }),
      ),
    );
  }
}

// ignore: must_be_immutable
class FlightCard extends StatefulWidget {
  int economy_seats;
  int business_Seats;
  int economy_price;
  int business_price;
  String departure;
  String destination;
  String departure_date;
  String departure_time;
  String destination_date;
  String destination_time;
  String flight_name;
  String flight_type;
  String flight_number;
  String mid_point;

  FlightCard({
    super.key,
    required this.economy_seats,
    required this.business_Seats,
    required this.economy_price,
    required this.business_price,
    required this.flight_name,
    required this.departure,
    required this.destination,
    required this.departure_date,
    required this.departure_time,
    required this.destination_date,
    required this.destination_time,
    required this.flight_type,
    required this.flight_number,
    required this.mid_point,
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
                  children: [
                    Text(
                      'Economy Price : ${formatCurrency.format(widget.economy_price)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'Business Price : ${formatCurrency.format(widget.business_price)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Wrap(
                  spacing: 12.0,
                  runSpacing: -8.0,
                  children: <Widget>[
                    FlightDetailChip(
                        Icons.calendar_today, widget.departure_date),
                    FlightDetailChip(Icons.flight, widget.flight_name),
                    FlightDetailChip(
                        Icons.timelapse_outlined, widget.departure_time),
                    FlightDetailChip(Icons.flight_takeoff, widget.departure),
                    if (widget.mid_point != "")
                      FlightDetailChip(
                          Icons.connecting_airports_sharp, widget.mid_point),
                    FlightDetailChip(Icons.flight_land, widget.destination)
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor:
                //             const Color.fromARGB(255, 29, 165, 153)),
                //     onPressed: () async {},
                //     child:
                //         const Text("Bookings", style: TextStyle(fontSize: 12)))

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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
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
