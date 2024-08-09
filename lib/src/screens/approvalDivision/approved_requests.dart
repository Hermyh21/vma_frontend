import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/services/socket_service.dart';
import 'package:vma_frontend/src/screens/admin/visitor_detail_page.dart';
class ApprovedRequests extends StatefulWidget {
  @override
  _ApprovedRequestsState createState() => _ApprovedRequestsState();
}

class _ApprovedRequestsState extends State<ApprovedRequests> {
  List<Map<String, String?>> visitorLogs = [];
  List<Map<String, String?>> filteredVisitorLogs = [];
  List<Map<String, String?>> fullVisitorLogs = [];
List<Visitor> visitors = [];
  Future<void> _showApprovedVisitors(bool approved) async {
    try {
      final logs = await ApiService.fetchApprovedVisitors(approved);

      setState(() {
        visitorLogs = logs.map((visitor) {
          return {
            'id': visitor.id.toString(),
            'names': visitor.names.join(', '),
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
      print('Error fetching approved visitors: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _showApprovedVisitors(true); 
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('visitorLogsUpdated', (data) {
      setState(() {
        visitors = (data as List).map((json) => Visitor.fromJson(json)).toList();
      });
    });  
  }

  void _onVisitorNameTap(String visitorId) {
    print("Visitor id tapped: $visitorId");
    final visitor = visitors.firstWhere(
      (visitor) => visitor.id == visitorId, 
    );
    
    print("Visitor foundtapped: $visitor");
    try {
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


  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error parsing date: $e');
      return dateString; // Return the original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitorProvider = context.watch<VisitorProvider>(); // Replace with your provider
    print("check this out ${visitorLogs}");
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "List of approved requests",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 25, 25, 112),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: visitorLogs.isEmpty
                ? const Center(
                    child: Text('No approved requests'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    child: ListView.builder(
                      itemCount: fullVisitorLogs.length,
                      itemBuilder: (context, index) {
                        final log = fullVisitorLogs[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Constants.customColor[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () => _onVisitorNameTap(log['id']!),
                            child: ListTile(
                              leading: const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 25, 25, 112),
                              ),
                              title: Text(
                                  log['name']!,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 25, 25, 112),
                                  ),
                                ),
                              subtitle: Text(
                                "${formatDate(log['startDate']!)} - ${formatDate(log['endDate']!)}",
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
    );
  }
}
