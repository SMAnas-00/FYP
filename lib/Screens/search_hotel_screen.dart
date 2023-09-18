import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'hoteldetailScreen.dart';

class SearchHotelScreen extends StatefulWidget {
  final String city;
  final String stars;
  const SearchHotelScreen({super.key, required this.city, required this.stars});

  @override
  State<SearchHotelScreen> createState() => _SearchHotelScreenState();
}

class _SearchHotelScreenState extends State<SearchHotelScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference Hotelitems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('Hotels');

  late Stream<QuerySnapshot> _streamHotellist;

  @override
  void initState() {
    super.initState();
    _streamHotellist = Hotelitems.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Hotels'),
        backgroundColor: const Color(0xff3a57e8),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamHotellist,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something Wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xff3a57e8),
            ));
          }

          final sortedDocs = snapshot.data!.docs.where((doc) {
            final stars = doc['stars'];
            final city = doc['hotel_city'];
            return widget.stars == stars ||
                (widget.city == city ||
                    widget.city.toLowerCase() == city.toString().toLowerCase());
          }).toList();

          if (sortedDocs.isEmpty) {
            return const Center(child: Text("Please select another filter"));
          }

          return ListView.builder(
            itemCount: sortedDocs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = sortedDocs[index];
              final img = document['hotel_imageURLs'];
              String input = document['stars'];
              String numpart = input.replaceAll(RegExp(r'[^0-9]'), '');
              // int star = int.tryParse(numpart) ?? 0;
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
                              document['name'],
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
                              '${document['hotel_location']},${document['hotel_city']}',
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
                            child: RatingBarIndicator(
                              rating: double.parse(numpart),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            child: Text(
                              'PKR: ' + '${document['single_room_price']}/-',
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              document['description'],
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff817f7f),
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
                                builder: (context) => Hoteldetails(
                                      hotelImageURL:
                                          document['hotel_imageURLs'],
                                      hotelLocation: document['hotel_location'],
                                      hotelName: document['name'],
                                      hotelPrice: document['single_room_price'],
                                      hotelRating: document['stars'],
                                      hotelcapacity: document['room_capacity'],
                                      description: document['description'],
                                      latitude: document['hotel_lat'],
                                      longitude: document['hotel_lng'],
                                      hotelid: document['hotel_id'],
                                      hotelpriceConn:
                                          document['connected_room_price'],
                                      adminid: document['admin_id'],
                                      docid: document.id,
                                      userid: auth.currentUser!.uid,
                                      hotel_phone: document['hotel_phone'],
                                      manager_name: document['manager_name'],
                                    )));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
