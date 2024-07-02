import 'package:flutter/material.dart';
import 'package:vma_frontend/src/screens/admin/assign_hosts.dart';
class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  void _onNavigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            TaskCard(
              title: 'Assign Hosts',
              icon: Icons.person_add,
              color: Colors.white,
              onTap: () => _onNavigate(context, '/assignHosts'),
            ),
            TaskCard(
              title: 'Allowed Plate Numbers',
              icon: Icons.car_rental,
              color: Colors.white,
              onTap: () => _onNavigate(context, '/allowedPlateNumbers'),
            ),
            TaskCard(
              title: 'Allowed Possessions',
              icon: Icons.security,
              color: Colors.white,
              onTap: () => _onNavigate(context, '/allowedPossessions'),
            ),
            TaskCard(
              title: 'New Regulations',
              icon: Icons.rule,
              color: Colors.white,
              onTap: () => _onNavigate(context, '/newRegulations'),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Color.fromARGB(
                    255, 25, 25, 112), // Adjust icon color if needed
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjust text color if needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy pages for navigation (replace these with your actual pages)


class AllowedPlateNumbersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allowed Plate Numbers')),
      body: const Center(child: Text('Allowed Plate Numbers Page')),
    );
  }
}

class AllowedPossessionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allowed Possessions')),
      body: const Center(child: Text('Allowed Possessions Page')),
    );
  }
}

class NewRegulationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Regulations')),
      body: const Center(child: Text('New Regulations Page')),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TasksPage(),
    routes: {
      '/assignHosts': (context) => AssignHostsPage(),
      '/allowedPlateNumberes': (context) => AllowedPlateNumbersPage(),
      '/allowedPossessions': (context) => AllowedPossessionsPage(),
      '/newRegulations': (context) => NewRegulationsPage(),
    },
  ));
}
