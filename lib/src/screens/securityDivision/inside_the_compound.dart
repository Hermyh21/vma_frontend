import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';

import 'package:vma_frontend/src/constants/constants.dart';
import 'package:intl/intl.dart';
class InsideTheCompound extends StatelessWidget {
  const InsideTheCompound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitorProvider = context.watch<VisitorProvider>();
    final visitorsInside = visitorProvider.visitorsInside;

    return Scaffold(
      
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: visitorsInside.length,
        itemBuilder: (context, index) {
          final visitor = visitorsInside[index];
          return Card(
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
                  _buildDetailTile(Icons.inventory, 'Possessions', visitor.possessions.map((possession) => possession.item).join(', ')),
                  _buildDetailTile(Icons.check, 'Approved', visitor.approved ? "Yes" : "No"),
                  if (visitor.declined)
                    _buildDetailTile(Icons.close, 'Decline Reason', visitor.declineReason ?? 'N/A'),
                ],
              ),
            ),
          );
        },
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
}
