import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  final String title;
  final int count;

  AnalyticsCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
