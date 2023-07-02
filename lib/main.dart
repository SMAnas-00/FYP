import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:newui/Screens/FlightScreen.dart';
import 'package:newui/Screens/TODO/TodoListScreen.dart';
import 'package:newui/Screens/guideScreen.dart';
import 'package:newui/Screens/transportScreen.dart';
import 'Screens/BottomNav.dart';
import 'Screens/Camp.dart';
import 'Screens/ForgetScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/HotelScreen.dart';
import 'Screens/MapScreen.dart';
import 'Screens/SigninScreen.dart';
import 'Screens/SignupScreen.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/WelcomeScreen.dart';
import 'Screens/codecheck.dart';
import 'Screens/hoteldetailScreen.dart';
import 'admin/admin_board.dart';
import 'admin/hotelcreation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox('Task');
  await Firebase.initializeApp();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Stripe.publishableKey =
      "pk_test_51Mv69yHAyrQONTKfe3o0jIXnyegPX6Cb641BhEuIVDJXyNBw2zjDJBRE7K7RGBETebqG3tgZOC6TJVuT5Vbgh3Et00B2nEPOk9";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NewUI",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/signin': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forget': (context) => ForgetScreen(),
        '/home': (context) => HomeScreen(),
        '/navbar': (context) => BottomNavBar(),
        '/map': (context) => MapView(),
        '/camp': (context) => CricketStadium(),
        '/hotel': (context) => HotelScreen(),
        '/admindash': (context) => AdminHomePage(),
        '/adminhotelcreate': (context) => AdminHotelScreen(),
        '/todo': (context) => ToDoScreen(),
        '/flight': (context) => FlightList(),
        '/transport': (context) => TransportService(),
        '/guide': (context) => guideScreen()
      },
    );
  }
}
