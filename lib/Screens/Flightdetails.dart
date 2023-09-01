// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightDetails extends StatefulWidget {
  String flight_name;
  String departure;
  String destination;
  String departure_city;
  String destination_city;
  String flight_time;
  String FlightImageURL;
  int FlightPrice;
  String flight_id;
  FlightDetails(
      {super.key,
      required this.flight_name,
      required this.FlightImageURL,
      required this.FlightPrice,
      required this.flight_time,
      required this.departure,
      required this.departure_city,
      required this.destination,
      required this.destination_city,
      required this.flight_id});

  @override
  State<FlightDetails> createState() => _FlightDetailsState();
}

class _FlightDetailsState extends State<FlightDetails> {
  int selcteddays = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xffffffff),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Flight details",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            color: Color(0xff000000),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff212435),
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 0),
                      child: Align(
                        alignment: Alignment.center,
                        child:

                            ///***If you have exported images you must have to copy those images in assets/images directory.
                            Image(
                          image: NetworkImage(widget.FlightImageURL),
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.flight_name,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "PKR ${widget.FlightPrice}",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                  color: Color(0xff000000),
                                ),
                              ),
                              const Text(
                                "/Person",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "AIRPORT",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "From",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                                '${widget.departure},${widget.departure_city}'),
                            const SizedBox(height: 10),
                            const Divider(),
                            const Text(
                              "To",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                                '${widget.destination},${widget.destination_city}')
                          ],
                        )
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "Number of Passangers",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xfff0efef),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xff000000),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selcteddays > 1) {
                                  selcteddays--;
                                }
                                if (selcteddays <= 0) {
                                  selcteddays = 0;
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          child: Text(
                            selcteddays.toString(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xfff0efef),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xff000000),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selcteddays >= 6) {
                                  selcteddays = 6;
                                } else {
                                  selcteddays++;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [DateTimePick()],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  onPressed: () {
                    String datecheckin =
                        DateFormat('EEEE, MMM dd, yyyy').format(_checkInDate!);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          int totalprice = widget.FlightPrice * selcteddays;
                          return AlertDialog(
                            title: const Text('Confirmatrion'),
                            content: SizedBox(
                              height: 150,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('NAME: ${widget.flight_name}'),
                                    Text('ID: ${widget.flight_id}'),
                                    const SizedBox(height: 10),
                                    Text('DEPART: ${widget.departure}'),
                                    Text('DES: ${widget.destination}'),
                                    const SizedBox(height: 10),
                                    Text('NAME: $datecheckin'),
                                    const SizedBox(height: 5),
                                    Text('Total Price: $totalprice'),
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () async {
                                    FirebaseAuth user = FirebaseAuth.instance;
                                    FirebaseFirestore firestore =
                                        FirebaseFirestore.instance;
                                    await firestore
                                        .collection('app')
                                        .doc('bookings')
                                        .collection('cart')
                                        .doc('request')
                                        .collection(user.currentUser!.uid)
                                        .doc('flight')
                                        .set({
                                      'name': widget.flight_name,
                                      'price': totalprice,
                                      'image': widget.FlightImageURL,
                                      'id': widget.flight_id
                                    }).then((value) => Navigator.pop(context));
                                    await firestore
                                        .collection('app')
                                        .doc('bookings')
                                        .collection('admin')
                                        .doc('request')
                                        .collection(user.currentUser!.uid)
                                        .doc('request')
                                        .set({
                                      'fname': widget.flight_name,
                                      'fid': widget.flight_id,
                                      'fprice': totalprice,
                                      'fimage': widget.FlightImageURL,
                                      'fdeparture': datecheckin,
                                      'fPessangers': selcteddays,
                                      'fdays': selcteddays,
                                      'status': 'pending',
                                      'date': DateTime.now(),
                                    }, SetOptions(merge: true));
                                  },
                                  child: const Text('OK')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('CLOSE')),
                            ],
                          );
                        });
                  },
                  color: const Color(0xff3a57e8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Color(0xffffffff), width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xffffffff),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime? _checkInDate;

class DateTimePick extends StatefulWidget {
  const DateTimePick({super.key});

  @override
  State<DateTimePick> createState() => _DateTimePickState();
}

class _DateTimePickState extends State<DateTimePick> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF3A57E8),
          padding: const EdgeInsets.symmetric(horizontal: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.black26),
      onPressed: () async {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          setState(() {
            _checkInDate = selectedDate;
          });
        }
      },
      child: Text(
        _checkInDate != null
            ? 'Departure: ${_checkInDate.toString().substring(0, 10)}'
            : 'Select Departure',
      ),
    );
  }
}
