import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/services/socket_service.dart';
import 'package:vma_frontend/src/screens/approvalDivision/visitors_detail.dart';

class NewRequestsScreen extends StatefulWidget {
  @override
  _NewRequestsScreenState createState() => _NewRequestsScreenState();
}

class _NewRequestsScreenState extends State<NewRequestsScreen> {
  final TextEditingController searchController = TextEditingController();
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

  Future<void> _showVisitorLogs(DateTime day) async {
    try {
      final logs = await ApiService.fetchNewRequests(day);

      setState(() {
        visitorLogs = logs.map((log) {
          return {
            'id': log.id.toString(),
            'name': log.names.join(', '),
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
    _selectedDate = now;
    days = List.generate(15, (index) => now.subtract(Duration(days: 7 - index)));
    _showVisitorLogs(_selectedDate);
    searchController.addListener(_filterVisitors);
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('visitorLogsUpdated', (data) {
      setState(() {
        visitors = (data as List).map((json) => Visitor.fromJson(json)).toList();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onApproveVisitor(String visitorId) async {
    try {
      await ApiService.approveVisitor(visitorId);
      setState(() {
        fullVisitorLogs.removeWhere((log) => log['id'] == visitorId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor approved successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve visitor: $error')),
      );
    }
  }

  void _onDeclineVisitor(String visitorId) async {
    try {
      await ApiService.declineVisitor(visitorId);
      setState(() {
        fullVisitorLogs.removeWhere((log) => log['id'] == visitorId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor declined successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decline visitor: $error')),
      );
    }
  }

  void _onVisitorNameTap(String visitorName) {
    print("Visitor name tapped: $visitorName");
    final visitor = visitors.firstWhere(
      (visitor) => visitor.names.contains(visitorName),
    );
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitorDetailScreen(visitor: visitor),
        ),
      );
    } catch (e, stackTrace) {
      print("Error navigating to VisitorDetailPage: $e");
      print(stackTrace);
    }
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
   

    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
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
      ),
    );
  }
}
