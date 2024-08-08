import 'package:flutter/material.dart';
import 'package:vma_frontend/src/components/header.dart';
import 'package:vma_frontend/src/screens/admin/create_users_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/screens/admin/tasks.dart';
import 'package:vma_frontend/src/about.dart';
import 'package:vma_frontend/src/services/auth_services.dart';
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const TasksPage(),
    const CreateUserScreen(),
    
  ];
 void logoutUser(BuildContext context) {
    AuthService().logout(context);
  }
  void _onNavigate(String route) {
    switch (route) {
      case '/':
        _setSelectedIndex(0);
        break;
      case '/about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()), // Navigate to About screen
        );
        break;
      
      case '/logout':
        logoutUser(context);
        break;
    }
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(onNavigate: _onNavigate),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                "Admin Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      Color.fromARGB(255, 25, 25, 112), // Adjusted text color
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: Constants.customColor,
        buttonBackgroundColor: Constants.customColor,
        height: 50,
        items: const <Widget>[
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.person_add, size: 30, color: Colors.white),
          
        ],
        onTap: _setSelectedIndex,
      ),
    );
  }
}

class MyClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 10.0);
    path.quadraticBezierTo(
        size.width - 70.0, size.height, size.width / 2, size.height - 15);
    path.quadraticBezierTo(size.width / 3.0, size.height - 2, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
