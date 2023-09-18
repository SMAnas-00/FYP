import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newui/Screens/user_animal_booking.dart';
import 'package:newui/Screens/user_flight_booking.dart';
import 'package:newui/Screens/user_hotel_booking.dart';
import 'package:newui/Screens/user_mina_booking.dart';
import 'package:newui/Screens/user_transport_booking.dart';

class UserBookings extends StatefulWidget {
  const UserBookings({super.key});

  @override
  State<UserBookings> createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff3a57e8),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Bookings',
          ),
          bottom: const TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Icon(Icons.hotel),
              ),
              Tab(
                child: Icon(Icons.flight),
              ),
              Tab(
                child: Icon(Icons.car_rental),
              ),
              Tab(
                child: FaIcon(
                  FontAwesomeIcons.cow,
                ),
              ),
              Tab(
                child: FaIcon(
                  FontAwesomeIcons.tent,
                ),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserHotelBooking(),
            UserFlightBooking(),
            UserTransportBooking(),
            UserAnimalBooking(),
            UserMinaBooking(),
          ],
        ),
      ),
    );
  }
}
