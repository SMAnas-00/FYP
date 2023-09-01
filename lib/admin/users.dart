// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference Username = FirebaseFirestore.instance
      .collection('app')
      .doc('Users')
      .collection('Signup');
  late Stream<QuerySnapshot> _streamUsername;
  @override
  void initState() {
    super.initState();
    _streamUsername = Username.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3a57e8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamUsername,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.active) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> listqureysnap = querySnapshot.docs;
            return ListView.builder(
                itemCount: listqureysnap.length,
                itemBuilder: ((context, index) {
                  QueryDocumentSnapshot documentSnapshot = listqureysnap[index];
                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(documentSnapshot['First_name'] +
                                  documentSnapshot['Last_name']),
                              Text(documentSnapshot['Status']),
                              Text(documentSnapshot['Role']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
