import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/screens/approvalDivision/new_requests.dart';
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
                    _buildDetailTile(Icons.calendar_today, 'Start Date', DateFormat('yyyy-MM-dd HH:mm').format(widget.visitor.startDate)),
                    _buildDetailTile(Icons.calendar_today, 'End Date', DateFormat('yyyy-MM-dd HH:mm').format(widget.visitor.endDate)),
                    _buildDetailTile(Icons.directions_car, 'Bring Car', widget.visitor.bringCar ? "Yes" : "No"),
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
    final visitorProvider = context.read<VisitorProvider>();
    Visitor? visitor;

    try {
      visitor = visitorProvider.visitors.firstWhere((v) => v.id == visitorId);
    } catch (e) {
      visitor = null;
    }

    if (visitor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor not found locally')),
      );
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.put(
        '${Constants.uri}/approve/$visitorId',
      );

      if (response.statusCode == 200) {
        visitorProvider.setVisitorFromModel(visitor.copyWith(
          approved: true,
          declined: false,
          declineReason: '',
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor approved')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve visitor: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error')),
      );
      print('Network error: $e');
    }
  }

  void _onDeclineVisitor( String visitorId) {
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
                    final dio = Dio();
                    final response = await dio.put(
                      '${Constants.uri}/$visitorId',
                      data: {
                        'declineReason': declineReason,
                      },
                    );

                    if (response.statusCode == 200) {
                      visitorProvider.setVisitorFromModel(visitor!.copyWith(
                        declined: true,
                        declineReason: declineReason,
                      ));

                      visitorProvider.declineVisitor(visitorId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visitor declined')),
                      );

                      Navigator.of(dialogContext).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to decline visitor')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Network error')),
                    );
                  }
                } else {
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
