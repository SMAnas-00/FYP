import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'hoteldetailScreen.dart';

class HotelListScreen extends StatefulWidget {
  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
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
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamHotellist,
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
                  final img = document['hotel_imageURL'];
                  return Container(
                    // height: MediaQuery.of(context).size.height,
                    child: Card(
                      margin: EdgeInsets.all(4),
                      color: Color(0xffffffff),
                      shadowColor: Color(0xff000000),
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
                            padding: EdgeInsets.all(15),
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
                                    image: NetworkImage("$img"),
                                    height: 140,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Text(
                                    document['name'],
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: Text(
                                    '${document['Hotel_location']},${document['Hotel_city']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: RatingBarIndicator(
                                    rating: double.parse(document['Stars']),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Text(
                                    document['Hotel_description'],
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
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
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xff3a57e8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0)),
                                border: Border.all(
                                    color: Color(0x4d9e9e9e), width: 1),
                              ),
                              child: Text(
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
                                                document['hotel_imageURL'],
                                            hotelLocation:
                                                document['Hotel_location'],
                                            hotelName: document['name'],
                                            hotelPrice: document['Hotel_price'],
                                            hotelRating: document['Stars'],
                                            hotelcapacity:
                                                document['Room_capacity'],
                                            checkin: _checkInDate!,
                                            description:
                                                document['Hotel_description'],
                                            hotelid: document['hotel_id'],
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class HotelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3a57e8),
        title: Text('Hotels'),
      ),
      body: Column(
        children: [
          DateSelector(),
          Expanded(
            child: HotelListScreen(),
          ),
        ],
      ),
    );
  }
}

DateTime? _checkInDate;

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 80),
              primary: Color(0xFF3A57E8),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: Colors.black26),
          onPressed: () async {
            final DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (selectedDate != null)
              setState(() {
                _checkInDate = selectedDate;
              });
            ;
          },
          child: Text(
            _checkInDate != null
                ? 'Check-in: ${_checkInDate.toString().substring(0, 10)}'
                : 'Select Check-in',
          ),
        ),
      ],
    );
  }
}
