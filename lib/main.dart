import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:newui/Screens/FlightScreen.dart';
import 'package:newui/Screens/TODO/TodoListScreen.dart';
import 'package:newui/Screens/animalBookscreen.dart';
import 'package:newui/Screens/guideScreen.dart';
import 'package:newui/Screens/local_push_notification.dart';
import 'package:newui/Screens/transportScreen.dart';
import 'package:newui/admin/flight.dart';
import 'package:newui/admin/transport.dart';
import 'package:newui/admin/users.dart';
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
import 'admin/admin_board.dart';
import 'admin/hotelcreation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Stripe.publishableKey =
      "pk_test_51Mv69yHAyrQONTKfe3o0jIXnyegPX6Cb641BhEuIVDJXyNBw2zjDJBRE7K7RGBETebqG3tgZOC6TJVuT5Vbgh3Et00B2nEPOk9";
  runApp(const MyApp());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// onClick listener
  // print("Handling a background message : ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NewUI",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/signin': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forget': (context) => const ForgetScreen(),
        '/home': (context) => const HomeScreen(),
        '/navbar': (context) => const BottomNavBar(),
        '/map': (context) => MapView(),
        '/camp': (context) => const CricketStadium(),
        '/hotel': (context) => const HotelScreen(),
        '/admindash': (context) => const AdminHomePage(),
        '/adminhotelcreate': (context) => const addHotelScreen(),
        '/todo': (context) => const ToDoScreen(),
        '/flight': (context) => const FlightList(),
        '/transport': (context) => const TransportService(),
        '/guide': (context) => const guideScreen(),
        '/users': (context) => const ViewUserScreen(),
        '/addtransport': (context) => const addTransportScreen(),
        '/addflight': (context) => const addFlightScreen(),
        '/animal': (context) => const AnimalBookingPage()
      },
    );
  }
}
