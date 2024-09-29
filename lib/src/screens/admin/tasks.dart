import 'package:flutter/material.dart';
import 'package:vma_frontend/src/screens/admin/plate_numbers.dart';
import 'package:vma_frontend/src/screens/admin/possessions.dart';
import 'package:vma_frontend/src/screens/admin/user_count.dart';
import 'package:vma_frontend/src/screens/admin/department.dart';
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  // void _onNavigate(BuildContext context, String route) {
  //   Navigator.pushNamed(context, route);
  // }
void _onNavigate(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
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
              title: 'Allowed Plate Numbers',
              icon: Icons.car_rental,
              color: Colors.white,
              onTap: () => _onNavigate(context, const AllowedPlateNumbersPage()),
            ),
            TaskCard(
              title: 'Allowed Possessions',
              icon: Icons.security,
              color: Colors.white,
              onTap: () => _onNavigate(context, const AllowedPossessionsPage()),
            ),
            TaskCard(
              title: 'Manage Departments',
              icon: Icons.business,
              color: const Color.fromARGB(255, 139, 139, 204),
              onTap: () => _onNavigate(context, const DepartmentsPage()),
            ),
            TaskCard(
              title: 'Users Information',
              icon: Icons.person,
              color: Colors.white,
              onTap: () => _onNavigate(context, UserCount()),
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
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

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
                color: const Color.fromARGB(
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
