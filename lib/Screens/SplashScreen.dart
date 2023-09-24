import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newui/fireabaseServices/splash_Services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3a57e8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 90),
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
            const Padding(
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
              alignment: const Alignment(0.0, 0.2),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
                color: const Color(0xffffffff),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.all(16),
                textColor: const Color(0xff3a57e8),
                height: 45,
                minWidth: MediaQuery.of(context).size.width * 0.5,
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
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
