import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';

class VisitorDetailPage extends StatelessWidget {
  final Visitor visitor;

  const VisitorDetailPage({Key? key, required this.visitor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white, // Set icon color to white
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Visitor Details',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Constants.customColor, // Use Constants.customColor for app bar background color
        iconTheme: const IconThemeData(color: Colors.white), // Set icon colors to white
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
                _buildDetailTile(Icons.calendar_today, 'Start Date', DateFormat('yyyy-MM-dd').format(visitor.startDate)),
                _buildDetailTile(Icons.calendar_today, 'End Date', DateFormat('yyyy-MM-dd').format(visitor.endDate)),
                _buildDetailTile(Icons.directions_car, 'Bring Car', visitor.bringCar ? "Yes" : "No"),
                if(visitor.bringCar)
                _buildDetailTile(Icons.confirmation_number, 'Plate Numbers', visitor.selectedPlateNumbers.join(', ')),
                _buildDetailTile(Icons.inventory, 'Possessions', visitor.possessions.map((possession) => '${possession.item}: ').join(', ')),
                _buildDetailTile(Icons.check, 'Approved', visitor.approved ? "Yes" : "No"),
                if (visitor.declined)
                  _buildDetailTile(Icons.close, 'Decline Reason', visitor.declineReason ?? 'N/A'),
                _buildDetailTile(Icons.pending, 'Is inside', visitor.isInside ? "Yes" : "No"),
                _buildDetailTile(Icons.nordic_walking_rounded, 'Has Left', visitor.hasLeft ? "Yes" : "No"),
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
          Icon(icon, color: Constants.customColor), // Use Constants.customColor for icons
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
