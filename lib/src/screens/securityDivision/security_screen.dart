import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/components/header.dart';
import 'package:vma_frontend/src/screens/securityDivision/yet_to_arrive.dart';
import 'package:vma_frontend/src/screens/securityDivision/already_left.dart';
import 'package:vma_frontend/src/screens/securityDivision/inside_the_compound.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  final List<Widget> _screens = [
    // Placeholder widgets
    Container(), // Placeholder for YetToArrive
    const InsideTheCompound(),
    const AlreadyLeft(),
  ];

  @override
  void initState() {
    super.initState();
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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(onNavigate: _onNavigate),
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
                                onChanged: _onSearchChanged,
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
                  Container(
                    height: 500, 
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        Builder(
                          builder: (context) => YetToArrive(searchQuery: _searchQuery),
                        ),
                        const InsideTheCompound(),
                        const AlreadyLeft(),
                      ],
                    ),
                  ),
                ],
              ),
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
