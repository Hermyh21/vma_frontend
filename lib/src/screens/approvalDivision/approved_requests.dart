import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/providers/visitor_provider.dart';

class ApprovedRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Provider.of or context.watch to access the provider
    final visitorProvider = context
        .watch<VisitorProvider>(); // Use context.watch to listen for changes
    final approvedVisitors =
        visitorProvider.visitors.where((visitor) => visitor.approved).toList();

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
            child: approvedVisitors.isEmpty
                ? const Center(
                    child: Text('No approved requests'),
                  )
                : ListView.builder(
                    itemCount: approvedVisitors.length,
                    itemBuilder: (context, index) {
                      final visitor = approvedVisitors[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(visitor.names.join(', ')),
                        subtitle: Text(
                            "${visitor.startDate.toIso8601String()} - ${visitor.endDate.toIso8601String()}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
