import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/services/socket_service.dart';
import 'package:vma_frontend/src/screens/securityDivision/check_visitor.dart';
class YetToArrive extends StatefulWidget {
  final String searchQuery;

  const YetToArrive({super.key, required this.searchQuery});

  @override
  _YetToArriveState createState() => _YetToArriveState();
}

class _YetToArriveState extends State<YetToArrive> {
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 120.0 * 7,
  );
  List<Visitor> visitors = [];
  late DateTime _selectedDate;
  final now = DateTime.now();
  late List<DateTime> days;
  List<Map<String, String>> visitorLogs = [];
  List<Map<String, String?>> fullVisitorLogs = [];
  List<Map<String, String?>> filteredVisitorLogs = [];

  Future<void> _showVisitorLogs(DateTime day) async {
  try {
    final logs = await ApiService.visitorsYetToArrive(day);

    setState(() {
      visitorLogs = logs.map((log) {
        return {
          'id': log.id.toString(),
          'name': log.names.join(', '),
        };
      }).toList();

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
          'isInside': log.isInside.toString(),
          'hasLeft': log.hasLeft.toString(),
        };
      }).toList();

      _filterVisitors();
    });
  } catch (e) {
    print('Error fetching visitor logs: $e');
  }
}

  void _filterVisitors() {
    final query = widget.searchQuery.toLowerCase();
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('visitorLogsUpdated', (data) {
      setState(() {
        visitors = (data as List).map((json) => Visitor.fromJson(json)).toList();
      });
    });
  }

  @override
  void didUpdateWidget(YetToArrive oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterVisitors();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onVisitorNameTap(String visitorId) async {
    print("Visitor name tapped: $visitorId");
    final visitor = visitors.firstWhere(
      (visitor) => visitor.id == visitorId, 
    );
    try {
     final bool? result= await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckVisitorScreen(visitor: visitor),
        ),
      );
       if (result == true) {
        _showVisitorLogs(_selectedDate); 
      }
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
                      "List of visitors yet to arrive",
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
                            onTap: () => _onVisitorNameTap(log['id']!),
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
      ),
    );
  }
}
