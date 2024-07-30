import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/services/api_service.dart';

class LeftVisitorDetail extends StatefulWidget {
  final Visitor visitor;

  const LeftVisitorDetail({Key? key, required this.visitor}) : super(key: key);

  @override
  _LeftVisitorDetailState createState() => _LeftVisitorDetailState();
}

class _LeftVisitorDetailState extends State<LeftVisitorDetail> {
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
                    if (widget.visitor.bringCar)
                      _buildDetailTile(Icons.confirmation_number, 'Plate Numbers', widget.visitor.selectedPlateNumbers.join(', ')),
                    _buildDetailTile(Icons.inventory, 'Possessions', widget.visitor.possessions.map((possession) => '${possession.item}: ').join(', ')),
                  ],
                ),
              ),
            ),
           
          ],
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

  
}
