import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newui/admin/my_animal.dart';
import 'package:newui/admin/my_flights.dart';
import 'package:newui/admin/my_hotels.dart';
import 'package:newui/admin/my_mina.dart';
import 'package:newui/admin/my_transport.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 29, 165, 153),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Services',
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
            MyHotels(),
            MyFlights(),
            MyTransport(),
            MyAnimal(),
            MyMina()
          ],
        ),
      ),
    );
  }
}
