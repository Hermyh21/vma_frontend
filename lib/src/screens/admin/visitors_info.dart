import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/screens/admin/visitor_detail_page.dart'; 

import 'package:vma_frontend/src/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';

class VisitorsInfo extends StatefulWidget {
  @override
  _VisitorsInfoState createState() => _VisitorsInfoState();
}

class _VisitorsInfoState extends State<VisitorsInfo> {
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 120.0 * 7,
  );
  List<Visitor> visitors = [];
  late DateTime _selectedDate;
  final now = DateTime.now();
  late List<DateTime> days;

  List<Map<String, String>> visitorLogs = [];
  List<Map<String, String?>> fullVisitorLogs = [];
  List<Map<String, String?>> editVisitorLogs = [];
  List<Map<String, String>> filteredVisitorLogs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = now; // Set the default selected date to the current date
    days =
        List.generate(15, (index) => now.subtract(Duration(days: 7 - index)));
    _showVisitorLogs(_selectedDate); // Show logs for the initial selected date
    searchController.addListener(_filterVisitors);
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('visitorLogsUpdated', (data) {
      setState(() {
        visitors =
            (data as List).map((json) => Visitor.fromJson(json)).toList();
      });
    });
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.dispose();
    searchController.dispose();
    super.dispose();
  }

  // void _setSelectedIndex(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  Future<void> _showVisitorLogs(DateTime day) async {
    try {
      final logs = await ApiService.fetchVisitorLogs(day);

      setState(() {
        visitorLogs = logs.map((log) {
          return {
            'id': log.id.toString(),
            'name': log.names.join(', '), //
          };
        }).toList();
        filteredVisitorLogs = visitorLogs;
      });
      setState(() {
        fullVisitorLogs = logs.map((log) {
          return {
            'id': log.id.toString(),
            'name': log.names.join(', '),
            'purpose': log.purpose,
            'startDate': log.startDate.toString(),
            'endDate': log.endDate.toString(),
            'bringCar': log.bringCar.toString(),
            'plateNumbers': log.selectedPlateNumbers.toString(),
            'possessions': log.possessions.join(', '),
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching visitor logs: $e');
    }
  }
void _visitorStatus(){
  
}
  void _filterVisitors() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredVisitorLogs = visitorLogs.where((log) {
        final name = log['name']!.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  void _onVisitorNameTap(String visitorId) {
    print("Visitor id tapped: $visitorId");
    final visitor = visitors.firstWhere(
      (visitor) => visitor.id == visitorId, 
    );
   

    try{
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VisitorDetailPage(visitor: visitor),
    ),
  );
} catch (e, stackTrace) {
  print("Error navigating to VisitorDetailPage: $e");
  print(stackTrace);
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white, // Set icon color to white
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Secure Gate',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Constants.customColor, // Use Constants.customColor for app bar background color
        iconTheme: const IconThemeData(color: Colors.white), // Set icon colors to white
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                        "Visitors Log",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 45.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 34.0, vertical: 30.0),
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
                                horizontal: 16.0, vertical: 14.0),
                            suffixIcon: const Icon(
                              Icons.search,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0)
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
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    DateFormat('EEEE').format(now),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 150.0,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final day = days[index];
                        final isSelected = day.day == _selectedDate.day &&
                            day.month == _selectedDate.month &&
                            day.year == _selectedDate.year;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = day;
                            });
                            _showVisitorLogs(day);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120.0,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color.fromARGB(255, 25, 25, 112)
                                    : null,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('MMMM').format(day),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d').format(day),
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "List of visitors on the selected date",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 25, 25, 112)),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: filteredVisitorLogs.map((log) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Constants.customColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 25, 25, 112),
                        ),
                        title: GestureDetector(
                          onTap: () {
   
      _onVisitorNameTap(log['id']!);
    
  },
                          child: Text(
                            log['name']!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 25, 112),
                            ),
                          ),
                        ),
                        
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
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
