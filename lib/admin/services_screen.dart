import 'package:flutter/material.dart';
import 'package:newui/admin/my_animal.dart';
import 'package:newui/admin/my_flights.dart';
import 'package:newui/admin/my_hotels.dart';
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
      length: 4,
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
                child: Text("Hotel"),
              ),
              Tab(
                child: Text("Flight"),
              ),
              Tab(
                child: Text("Transport"),
              ),
              Tab(
                child: Text("Animal"),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [MyHotels(), MyFlights(), MyTransport(), MyAnimal()],
        ),
      ),
    );
  }
}
