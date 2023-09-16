import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:carousel_slider/carousel_slider.dart';

class Hoteldetails extends StatefulWidget {
  String hotelName;
  String hotelLocation;
  String hotelRating;
  List<dynamic> hotelImageURL;
  int hotelPrice;
  String hotelcapacity;
  DateTime checkin;
  String description;
  String hotelid;
  double latitude;
  double longitude;
  int hotelpriceConn;
  String adminid;
  String userid;
  String docid;

  Hoteldetails(
      {super.key,
      required this.hotelName,
      required this.hotelLocation,
      required this.hotelRating,
      required this.hotelImageURL,
      required this.hotelcapacity,
      required this.hotelPrice,
      required this.checkin,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.hotelpriceConn,
      required this.adminid,
      required this.userid,
      required this.docid,
      required this.hotelid});

  @override
  State<Hoteldetails> createState() => _HoteldetailsState();
}

class _HoteldetailsState extends State<Hoteldetails> {
  GoogleMapController? _controller;

  int selctedrooms = 1;
  int selcteddays = 1;
  String _RoomType = 'Single';
  final List<String> _RoomTypes = ['Single', 'Connected'];
  int updatedprice = 0;
  @override
  void initState() {
    super.initState();
    updatedprice = widget.hotelPrice;
  }

  @override
  Widget build(BuildContext context) {
    String input = widget.hotelRating;
    String numpart = input.replaceAll(RegExp(r'[^0-9]'), '');
    CameraPosition _initialPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 12.0,
    );
    Set<Marker> _markers = {
      Marker(
        markerId: const MarkerId('marker_1'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.hotelName,
          snippet: widget.hotelLocation,
        ),
      ),
    };
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
          "Hotel details",
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
                          items: widget.hotelImageURL.map((imageUrl) {
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
                              widget.hotelName,
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
                                "PKR ${updatedprice}",
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
                                "/night",
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
                    Text(
                      widget.description,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "Ratings",
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
                    RatingBarIndicator(
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      rating: double.parse(numpart),
                      itemSize: 20,
                    ),
                    const SizedBox(height: 30),
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
                    Row(
                      children: [
                        const Text("Room Type:"),
                        DropdownButton(
                          value: _RoomType,
                          items: _RoomTypes.map((RoomType) {
                            return DropdownMenuItem(
                              value: RoomType,
                              child: Text(RoomType),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _RoomType = value!;
                              print(value);
                              if (value == 'Connected') {
                                updatedprice = widget.hotelpriceConn;
                              } else {
                                updatedprice = widget.hotelPrice;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "Number of days",
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
                                if (selcteddays >= 10) {
                                  selcteddays = 10;
                                } else {
                                  selcteddays++;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "Number of Rooms",
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
                                if (selctedrooms > 1) {
                                  selctedrooms--;
                                }
                                if (selctedrooms <= 0) {
                                  selctedrooms = 0;
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          child: Text(
                            selctedrooms.toString(),
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
                                if (selctedrooms >= 3) {
                                  selctedrooms = 3;
                                } else {
                                  selctedrooms++;
                                }
                              });
                            },
                          ),
                        ),
                      ],
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
                        DateFormat('EEEE, MMM dd, yyyy').format(widget.checkin);
                    String datecheckout = DateFormat('EEEE, MMM dd, yyyy')
                        .format(
                            widget.checkin.add(Duration(days: selcteddays)));
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          int totalprice;
                          if (updatedprice == 0) {
                            totalprice =
                                widget.hotelPrice * selctedrooms * selcteddays;
                          } else {
                            totalprice =
                                updatedprice * selctedrooms * selcteddays;
                          }
                          return AlertDialog(
                            title: const Text('Confirmatrion'),
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text('NAME: ${widget.hotelName}')),
                                  Expanded(
                                      child:
                                          Text('Hotel Id:${widget.hotelid}')),
                                  const SizedBox(height: 5),
                                  Expanded(child: Text('Rooms: $selctedrooms')),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      child: Text('Check In: $datecheckin')),
                                  Expanded(
                                      child: Text('Check OUT: $datecheckout')),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      child: Text('Total Price: $totalprice')),
                                ],
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
                                        .doc('hotel')
                                        .set({
                                      'name': widget.hotelName,
                                      'price': totalprice,
                                      'image': widget.hotelImageURL[0],
                                      'id': widget.hotelid
                                    }).then((value) => Navigator.pop(context));
                                    await firestore
                                        .collection('app')
                                        .doc('bookings')
                                        .collection('admin')
                                        .doc('request')
                                        .collection(user.currentUser!.uid)
                                        .doc('request')
                                        .set({
                                      'adminid': widget.adminid,
                                      'userid': widget.userid,
                                      'hotel_docid': widget.docid,
                                      'hname': widget.hotelName,
                                      'hid': widget.hotelid,
                                      'hprice': totalprice,
                                      'himage': widget.hotelImageURL,
                                      'hcheckin': datecheckin,
                                      'hcheckout': datecheckout,
                                      'hrooms': selctedrooms,
                                      'hdays': selcteddays,
                                      'status': 'pending',
                                      'hlatitude': widget.latitude,
                                      'hlongitude': widget.longitude,
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
