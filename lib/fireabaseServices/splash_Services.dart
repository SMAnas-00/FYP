import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:newui/Screens/SplashScreen.dart';

class SplashServices {
  Future<void> isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    final driverDoc = await FirebaseFirestore.instance
        .collection('app')
        .doc('Users')
        .collection("Signup")
        .doc(user?.uid)
        .get();

    if (user != null) {
      if (driverDoc.data()?['Role'] == 'user') {
        Timer(const Duration(seconds: 2),
            () => Navigator.pushNamed(context, '/navbar'));
      } else {
        Timer(const Duration(seconds: 2),
            () => Navigator.pushNamed(context, '/admindash'));
      }
    } else {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushNamed(context, '/welcome'));
    }
  }
}
