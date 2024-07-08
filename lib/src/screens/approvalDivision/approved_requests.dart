import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';

class ApprovedRequests extends StatefulWidget {
  @override
  _ApprovedRequestsState createState() => _ApprovedRequestsState();
}

class _ApprovedRequestsState extends State<ApprovedRequests> {
  List<Map<String, String?>> visitorLogs = [];
  List<Map<String, String?>> filteredVisitorLogs = [];
  List<Map<String, String?>> fullVisitorLogs = [];

  Future<void> _showApprovedVisitors(bool approved) async {
    try {
      final visitors = await ApiService.fetchApprovedVisitors(approved);

      setState(() {
        visitorLogs = visitors.map((visitor) {
          return {
            'id': visitor.id.toString(),
            'name': visitor.names.join(', '),
          };
        }).toList();
        filteredVisitorLogs = visitorLogs;
      });

      setState(() {
        fullVisitorLogs = visitors.map((visitor) {
          return {
            'id': visitor.id.toString(),
            'name': visitor.names.join(', '),
            'purpose': visitor.purpose,
            'hostName': visitor.selectedHostName,
            'startDate': visitor.startDate.toString(),
            'endDate': visitor.endDate.toString(),
            'bringCar': visitor.bringCar.toString(),
            'plateNumbers': visitor.selectedPlateNumbers?.join(', '),
            'possessions': visitor.possessions.map((p) => '${p.item} (${p.quantity})').join(', '),
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
    _showApprovedVisitors(true); // Fetch approved visitors when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    final visitorProvider = context.watch<VisitorProvider>(); // Replace with your provider

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
                : ListView.builder(
                    itemCount: visitorLogs.length,
                    itemBuilder: (context, index) {
                      final visitor = visitorLogs[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(visitor['name'] ?? ''),
                        subtitle: Text(
                          "${fullVisitorLogs[index]['startDate']} - ${fullVisitorLogs[index]['endDate']}",
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
