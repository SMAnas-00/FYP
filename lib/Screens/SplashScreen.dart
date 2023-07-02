import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
        () => Navigator.pushReplacementNamed(context, '/welcome'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3a57e8),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(right: 90),
              child: Align(
                alignment: Alignment.center,
                child: Lottie.network(
                  "https://assets9.lottiefiles.com/packages/lf20_qxTk8T2ezR.json",
                  height: MediaQuery.of(context).size.height * 0.21,
                  width: MediaQuery.of(context).size.width * 0.55,
                  fit: BoxFit.cover,
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 60),
              child: Text(
                "ASALAM-U-ALIKUM",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.1),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
                color: Color(0xffffffff),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xff3a57e8),
                height: 45,
                minWidth: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
