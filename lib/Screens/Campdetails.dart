import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:carousel_slider/carousel_slider.dart';

class Minadetails extends StatefulWidget {
  final String campName;
  final String campLocation;
  final String campRating;
  final List<dynamic> campImageURL;
  final int campPrice;
  final String campcapacity;
  String manager_name;
  String manager_phone;
  final String description;
  final String campid;
  final double latitude;
  final double longitude;
  final String adminid;
  final String userid;
  final String docid;

  Minadetails(
      {super.key,
      required this.campImageURL,
      required this.campName,
      required this.campPrice,
      required this.campLocation,
      required this.campcapacity,
      required this.campRating,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.adminid,
      required this.userid,
      required this.docid,
      required this.manager_name,
      required this.manager_phone,
      required this.campid});

  @override
  State<Minadetails> createState() => _MinadetailsState();
}

class _MinadetailsState extends State<Minadetails> {
  GoogleMapController? _controller;
  final BookingDateController = TextEditingController();
  int selctedrooms = 1;
  int selcteddays = 1;
  int updatedprice = 0;
  @override
  void initState() {
    super.initState();
    updatedprice = widget.campPrice;
  }

  late DateTime selecteddate;

  @override
  Widget build(BuildContext context) {
    String input = widget.campRating;
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
          title: widget.campName,
          snippet: widget.campLocation,
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
          "Camp details",
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
                          items: widget.campImageURL.map((imageUrl) {
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
                              widget.campName,
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
                                "/slot",
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
                    // Row(
                    //   children: [
                    //     const Text("Room Type:"),
                    //     DropdownButton(
                    //       value: _RoomType,
                    //       items: _RoomTypes.map((RoomType) {
                    //         return DropdownMenuItem(
                    //           value: RoomType,
                    //           child: Text(RoomType),
                    //         );
                    //       }).toList(),
                    //       onChanged: (value) {
                    //         setState(() {
                    //           _RoomType = value!;
                    //           print(value);
                    //           if (value == 'Connected') {
                    //             updatedprice = widget.hotelpriceConn;
                    //           } else {
                    //             updatedprice = widget.hotelPrice;
                    //           }
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),
                    // const Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    //   child: Text(
                    //     "Number of days",
                    //     textAlign: TextAlign.start,
                    //     overflow: TextOverflow.clip,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       fontStyle: FontStyle.normal,
                    //       fontSize: 15,
                    //       color: Color(0xff000000),
                    //     ),
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Container(
                    //       alignment: Alignment.center,
                    //       margin: const EdgeInsets.all(0),
                    //       padding: const EdgeInsets.all(4),
                    //       decoration: BoxDecoration(
                    //         color: const Color(0xfff0efef),
                    //         shape: BoxShape.rectangle,
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //       child: IconButton(
                    //         icon: const Icon(
                    //           Icons.remove,
                    //           color: Color(0xff000000),
                    //           size: 20,
                    //         ),
                    //         onPressed: () {
                    //           setState(() {
                    //             if (selcteddays > 1) {
                    //               selcteddays--;
                    //             }
                    //             if (selcteddays <= 0) {
                    //               selcteddays = 0;
                    //             }
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 0, horizontal: 8),
                    //       child: Text(
                    //         selcteddays.toString(),
                    //         textAlign: TextAlign.start,
                    //         overflow: TextOverflow.clip,
                    //         style: const TextStyle(
                    //           fontWeight: FontWeight.w400,
                    //           fontStyle: FontStyle.normal,
                    //           fontSize: 16,
                    //           color: Color(0xff000000),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       alignment: Alignment.center,
                    //       margin: const EdgeInsets.all(0),
                    //       padding: const EdgeInsets.all(4),
                    //       decoration: BoxDecoration(
                    //         color: const Color(0xfff0efef),
                    //         shape: BoxShape.rectangle,
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //       child: IconButton(
                    //         iconSize: 20,
                    //         icon: const Icon(
                    //           Icons.add,
                    //           color: Color(0xff000000),
                    //           size: 20,
                    //         ),
                    //         onPressed: () {
                    //           setState(() {
                    //             if (selcteddays >= 10) {
                    //               selcteddays = 10;
                    //             } else {
                    //               selcteddays++;
                    //             }
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Text(
                        "Number of Slots",
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
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          int totalprice;
                          if (updatedprice == 0) {
                            totalprice = widget.campPrice * selctedrooms;
                          } else {
                            totalprice = updatedprice * selctedrooms;
                          }
                          return AlertDialog(
                            title: const Text('Confirmatrion'),
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text('NAME: ${widget.campName}')),
                                  Expanded(
                                      child: Text('Hotel Id:${widget.campid}')),
                                  const SizedBox(height: 5),
                                  Expanded(child: Text('Slots: $selctedrooms')),
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
                                        .doc('minacamp')
                                        .set({
                                      'name': widget.campName,
                                      'price': totalprice,
                                      'image': widget.campImageURL[0],
                                      'id': widget.campid,
                                      'quantity': selctedrooms,
                                      'docid': widget.docid,
                                    }).then((value) => Navigator.pop(context));
                                    await firestore
                                        .collection('app')
                                        .doc('bookings')
                                        .collection('minacamp')
                                        .doc('${user.currentUser!.uid}' +
                                            '${DateTime.now()}')
                                        .set({
                                      'adminid': widget.adminid,
                                      'userid': widget.userid,
                                      'camp_docid': widget.docid,
                                      'name': widget.campName,
                                      'id': widget.campid,
                                      'price': totalprice,
                                      'image': widget.campImageURL,
                                      'campslot': selctedrooms,
                                      'status': 'pending',
                                      'latitude': widget.latitude,
                                      'longitude': widget.longitude,
                                      'user_name':
                                          userdata.data()?['First_name'],
                                      'user_phone': userdata.data()?['Contact'],
                                      'manager_name': widget.manager_name,
                                      'manager_phone': widget.manager_phone,
                                      'date': '${DateTime.now()}',
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
