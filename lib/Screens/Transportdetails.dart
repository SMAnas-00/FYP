// ignore_for_file: file_names, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class TransportDetails extends StatefulWidget {
  String transtype;
  String pickup;
  List<dynamic> trans_imgURL;
  int fareprice;
  String number;
  String transId;
  String adminid;
  String userid;
  double latitude;
  double longitude;
  String docid;
  String total_seats;
  String driver_name;
  TransportDetails(
      {super.key,
      required this.driver_name,
      required this.number,
      required this.transtype,
      required this.pickup,
      required this.trans_imgURL,
      required this.fareprice,
      required this.latitude,
      required this.longitude,
      required this.adminid,
      required this.userid,
      required this.docid,
      required this.total_seats,
      required this.transId});

  @override
  State<TransportDetails> createState() => _TransportDetailsState();
}

class _TransportDetailsState extends State<TransportDetails> {
  final departureDateController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth user = FirebaseAuth.instance;
  int selcteddays = 1;
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 12.0,
    );
    Set<Marker> _markers = {
      Marker(
        markerId: const MarkerId('marker_1'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.transtype,
          snippet: widget.pickup,
        ),
      ),
    };
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.chat),
            onPressed: () {
              String num = widget.number;
              launch("https://wa.me/$num");
            },
          ),
        ],
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
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0, // Adjust the height as needed
                            enlargeCenterPage: true,
                            autoPlay: true,
                          ),
                          items: widget.trans_imgURL.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
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
                              widget.transtype.toUpperCase(),
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
                                "PKR ${widget.fareprice}",
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
                                "/day",
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
                        "Location:",
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
                              "Available on:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(widget.pickup),
                          ],
                        )
                      ],
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        width: 200,
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: _initialPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                          markers: _markers,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "Number of Days",
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
                          labelText: 'Select Booking Date',
                        ),
                      ),
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
                  onPressed: () async {
                    if (departureDateController.text == '') {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Please select booking date"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int totalprice = widget.fareprice * selcteddays;
                            return AlertDialog(
                              title: const Text('Confirmatrion'),
                              content: SizedBox(
                                height: 150,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'NAME: ${widget.transtype}',
                                        overflow: TextOverflow.clip,
                                      ),
                                      Text('ID: ${widget.transId}'),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Date: ${departureDateController.text}'),
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
                                      final userdata = await firestore
                                          .collection('app')
                                          .doc('Users')
                                          .collection('Signup')
                                          .doc(user.currentUser!.uid)
                                          .get();
                                      await firestore
                                          .collection('app')
                                          .doc('bookings')
                                          .collection('cart')
                                          .doc('request')
                                          .collection(user.currentUser!.uid)
                                          .doc('transport')
                                          .set({
                                        'name': widget.transtype,
                                        'price': totalprice,
                                        'image': widget.trans_imgURL[0],
                                        'id': widget.transId,
                                        'quantity': selcteddays,
                                        'docid': widget.docid
                                      }).then((value) =>
                                              Navigator.pop(context));
                                      await firestore
                                          .collection('app')
                                          .doc('bookings')
                                          .collection('transport')
                                          .doc('${user.currentUser!.uid}' +
                                              '${DateTime.now()}')
                                          .set({
                                        'adminid': widget.adminid,
                                        'userid': widget.userid,
                                        'docid': widget.docid,
                                        'name': widget.transtype,
                                        'id': widget.transId,
                                        'price': totalprice,
                                        'image': widget.trans_imgURL,
                                        'booking date':
                                            departureDateController.text,
                                        'seats': widget.total_seats,
                                        'status': 'pending',
                                        'latitude': widget.latitude,
                                        'longitude': widget.longitude,
                                        'driver_phone': widget.number,
                                        'driver_name': widget.driver_name,
                                        'user_name':
                                            userdata.data()?['First_name'],
                                        'user_phone':
                                            userdata.data()?['Contact'],
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
                    }
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
