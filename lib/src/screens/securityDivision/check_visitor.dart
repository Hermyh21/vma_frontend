import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vma_frontend/src/models/visitors.dart'; // Import the Visitor model

class CheckVisitorScreen extends StatelessWidget {
  final String visitorId;

  CheckVisitorScreen({required this.visitorId});

  Future<Visitor> fetchVisitorDetails() async {
    final response = await http
        .get(Uri.parse('http://localhost:4000/api/visitors/$visitorId'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Visitor.fromJson(json);
    } else {
      throw Exception('Failed to load visitor details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Visitor'),
      ),
      body: FutureBuilder<Visitor>(
        future: fetchVisitorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Visitor not found'));
          } else {
            final visitor = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${visitor.names.join(', ')}',
                      style: TextStyle(fontSize: 18)),
                  Text('Purpose: ${visitor.purpose}',
                      style: TextStyle(fontSize: 18)),
                  Text('Host: ${visitor.selectedHostName}',
                      style: TextStyle(fontSize: 18)),
                  Text('Start Date: ${visitor.startDate}',
                      style: TextStyle(fontSize: 18)),
                  Text('End Date: ${visitor.endDate}',
                      style: TextStyle(fontSize: 18)),
                  Text('Bring Car: ${visitor.bringCar ? 'Yes' : 'No'}',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      'Plate Numbers: ${visitor.selectedPlateNumbers.join(', ')}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Possessions:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...visitor.possessions.map((possession) => Text(
                      '${possession.item}: ${possession.quantity}',
                      style: TextStyle(fontSize: 18))),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
