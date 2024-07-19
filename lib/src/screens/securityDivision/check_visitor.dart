import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';

class CheckVisitorScreen extends StatelessWidget {
  final Visitor visitor;

  const CheckVisitorScreen({Key? key, required this.visitor}) : super(key: key);

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
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailTile(Icons.person, 'Names', visitor.names.join(', ')),
                _buildDetailTile(Icons.security, 'Purpose', visitor.purpose ?? 'N/A'),
                _buildDetailTile(Icons.calendar_today, 'Start Date', DateFormat('yyyy-MM-dd HH:mm').format(visitor.startDate)),
                _buildDetailTile(Icons.calendar_today, 'End Date', DateFormat('yyyy-MM-dd HH:mm').format(visitor.endDate)),
                _buildDetailTile(Icons.directions_car, 'Bring Car', visitor.bringCar ? "Yes" : "No"),
                _buildDetailTile(Icons.confirmation_number, 'Plate Numbers', visitor.selectedPlateNumbers.join(', ')),
                _buildDetailTile(Icons.inventory, 'Possessions', visitor.possessions.map((possession) => '${possession.item}: ').join(', ')),
                _buildDetailTile(Icons.check, 'Approved', visitor.approved ? "Yes" : "No"),
                if (visitor.declined)
                  _buildDetailTile(Icons.close, 'Decline Reason', visitor.declineReason ?? 'N/A'),
                const SizedBox(height: 16),
                _buildLetInsideButton(context),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildLetInsideButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final updatedVisitor = visitor.copyWith(isInside: true);

          
          final visitorProvider = context.read<VisitorProvider>();
          visitorProvider.setVisitorFromModel(updatedVisitor);

          // Send the update to the backend
          final success = await _updateVisitorStatus(updatedVisitor);

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Visitor has been let inside')),
            );
            // Optionally, close the screen
            Navigator.of(context).pop();
          } else {
            // Revert the local update if backend update fails
            visitorProvider.setVisitorFromModel(visitor);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update visitor status on the server')),
            );
          }
        },
        child: const Text('Has been let inside'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.customColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<bool> _updateVisitorStatus(Visitor updatedVisitor) async {
    try {
      final dio = Dio();
      final response = await dio.put(
        '${Constants.uri}/visitor/${updatedVisitor.id}',
        data: updatedVisitor.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      // Handle error
      print('Error updating visitor status: $e');
      return false;
    }
  }
}
