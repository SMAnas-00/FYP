import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CricketStadium extends StatefulWidget {
  const CricketStadium({super.key});

  @override
  _CricketStadiumState createState() => _CricketStadiumState();
}

class _CricketStadiumState extends State<CricketStadium> {
  // List<String> seats = [
  //   "A1",
  //   "A2",
  //   "A3",
  //   "A4",
  //   "A5",
  //   "B1",
  //   "B2",
  //   "B3",
  //   "B4",
  //   "B5",
  //   "C1",
  //   "C2",
  //   "C3",
  //   "C4",
  //   "C5",
  //   "D1",
  //   "D2",
  //   "D3",
  //   "D4",
  //   "D5",
  // ];
  List<String> seats = [];
  List<String> selectedSeats = [];
  List<String> occupiedSeats = [];
  List<String> occupieddb = [];

  void categorizeSeats() {
    for (var i = 0; i < 3; i++) {
      for (var j = 1; j <= 30; j++) {
        seats.add(String.fromCharCode(65 + i) + j.toString());
      }
    }
  }

  // void _toggleSeat(String seat) {
  //   setState(() {
  //     if (selectedSeats.contains(seat)) {
  //       selectedSeats.remove(seat);
  //     } else if (selectedSeats.length < 4) {
  //       selectedSeats.add(seat);
  //     }
  //   });
  // }
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
    categorizeSeats();
    getList();
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

  // Widget _buildSeat(String seat) {
  //   setState(() {});
  //   final isSelected = selectedSeats.contains(seat);
  //   final isOccupied = occupiedSeats.contains(seat);
  //   print(isOccupied);
  //   final colors = (isOccupied == true)
  //       ? Colors.red
  //       : (isSelected ? Colors.green : Colors.grey[300]);
  //   // final textColor = isSelected ? Colors.white : Colors.black;

  //   return GestureDetector(
  //     onTap: () {
  //       if (!isOccupied) {
  //         _toggleSeat(seat);
  //       }
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.all(4),
  //       padding: const EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         color: colors,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Text(
  //         seat,
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           color: isSelected ? Colors.white : Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildSeat(String seat) {
    final isSelected = selectedSeats.contains(seat);
    final isOccupied = occupiedSeats.contains(seat);
    final category = seat[0]; // Get the category (A, B, or C)
    final colors = isOccupied
        ? Colors.red
        : (isSelected ? Colors.green : Colors.grey[300]);

    return GestureDetector(
      onTap: () {
        if (!isOccupied) {
          _toggleSeat(seat);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Book CAMP"),
  //     ),
  //     body: GridView.count(
  //       crossAxisCount: 5,
  //       children: seats.map((seat) => _buildSeat(seat)).toList(),
  //     ),
  //     floatingActionButton: FloatingActionButton.extended(
  //       onPressed: () {
  //         final message =
  //             "Selected Seats (${selectedSeats.length}/4): ${selectedSeats.join(", ")}";

  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text("Confirm Booking"),
  //             content: Text(message),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text("Cancel"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   _sendseattoDB(selectedSeats);
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Book"),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //       label: Text("Book Seats (${selectedSeats.length}/4)"),
  //       icon: const Icon(Icons.check),
  //     ),
  //   );
  // }
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
    // Replace these with your actual data and logic for each category
    int numCamps = 0;
    int numSlots = 0;

    if (category == 'A') {
      numCamps = 20;
      numSlots = 4;
    } else if (category == 'B') {
      numCamps = 100;
      numSlots = 10;
    } else if (category == 'C') {
      numCamps = 200;
      numSlots = 30;
    }

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
