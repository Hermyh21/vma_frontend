import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/constants/constants.dart';
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
        fullVisitorLogs = logs.map((visitor) {
          return {
            'id': visitor.id.toString(),
            'names': visitor.names.join(', '),
            'purpose': visitor.purpose,
            'startDate': visitor.startDate.toString(),
            'endDate': visitor.endDate.toString(),
            'bringCar': visitor.bringCar.toString(),
            'plateNumbers': visitor.selectedPlateNumbers?.join(', '),
            'possessions': visitor.possessions.map((p) => '${p.item}').join(', '),
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

  void _onVisitorNameTap(String names) {
    // Implement the logic for what happens when a visitor name is tapped
    print('Visitor name tapped: $names');
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
                            color:Constants.customColor,
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
                            subtitle: Text(
                              "${log['startDate']} - ${log['endDate']}",
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
