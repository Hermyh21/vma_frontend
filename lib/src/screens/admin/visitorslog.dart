import 'package:flutter/material.dart';
import 'package:vma_frontend/src/screens/approvalDivision/request.dart';
import 'package:vma_frontend/src/models/visitors.dart';

class VisitorLogsScreen extends StatefulWidget {
  @override
  _VisitorLogsScreenState createState() => _VisitorLogsScreenState();
}

class _VisitorLogsScreenState extends State<VisitorLogsScreen> {
  List<VisitorLogEntry> visitorLogs = []; // List to store visitor log entries

  @override
  void initState() {
    super.initState();
    // Call the method to send visitor log data and then fetch and display logs
    sendAndFetchVisitorLogs();
  }

  Future<void> sendAndFetchVisitorLogs() async {
    // Call the method to send visitor log data to the server
    Requests.sendData(
      startDate: DateTime.now(), // Example: Provide the required data
      endDate: DateTime.now(), // Example: Provide the required data
      numberOfVisitors: 5, // Example: Provide the required data
      visitorNames: ['John', 'Jane'], // Example: Provide the required data
      bringCar: true, // Example: Provide the required data
      selectedPlateNumbers: [
        'ABC123',
        'XYZ789'
      ], // Example: Provide the required data
      selectedHostName: 'Host1', // Example: Provide the required data
      possessionCheckedState: [
        true,
        false
      ], // Example: Provide the required data
      possessionQuantities: [1, 0], // Example: Provide the required data
    );

    // After sending data, fetch visitor logs from the server (not implemented here)
    // Replace this with actual code to fetch visitor logs from the server
    // Example:
    // List<VisitorLogEntry> logs = await fetchVisitorLogsFromServer();
    List<VisitorLogEntry> logs = [
      VisitorLogEntry(
        visitorName: 'John',
        purpose: 'Business Meeting',
        hostName: 'Host1',
      ),
      VisitorLogEntry(
        visitorName: 'Jane',
        purpose: 'Interview',
        hostName: 'Host2',
      ),
    ];

    // Update the state with the fetched visitor logs data
    setState(() {
      visitorLogs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: visitorLogs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Visitor ${index + 1}'),
            subtitle: Text('Purpose: ${visitorLogs[index].purpose}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Host: ${visitorLogs[index].hostName}'),
                // Additional information can be displayed here if available
              ],
            ),
          );
        },
      ),
    );
  }
}

// Model class to represent a visitor log entry
class VisitorLogEntry {
  final String visitorName;
  final String purpose;
  final String hostName;

  VisitorLogEntry({
    required this.visitorName,
    required this.purpose,
    required this.hostName,
  });
}
