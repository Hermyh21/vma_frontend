import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/components/header.dart';
import 'package:vma_frontend/src/screens/approvalDivision/approved_requests.dart';
import 'package:vma_frontend/src/screens/approvalDivision/declined_requests.dart';
import 'package:vma_frontend/src/screens/approvalDivision/new_requests.dart';

import 'package:vma_frontend/src/constants/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ApprovalDivision extends StatefulWidget {
  @override
  _ApprovalDivisionState createState() => _ApprovalDivisionState();
}

class _ApprovalDivisionState extends State<ApprovalDivision> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    NewRequestsScreen(),
    ApprovedRequests(),
    DeclinedRequestsScreen(),
  ];

  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _onNavigate(String route) {
    switch (route) {
      case '/':
        _setSelectedIndex(0);
        break;
      case '/about':
        Navigator.pushNamed(context, route);
        break;
      case '/settings':
        Navigator.pushNamed(context, route);
        break;
      case '/logout':
        // Handle logout here
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
      body: Column(
        children: [
          Header(onNavigate: _onNavigate), // Header widget
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
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
                              "Approval Division Screen",
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
                                controller: searchController,
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
                    child: Row(
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/manage_visitors');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Constants.customColor, // Background color
                          ),
                          child: const Text(
                            "Add Visitors",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 500, // Example height for the list of visitors
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: _screens,
                    ),
                  ),
                ],
              ),
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
          Icon(
            Icons.check,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.cancel,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: _setSelectedIndex,
      ),
    );
  }
}

class MyClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
