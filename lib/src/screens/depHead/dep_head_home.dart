import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/components/header.dart';
import 'package:vma_frontend/src/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/screens/depHead/manage_visitors_screen.dart';

class DepartmentHeadsPage extends StatefulWidget {
  @override
  _DepartmentHeadsPageState createState() => _DepartmentHeadsPageState();
}

class _DepartmentHeadsPageState extends State<DepartmentHeadsPage> {
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 120.0 * 7,
  );
  List<Visitor> visitors = [];
  late DateTime _selectedDate;
  final now = DateTime.now();
  late List<DateTime> days;

  int _selectedIndex = 0;

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

  void _onNavigate(String route) {
    switch (route) {
      case '/':
        _setSelectedIndex(0);
        break;
      case '/about':
        Navigator.pushNamed(context, route);
      //case '/settings':
        //Navigator.pushNamed(context, route);
        //break;
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
bool approved = false;
bool declined = false;
  Future<void> _showVisitorLogs(DateTime day) async {
    try {
      final logs = await ApiService.fetchVisitorLogs(day);

      setState(() {
        visitorLogs = logs.map((log) {
          approved = log.approved; // Set the status here
        declined = log.declined; 
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
            'approved': log.approved.toString(),
          'declined': log.declined.toString(),
          'declineReason': log.declineReason,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching visitor logs: $e');
    }
  }

  void _onEditVisitor(String visitorId) async {    
    try {
      final visitor = await ApiService.getVisitorById(visitorId);              
      setState(() {
        editVisitorLogs = [visitor].map((log) {
          final List<Map<String, dynamic>> possessions = log.possessions.map((possession) {
            return {
              'item': possession.item,
              
            };
          }).toList();

          return {
            'id': log.id.toString(),
            'name': log.names.toString(),
            'purpose': log.purpose,

            'startDate': log.startDate.toString(),
            'endDate': log.endDate.toString(),
            'bringCar': log.bringCar.toString(),
            'selectedPlateNumbers': log.selectedPlateNumbers.toString(),
            'possessions': possessions.map((possession) => possession['item']).join(', ').toString(),
            // 'approved': log.approved.toString(),
            // 'declined': log.declined.toString(),

          };
        }).toList();
      });
      print("datattttt");
print(editVisitorLogs);

      // final editedLog = await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ManageVisitorsScreen(visitorLogs: editVisitorLogs),
      //   ),
      // );

      // if (editedLog != null) {
      //   _showVisitorLogs(_selectedDate);
      // }
      final bool? result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ManageVisitorsScreen(visitorLogs: editVisitorLogs),
  ),
);

if (result == true) {
  _showVisitorLogs(_selectedDate); // Refresh the logs if the update was successful
}


    } catch (e) {
      print('Failed to fetch visitor details: $e');
      // Handle the error appropriately
    }
  }

  void _filterVisitors() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredVisitorLogs = visitorLogs.where((log) {
        final name = log['name']!.toLowerCase();
        print('Checking name: $name'); 
        return name.contains(query);
      }).toList();
    });
  }

  void _requestStatus(String visitorId, bool approved, bool declined, String? declineReason) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (approved) {
          return AlertDialog(
            title: const Text("Status"),
            content: const Text("Request has been approved."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (declined) {
          return AlertDialog(
  title: const Text("Decline Reason:", style: TextStyle(fontSize: 18,)),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      
      Text(declineReason ?? "No reason provided."),
      const SizedBox(height: 8.0), // Add some space between the text and subtitle
      
    ],
  ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Pending..."),
            content: const Text("Request hasn't been approved yet."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
  void _onDeleteVisitor(String visitorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to remove this visitor?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                try {

                  await ApiService.deleteVisitorById(visitorId);

                  setState(() {
                    visitorLogs.removeWhere((log) => log['id'] == visitorId);
                  });

                  Navigator.of(context).pop();
                } catch (e) {
                  print('Failed to delete visitor: $e');
                  // Handle the error appropriately, e.g., show an error message
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onVisitorNameTap(List<String> visitorName) {
    print("Visitor name tapped: $visitorName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                        "Head of Department Screen",
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
                  ElevatedButton(
                    onPressed: () async {

                      final bool? feedback= await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageVisitorsScreen(visitorLogs: []),
                        ),
                      );
                      if (feedback == true) {
  _showVisitorLogs(_selectedDate); // Refresh the logs if the update was successful
}
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
                  )
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
                Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days.map((day) {
                  final isSelected = day == _selectedDate;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                        _showVisitorLogs(day);
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat('E').format(day),
                          style: TextStyle(
                              color: isSelected ? Constants.customColor : Colors.grey),
                        ),
                        const SizedBox(height: 4.0),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Constants.customColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: filteredVisitorLogs.map((log) {
                  // Retrieve `approved` and `declined` status from fullVisitorLogs
                final fullLog = fullVisitorLogs.firstWhere(
                    (visitorLog) => visitorLog['id'] == log['id']);
                final bool isApproved = fullLog['approved'] == 'true';
                final bool isDeclined = fullLog['declined'] == 'true';
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    Expanded(
      child: GestureDetector(
        onTap: () => _onVisitorNameTap([log['name']!]),
        child: Text(
          log['name']!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Constants.customColor,
          ),
          overflow: TextOverflow.visible, // Ensures the text can wrap to the next line
        ),
      ),
    ),
    if (!isApproved && !isDeclined)
    Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!approved && !declined)
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            _onEditVisitor(log['id']!);
          },
        ),
        if (!approved && !declined)
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _onDeleteVisitor(log['id']!);
          },
        ),
      ],
    ),
  ],
),

                        const SizedBox(height: 8.0),
                        Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Conditional text button rendering based on approval status
                                          if (isApproved)
                                            TextButton(
                                              onPressed: () => _requestStatus(
                                                log['id']!,
                                                isApproved,
                                                isDeclined,
                                                log['declineReason'],
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                
                                              ),
                                              child: const Text("Approved", style: TextStyle(color: Colors.green,),),
                                            )
                                          else if (isDeclined)
                                            TextButton(
                                              onPressed: () => _requestStatus(
                                                log['id']!,
                                                isApproved,
                                                isDeclined,
                                                log['declineReason'],
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                
                                              ),
                                              child: const Text("Declined", style: TextStyle(color: Colors.red),),
                                            )
                                          else
                                            TextButton(
                                              onPressed: () => _requestStatus(
                                                log['id']!,
                                                isApproved,
                                                isDeclined,
                                                log['declineReason'],
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Constants.customColor[100],
                                                
                                              ),
                                              child: const Text("Pending..", style: TextStyle(color: Colors.white),),
                                            ),
                                          
                                        ],
                                      ),
                        
                        // Row(
                        //   children: <Widget>[
                        //     TextButton(
                        //       onPressed: () {
                        //         final fullLog = fullVisitorLogs.firstWhere(
                        //             (visitorLog) => visitorLog['id'] == log['id']);
                        //         _requestStatus(
                        //           fullLog['id']!,
                        //           isApproved,
                        //         isDeclined,
                        //           fullLog['declineReason'],
                        //         );
                        //       },
                        //       child: const Text("Check Status"),
                        //     ),
                        //   ],
                        // ),

                      ],
                    ),
                  );
                }).toList(),
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
