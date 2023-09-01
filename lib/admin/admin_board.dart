import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 1.5,
        children: [
          AdminDashboardCard(
            title: 'Users',
            icon: Icons.person,
            onPressed: () {
              // Navigate to users management page
              Navigator.pushNamed(context, '/users');
            },
          ),
          AdminDashboardCard(
            title: 'Hotels',
            icon: Icons.hotel,
            onPressed: () {
              // Navigate to hotels management page
              Navigator.pushNamed(context, '/adminhotelcreate');
            },
          ),
          AdminDashboardCard(
            title: 'Flights',
            icon: Icons.flight,
            onPressed: () {
              // Navigate to flights management page
              Navigator.pushNamed(context, '/addflight');
            },
          ),
          AdminDashboardCard(
            title: 'Transport',
            icon: Icons.directions_car,
            onPressed: () {
              // Navigate to transport management page
              Navigator.pushNamed(context, '/addtransport');
            },
          ),
          AdminDashboardCard(
            title: 'Requests',
            icon: Icons.request_page,
            onPressed: () {
              // Navigate to flights management page
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}

class AdminDashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const AdminDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48.0),
              const SizedBox(height: 8.0),
              Text(title, style: const TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}
