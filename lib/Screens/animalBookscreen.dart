// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AnimalBookingPage extends StatefulWidget {
  const AnimalBookingPage({super.key});

  @override
  _AnimalBookingPageState createState() => _AnimalBookingPageState();
}

class _AnimalBookingPageState extends State<AnimalBookingPage> {
  String _animalType = 'GOAT - 10,000';
  int _numberOfAnimals = 1;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth user = FirebaseAuth.instance;

  final List<String> _animalTypes = [
    'GOAT - 10,000',
    'GOAT - 15,000',
    'GOAT - 18,000',
    'GOAT - 20,000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Booking'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[300],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Select animal type:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              DropdownButton(
                value: _animalType,
                items: _animalTypes.map((animalType) {
                  return DropdownMenuItem(
                    value: animalType,
                    child: Text(animalType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _animalType = value!;
                  });
                },
              ),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 16.0),
              const Text(
                'Number of animals:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (_numberOfAnimals > 1) {
                          _numberOfAnimals--;
                        }
                        if (_numberOfAnimals <= 0) {
                          _numberOfAnimals = 0;
                        }
                      });
                    },
                    backgroundColor:
                        (_numberOfAnimals <= 1) ? Colors.black26 : Colors.teal,
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    _numberOfAnimals.toString(),
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (_numberOfAnimals >= 6) {
                          _numberOfAnimals = 6;
                        } else {
                          _numberOfAnimals++;
                        }
                      });
                    },
                    backgroundColor:
                        (_numberOfAnimals >= 6) ? Colors.black26 : Colors.teal,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  int animalCost = 10000;
                  if (_animalType == 'GOAT - 10,000') {
                    animalCost = 10000 * _numberOfAnimals;
                  }
                  if (_animalType == 'GOAT - 15,000') {
                    animalCost = 15000 * _numberOfAnimals;
                  }
                  if (_animalType == 'GOAT - 18,000') {
                    animalCost = 18000 * _numberOfAnimals;
                  }
                  if (_animalType == 'GOAT - 20,000') {
                    animalCost = 20000 * _numberOfAnimals;
                  }
                  await firestore
                      .collection('app')
                      .doc('bookings')
                      .collection('cart')
                      .doc('request')
                      .collection(user.currentUser!.uid)
                      .doc('animal')
                      .set({
                    'id': user.currentUser!.uid,
                    'image': '',
                    'name': _animalType,
                    'price': animalCost
                  }, SetOptions(merge: true)).then((value) {
                    Fluttertoast.showToast(msg: 'request has been sent');
                  });
                  await firestore
                      .collection('app')
                      .doc('bookings')
                      .collection('admin')
                      .doc('request')
                      .collection(user.currentUser!.uid)
                      .doc('request')
                      .set({
                    'id': user.currentUser!.uid,
                    'image': '',
                    'name': _animalType,
                    'price': animalCost
                  }, SetOptions(merge: true));
                },
                child: const Text('Book Animal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
