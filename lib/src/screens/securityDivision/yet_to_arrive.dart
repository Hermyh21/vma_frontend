import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/screens/securityDivision/check_visitor.dart';

class YetToArrive extends StatefulWidget {
  final String searchQuery;

  const YetToArrive({Key? key, this.searchQuery = ''}) : super(key: key);

  @override
  _YetToArriveState createState() => _YetToArriveState();
}

class _YetToArriveState extends State<YetToArrive> {
  List<Map<String, String?>> visitorLogs = [];
  List<Map<String, String?>> filteredVisitorLogs = [];
  List<Map<String, String?>> fullVisitorLogs = [];
  List<Visitor> visitors = [];

  Future<void> _showApprovedVisitors(bool approved) async {
    try {
      final logs = await ApiService.fetchApprovedVisitors(approved);

      setState(() {
        visitors = logs;
        visitorLogs = logs.map((visitor) {
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
        filteredVisitorLogs = visitorLogs;
      });

      _filterVisitors(widget.searchQuery);
    } catch (e) {
      print('Error fetching approved visitors: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _showApprovedVisitors(true);
  }

  void _filterVisitors(String query) {
    setState(() {
      filteredVisitorLogs = visitorLogs.where((log) {
        final name = log['names']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void didUpdateWidget(covariant YetToArrive oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterVisitors(widget.searchQuery);
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
          builder: (context) => CheckVisitorScreen(visitor: visitor),
        ),
      );
    } catch (e, stackTrace) {
      print("Error navigating to VisitorDetailPage: $e");
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitorProvider = context.watch<VisitorProvider>();
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
            child: filteredVisitorLogs.isEmpty
                ? const Center(
                    child: Text('No approved requests'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    child: ListView.builder(
                      itemCount: filteredVisitorLogs.length,
                      itemBuilder: (context, index) {
                        final log = filteredVisitorLogs[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Constants.customColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 25, 25, 112),
                            ),
                            title: GestureDetector(
                              onTap: () => _onVisitorNameTap(log['names']!),
                              child: Text(
                                log['names']!,
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
