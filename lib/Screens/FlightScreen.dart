// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FlightScreen extends StatefulWidget {
//   const FlightScreen({super.key});

//   @override
//   State<FlightScreen> createState() => _FlightScreenState();
// }

// class _FlightScreenState extends State<FlightScreen> {
//   late Stream<QuerySnapshot> _streamFlightlist;
//   CollectionReference Flightitems = FirebaseFirestore.instance
//       .collection('app')
//       .doc('Services')
//       .collection('Flight');
//   @override
//   void initState() {
//     super.initState();
//     _streamFlightlist = Flightitems.snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: _streamFlightlist,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text(snapshot.error.toString()));
//             }
//             if (snapshot.connectionState == ConnectionState.active) {
//               QuerySnapshot querySnapshot = snapshot.data;
//               List<QueryDocumentSnapshot> listqurey = querySnapshot.docs;
//               return ListView.builder(
//                 itemCount: listqurey.length,
//                 itemBuilder: (context, index) {
//                   QueryDocumentSnapshot document = listqurey[index];
//                   final img = document['flight_imageURL'];
//                   return Container(
//                     // height: MediaQuery.of(context).size.height,
//                     child: Card(
//                       margin: EdgeInsets.all(4),
//                       color: Color(0xffffffff),
//                       shadowColor: Color(0xff000000),
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(15),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                   child:

//                                       ///***If you have exported images you must have to copy those images in assets/images directory.
//                                       Image(
//                                     image: NetworkImage("$img"),
//                                     height: 140,
//                                     width: MediaQuery.of(context).size.width,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                                   child: Text(
//                                     document['airline_name'],
//                                     textAlign: TextAlign.start,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.clip,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 16,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 4, horizontal: 0),
//                                   child: Text(
//                                     '${document['Hotel_location']},${document['Hotel_city']}',
//                                     textAlign: TextAlign.start,
//                                     overflow: TextOverflow.clip,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 12,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                                   child: Text(
//                                     document['Hotel_description'],
//                                     textAlign: TextAlign.start,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 14,
//                                       color: Color(0xff817f7f),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           GestureDetector(
//                             child: Container(
//                               alignment: Alignment.center,
//                               margin: EdgeInsets.all(0),
//                               padding: EdgeInsets.all(0),
//                               width: MediaQuery.of(context).size.width,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Color(0xff3a57e8),
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(12.0),
//                                     bottomRight: Radius.circular(12.0)),
//                                 border: Border.all(
//                                     color: Color(0x4d9e9e9e), width: 1),
//                               ),
//                               child: Text(
//                                 "View More",
//                                 textAlign: TextAlign.start,
//                                 overflow: TextOverflow.clip,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontStyle: FontStyle.normal,
//                                   fontSize: 16,
//                                   color: Color(0xffffffff),
//                                 ),
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Hoteldetails(
//                                             hotelImageURL:
//                                                 document['hotel_imageURL'],
//                                             hotelLocation:
//                                                 document['Hotel_location'],
//                                             hotelName: document['name'],
//                                             hotelPrice: document['Hotel_price'],
//                                             hotelRating: document['Stars'],
//                                             hotelcapacity:
//                                                 document['Room_capacity'],
//                                             checkin: _checkInDate,
//                                             description:
//                                                 document['Hotel_description'],
//                                           )));
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//             return CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: file_names, non_constant_identifier_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
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
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> listqurey = querySnapshot.docs;
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
                        itemCount: listqurey.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot document = listqurey[index];
                          return GestureDetector(
                            child: FlightCard(
                              disc_price: document['discount_ticket_price'],
                              flight_day: document['flight_day'],
                              flight_name: document['airline_name'],
                              flight_time: document['flight_time'],
                              price: document['ticket_price'],
                              departure_city: document['departure_city'],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FlightDetails(
                                            flight_name:
                                                document['airline_name'],
                                            FlightImageURL:
                                                document['flight_imageURL'],
                                            FlightPrice: document[
                                                'discount_ticket_price'],
                                            departure: document['departure'],
                                            departure_city:
                                                document['departure_city'],
                                            destination:
                                                document['destination'],
                                            destination_city:
                                                document['destination_city'],
                                            flight_time:
                                                document['flight_time'],
                                            flight_id: document['flight_id'],
                                          )));
                            },
                          );
                        })
                  ],
                ),
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
