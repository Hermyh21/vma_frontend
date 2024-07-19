import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/visitors.dart';

class AlreadyLeft extends StatelessWidget {
  const AlreadyLeft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitorProvider = Provider.of<VisitorProvider>(context);
    final visitorsLeft = visitorProvider.visitorsLeft;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Left'),
        backgroundColor: Constants.customColor,
      ),
      body: ListView.builder(
        itemCount: visitorsLeft.length,
        itemBuilder: (context, index) {
          final visitor = visitorsLeft[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(visitor.names.join(', ')),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Purpose: ${visitor.purpose ?? 'N/A'}'),
                  Text('Start Date: ${visitor.startDate}'),
                  Text('End Date: ${visitor.endDate}'),
                  Text('Number of Visitors: ${visitor.numberOfVisitors}'),
                  Text('Bring Car: ${visitor.bringCar ? "Yes" : "No"}'),
                  Text('Plate Numbers: ${visitor.selectedPlateNumbers.join(', ')}'),
                  Text('Possessions: ${visitor.possessions.map((possession) => possession.item).join(', ')}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
