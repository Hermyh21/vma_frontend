import 'package:flutter/material.dart';
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
          Header(onNavigate: _onNavigate),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        height: 150.0,
                        color: Constants.customColor,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Approval Division Screen",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 75.0),
                            ],
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
                                backgroundColor:const Color.fromARGB(255, 25, 25, 112), // Background color
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
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 120, // Adjust the height as necessary
                    decoration:const  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
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
                                  backgroundColor: const Color.fromARGB(255, 25, 25, 112), 
                                ),
                                child: const Text(
                                  "Add Visitors",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, 
                                    fontSize: 14.0,
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
                  ),
                ),
              ],
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
