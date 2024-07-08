
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/providers/socket_service.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:dio/dio.dart';
class NewRequestsScreen extends StatefulWidget {
  @override
  _NewRequestsScreenState createState() => _NewRequestsScreenState();
}

class _NewRequestsScreenState extends State<NewRequestsScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Visitor> visitors = [];
  late DateTime _selectedDate;
  final now = DateTime.now();
  late List<DateTime> days;
  List<Map<String, String>> visitorLogs = [];
  List<Map<String, String?>> fullVisitorLogs = [];
  List<Map<String, String?>> editVisitorLogs = [];
  List<Map<String, String>> filteredVisitorLogs = [];
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
            'hostName': log.selectedHostName,
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

  void _filterVisitors() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredVisitorLogs = visitorLogs.where((log) {
        final name = log['name']!.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

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
    searchController.dispose();
    super.dispose();
  }

  // void _showVisitorLogs() {
  //   // Fetch visitor logs
  //   List<Map<String, dynamic>> logs = [
  //     {
  //       'name': ['Visitor 1'],
  //       'purpose': 'meeting',
  //       'selectedHostName': 'Mr X',
  //       'startDate': '2023-05-28',
  //       'endDate': '2023-05-28',
  //       'bringCar': true,
  //       'selectedPlateNumbers': ['1 AA', '1 BB'],
  //       'possessionQuantities': [
  //         {'item': 'Mobile Phones', 'quantity': 15}
  //       ],
  //     },
  //     {
  //       'name': ['Hermon', 'Lema', 'Aman'],
  //       'purpose': 'meeting',
  //       'selectedHostName': 'Mr Y',
  //       'startDate': '2023-05-28',
  //       'endDate': '2023-05-28',
  //       'bringCar': true,
  //       'selectedPlateNumbers': ['2 CC', '3 DD'],
  //       'possessionQuantities': [
  //         {'item': 'Laptops', 'quantity': 5}
  //       ],
  //     },
  //     // Add more visitor logs here
  //   ];

  //   setState(() {
  //     visitorLogs = logs;
  //     filteredVisitorLogs = logs;
  //   });
  // }

  void _onApproveVisitor(String visitorId) async {
  final visitorProvider = context.read<VisitorProvider>();
  Visitor? visitor;
  try {
    visitor = visitorProvider.visitors.firstWhere((v) => v.id == visitorId);
  } catch (e) {
    visitor = null;
  }

  if (visitor == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visitor not found')),
    );
    return;
  }

  try {
    // Create an instance of Dio
    final dio = Dio();

    // Send the approval request to the backend
    final response = await dio.put(
      '${Constants.uri}/approve/$visitorId',
    );

    if (response.statusCode == 200) {
      // Update the visitor's approved status locally
      visitorProvider.setVisitorFromModel(visitor!.copyWith(
        approved: true,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor approved')),
      );
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve visitor')),
      );
    }
  } catch (e) {
    // Handle network error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Network error')),
    );
  }
}
  
  void _onDeclineVisitor(String visitorId) {
  final visitorProvider = context.read<VisitorProvider>();
  Visitor? visitor;
  try {
    visitor = visitorProvider.visitors.firstWhere((v) => v.id == visitorId);
  } catch (e) {
    visitor = null;
  }

  if (visitor == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visitor not found')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      String declineReason = '';
      return AlertDialog(
        title: const Text('Reason to Decline'),
        content: TextField(
          onChanged: (value) {
            declineReason = value;
          },
          decoration: const InputDecoration(
            hintText: 'Enter reason for declining',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Send'),
            onPressed: () async {
              if (declineReason.isNotEmpty) {
                try {
                  // Create an instance of Dio
                  final dio = Dio();

                  // Send the decline reason to the backend
                  final response = await dio.put(
                    '${Constants.uri}/$visitorId',
                    data: {
                      'declineReason': declineReason,
                    },
                  );

                  if (response.statusCode == 200) {
                    // Update the visitor's declined status and reason locally
                    visitorProvider.setVisitorFromModel(visitor!.copyWith(
                      declined: true,
                      declineReason: declineReason,
                    ));

                    // Remove the visitor from the list
                    visitorProvider.declineVisitor(visitorId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Visitor declined')),
                    );

                    Navigator.of(dialogContext).pop();
                  } else {
                    // Handle error response
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to decline visitor')),
                    );
                  }
                } catch (e) {
                  // Handle network error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Network error')),
                  );
                }
              } else {
                // Handle case where reason is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reason cannot be empty')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

  void _onVisitorNameTap(String visitorName) {
    // Implement visitor name tap logic here
    print("Visitor name tapped: $visitorName");
  }

  bool isToday(String dateString) {
    final now = DateTime.now();
    final date = DateTime.parse(dateString);
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final visitorProvider = context.watch<VisitorProvider>();
    // final visitor = visitorProvider.visitor;
    // final query = searchController.text.toLowerCase();

    // final filteredVisitors = visitor.names.where((name) {
    //   return name.toLowerCase().contains(query);
    // }).toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "List of new requests",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 25, 25, 112),
                    ),
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
                  children: fullVisitorLogs.map((log) {
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
                          onTap: () => _onVisitorNameTap(log['name']!),
                          child: Text(
                            log['name']!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 25, 112),
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 25, 25, 112),
                              ),
                              onPressed: () => _onApproveVisitor(log['id']!),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Color.fromARGB(255, 25, 25, 112),
                              ),
                              onPressed: () => _onDeclineVisitor(log['id']!),
                            ),
                          ],
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

// Define the custom clipper class
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
