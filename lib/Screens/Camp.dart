import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newui/Screens/Campdetails.dart';

import 'hoteldetailScreen.dart';

class MinaListScreen extends StatefulWidget {
  @override
  _MinaListScreenState createState() => _MinaListScreenState();
}

class _MinaListScreenState extends State<MinaListScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference Hotelitems = FirebaseFirestore.instance
      .collection('app')
      .doc('Services')
      .collection('minacamps');
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
          title: const Text("Book CAMP"),
        ),
        body: CampCategoriesPage()
        // GridView.count(
        //   crossAxisCount: 5,
        //   children: seats.map((seat) => _buildSeat(seat)).toList(),
        // ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     final message =
        //         "Selected Seats (${selectedSeats.length}/4): ${selectedSeats.join(", ")}";

        //     showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         title: const Text("Confirm Booking"),
        //         content: Text(message),
        //         actions: [
        //           TextButton(
        //             onPressed: () => Navigator.of(context).pop(),
        //             child: const Text("Cancel"),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               _sendseattoDB(selectedSeats);
        //               Navigator.of(context).pop();
        //             },
        //             child: const Text("Book"),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        //   label: Text("Book Seats (${selectedSeats.length}/4)"),
        //   icon: const Icon(Icons.check),
        // ),
        );
  }
}

class CampCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mina Camp Booking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to Category A
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage('A')),
                );
              },
              child: Text('Category A'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Category B
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage('B')),
                );
              },
              child: Text('Category B'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Category C
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage('C')),
                );
              },
              child: Text('Category C'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category $category'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Number of Camps: $numCamps'),
            Text('Number of Slots per Camp: $numSlots'),
            ElevatedButton(
              onPressed: () {
                // Implement slot booking logic here
              },
              child: Text('Book a Slot'),
            ),
          ],
        ),
      ),
    );
  }
}
