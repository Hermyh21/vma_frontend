import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/screens/securityDivision/check_visitor.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import '../../components/header.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  int _selectedIndex = 0;
  List<Visitor> visitorsYetToArrive = [];

  @override
  void initState() {
    super.initState();
    fetchVisitorsYetToArrive();
  }

  Future<void> fetchVisitorsYetToArrive() async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/api/visitors/:id'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        visitorsYetToArrive =
            data.map((json) => Visitor.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load visitors');
    }
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigate(String route) {
    switch (route) {
      case '/':
        _setSelectedIndex(0);
        break;
      case '/about':
      case '/settings':
        Navigator.pushNamed(context, route);
        break;
      case '/logout':
        // Handle logout here
        break;
    }
  }

  void _onVisitorNavigate(String visitorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CheckVisitorScreen(visitorId: visitorId)),
    );
  }

  final List<Widget> _screens = <Widget>[
    const Center(child: Text('List of visitors yet to arrive')),
    const Center(child: Text('List of visitors currently in the compound')),
    const Center(child: Text('List of Visitors who have left the compound')),
  ];

  Widget _buildVisitorsList() {
    return ListView.builder(
      itemCount: visitorsYetToArrive.length,
      itemBuilder: (context, index) {
        final visitor = visitorsYetToArrive[index];
        return ListTile(
          title: Text(visitor.names.join(', ')),
          subtitle: Text(
              'Purpose: ${visitor.purpose}\nHost: ${visitor.selectedHostName}'),
          // onTap: () => _onNavigate(visitor
          //     .selectedHostName), // Assuming visitor has a unique host ID or name
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _screens[0] =
        _buildVisitorsList(); // update the first screen to show the visitors list

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(onNavigate: _onNavigate),
          ClipPath(
            clipper: MyClip(),
            child: Container(
              height: 200.0,
              color: Constants.customColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Security Division Screen",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      height: 45.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 34.0,
                        vertical: 30.0,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Search for Visitor's name",
                          hintStyle: TextStyle(
                            color: Constants.customColor,
                            fontWeight: FontWeight.w200,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            size: 20.0,
                            color: Color.fromARGB(255, 25, 25, 112),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 25, 25, 112),
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    "Today's list of visitors",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 25, 25, 112),
                    ),
                  ),
                ),
              ],
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upcoming,
              color: Color.fromARGB(255, 25, 25, 112),
            ),
            label: 'Yet to arrive',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pending_actions_sharp,
              color: Color.fromARGB(255, 25, 25, 112),
            ),
            label: 'Inside the compound',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check,
              color: Color.fromARGB(255, 25, 25, 112),
            ),
            label: 'Who already left',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 25, 25, 112),
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
    path.lineTo(size.width, size.height - 50.0);
    path.quadraticBezierTo(
        size.width - 70.0, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(size.width / 3.0, size.height - 32, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
