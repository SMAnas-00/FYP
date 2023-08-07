// import 'package:flutter/material.dart';

// class CampsPage extends StatefulWidget {
//   @override
//   _CampsPageState createState() => _CampsPageState();
// }

// class _CampsPageState extends State<CampsPage> {
//   List<Camp> camps = [
//     Camp("Camp 1", 4, false),
//     Camp("Camp 2", 4, false),
//     Camp("Camp 3", 4, false),
//     Camp("Camp 4", 4, false),
//     Camp("Camp 5", 4, false),
//     Camp("Camp 6", 4, false),
//     Camp("Camp 7", 4, false),
//     Camp("Camp 8", 4, false),
//     Camp("Camp 9", 4, false),
//     Camp("Camp 10", 4, false),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Camps"),
//       ),
//       body: GridView.builder(
//         itemCount: camps.length,
//         itemBuilder: (context, index) {
//           return CampCard(camps[index]);
//         },
//         gridDelegate:
//             SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//       ),
//     );
//   }
// }

// class CampCard extends StatefulWidget {
//   final Camp camp;

//   CampCard(this.camp);

//   @override
//   State<CampCard> createState() => _CampCardState();
// }

// class _CampCardState extends State<CampCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.camp.name,
//               style: TextStyle(fontSize: 16.0),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               "Available beds: ${widget.camp.availableBeds}",
//               style: TextStyle(fontSize: 14.0),
//             ),
//             SizedBox(height: 8.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (widget.camp.availableBeds > 0) {
//                           widget.camp.availableBeds--;
//                         }
//                       });
//                     },
//                     child: Text("Book"),
//                   ),
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (widget.camp.availableBeds > 0) {
//                           widget.camp.availableBeds;
//                         }
//                       });
//                     },
//                     child: Text("Cancel"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Camp {
//   final String name;
//   int availableBeds;
//   final bool isBooked;

//   Camp(this.name, this.availableBeds, this.isBooked);
// }

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'dart:collection';

class CricketStadium extends StatefulWidget {
  @override
  _CricketStadiumState createState() => _CricketStadiumState();
}

class _CricketStadiumState extends State<CricketStadium> {
  List<String> seats = [
    "A1",
    "A2",
    "A3",
    "A4",
    "A5",
    "B1",
    "B2",
    "B3",
    "B4",
    "B5",
    "C1",
    "C2",
    "C3",
    "C4",
    "C5",
    "D1",
    "D2",
    "D3",
    "D4",
    "D5",
  ];

  List<String> selectedSeats = [];
  List<String> occupiedSeats = [];
  List<String> occupieddb = [];

  void _toggleSeat(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else if (selectedSeats.length < 4) {
        selectedSeats.add(seat);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
    print(seats);
  }

  Future<List<String>> getList() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // FirebaseAuth user = FirebaseAuth.instance;

    await firestore
        .collection('app')
        .doc('requests')
        .collection('minacamp')
        .doc('camp')
        .get()
        .then((document) async {
      occupiedSeats =
          await List<String>.from(document.data()!['BookedSeats']).toList();
      occupieddb = occupiedSeats;
    });
    // print(occupiedSeats);
    // print(occupiedSeats.length);
    for (var i = 0; i < occupiedSeats.length; i++) {
      // bool subset = seats.contains(occupiedSeats[i]);
      // print(subset);
    }
    // bool isSubset = Set.from(occupiedSeats).isSubsetOf(Set.from(seats));

    return occupiedSeats;
  }

  void _sendseattoDB(List<String> selectedSeats) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // FirebaseAuth user = FirebaseAuth.instance;

    await firestore
        .collection('app')
        .doc('requests')
        .collection('minacamp')
        .doc('camp')
        .set({'BookedSeats': occupieddb.followedBy(selectedSeats)});
  }

  Widget _buildSeat(String seat) {
    setState(() {});
    final isSelected = selectedSeats.contains(seat);
    final isOccupied = occupiedSeats.contains(seat);
    print(isOccupied);
    final colors = (isOccupied == true)
        ? Colors.red
        : (isSelected ? Colors.green : Colors.grey[300]);
    // final textColor = isSelected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        if (!isOccupied) {
          _toggleSeat(seat);
        }
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          seat,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book CAMP"),
      ),
      body: GridView.count(
        crossAxisCount: 5,
        children: seats.map((seat) => _buildSeat(seat)).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final message =
              "Selected Seats (${selectedSeats.length}/4): ${selectedSeats.join(", ")}";

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Confirm Booking"),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    _sendseattoDB(selectedSeats);
                    Navigator.of(context).pop();
                  },
                  child: Text("Book"),
                ),
              ],
            ),
          );
        },
        label: Text("Book Seats (${selectedSeats.length}/4)"),
        icon: Icon(Icons.check),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class StadiumScreen extends StatefulWidget {
//   @override
//   _StadiumScreenState createState() => _StadiumScreenState();
// }

// class _StadiumScreenState extends State<StadiumScreen> {
//   final List<String> allSeats = [    'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10',    'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B9', 'B10',    'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10',    'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10',    'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9', 'E10',  ];
//   List<String> selectedSeats = [];
//   List<String> occupiedSeats = [];

//   @override
//   void initState() {
//     super.initState();
//     // Fetch the list of occupied seats from Firestore and update the UI
//     FirebaseFirestore.instance.collection('seats').get().then((querySnapshot) {
//       setState(() {
//         for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//           final seat = doc.id;
//           final booked = doc.data()['booked'];
//           if (booked) {
//             occupiedSeats.add(seat);
//           }
//         }
//       });
//     });

//     // Listen for changes to the list of occupied seats and update the UI in real-time
//     FirebaseFirestore.instance.collection('seats').snapshots().listen((snapshot) {
//       setState(() {
//         for (DocumentChange change in snapshot.docChanges) {
//           final seat = change.doc.id;
//           final booked = change.doc.data()['booked'];
//           if (booked) {
//             occupiedSeats.add(seat);
//           } else {
//             occupiedSeats.remove(seat);
//           }
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cricket Stadium'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.all(16),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 childAspectRatio: 2/1,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//               ),
//               itemCount: allSeats.length,
//               itemBuilder: (context, index) {
//                 return _buildSeat(allSeats[index]);
//               },
//             ),
//             SizedBox(height: 16),
//             Text('Remaining seats: ${getRemainingSeats()}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSeat(String seat) {
//     final isSelected = selectedSeats.contains(seat);
//     final isOccupied = occupiedSeats.contains(seat);
//     final color = isOccupied || (isSelected && occupiedSeats.contains(seat)) ? Colors.red : (isSelected ? Colors.green

// import 'package:flutter/material.dart';

// class StadiumSeatBookingPage extends StatefulWidget {
//   @override
//   _StadiumSeatBookingPageState createState() => _StadiumSeatBookingPageState();
// }

// class _StadiumSeatBookingPageState extends State<StadiumSeatBookingPage> {
//   // Sample data of available and booked seats
//   List<String> availableSeats = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
//   List<String> bookedSeats = ['A3', 'B3', 'C3'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cricket Stadium Seat Booking'),
//       ),
//       body: GridView.count(
//         crossAxisCount: 6, // Number of columns
//         children: List.generate(18, (index) {
//           // Generate a widget for each seat
//           String seat =
//               String.fromCharCode(index + 65) + ((index % 6) + 1).toString();
//           return Padding(
//             padding: EdgeInsets.all(8.0),
//             child: GestureDetector(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: bookedSeats.contains(seat)
//                       ? Colors.red
//                       : availableSeats.contains(seat)
//                           ? Colors.green
//                           : Colors.grey,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Center(
//                   child: Text(
//                     seat,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//               onTap: () {
//                 if (availableSeats.contains(seat)) {
//                   // Handle booking confirmation here
//                   setState(() {
//                     availableSeats.remove(seat);
//                     bookedSeats.add(seat);
//                   });
//                 }
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
