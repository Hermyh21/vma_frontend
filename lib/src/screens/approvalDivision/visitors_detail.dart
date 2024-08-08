import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:dio/dio.dart';

class VisitorDetailScreen extends StatefulWidget {
 final Visitor visitor;

  const VisitorDetailScreen({Key? key, required this.visitor}) : super(key: key);

  @override
  _VisitorDetailScreenState createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
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
            'name': log.names.join(', '),
          };
        }).toList();
        filteredVisitorLogs = visitorLogs;

        fullVisitorLogs = logs.map((log) {
          return {
            'id': log.id.toString(),
            'name': log.names.join(', '),
            'purpose': log.purpose,
            'startDate': log.startDate.toString(),
            'endDate': log.endDate.toString(),
            'bringCar': log.bringCar.toString(),
            'plateNumbers': log.selectedPlateNumbers.join(', '),
            'possessions': log.possessions.join(', '),
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching visitor logs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Visitor Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.customColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailTile(Icons.person, 'Names', widget.visitor.names.join(', ')),
                    _buildDetailTile(Icons.security, 'Purpose', widget.visitor.purpose ?? 'N/A'),
                    _buildDetailTile(Icons.calendar_today, 'Start Date', DateFormat('yyyy-MM-dd').format(widget.visitor.startDate)),
                    _buildDetailTile(Icons.calendar_today, 'End Date', DateFormat('yyyy-MM-dd').format(widget.visitor.endDate)),
                    _buildDetailTile(Icons.directions_car, 'Bring Car', widget.visitor.bringCar ? "Yes" : "No"),
                    if(widget.visitor.bringCar)
                      _buildDetailTile(Icons.confirmation_number, 'Plate Numbers', widget.visitor.selectedPlateNumbers.join(', ')),
                    _buildDetailTile(Icons.inventory, 'Possessions', widget.visitor.possessions.map((possession) => possession.item).join(', ')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onApproveVisitor( widget.visitor.id!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.customColor,
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _onDeclineVisitor( widget.visitor.id!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.customColor,
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve visitor: $error')),
      );
    }
  }
  Future<String?> _showDeclineDialog() async {
  TextEditingController reasonController = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Decline Visitor'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
             const Text('Please enter a reason for declining the visitor:'),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: 'Enter reason',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without doing anything
            },
          ),
          TextButton(
            child: const Text('Decline and Send Reason'),
            onPressed: () {
              Navigator.of(context).pop(reasonController.text); // Close the dialog and return the reason
            },
          ),
        ],
      );
    },
  );
}

  void _onDeclineVisitor(String visitorId) async {
  String? declineReason = await _showDeclineDialog();
  
  if (declineReason != null && declineReason.isNotEmpty) {
    try {
      await ApiService.declineVisitor(visitorId, declineReason);
      setState(() {
        fullVisitorLogs.removeWhere((log) => log['id'] == visitorId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:  Text('Request declined successfully')),
      );
      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decline visitor: $error')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Decline reason is required')),
    );
  }
}
  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Constants.customColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
