import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import DateFormat for date formatting
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/analytics.dart';

import 'package:vma_frontend/src/screens/admin/analytics_card.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Analytics analytics;
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    analytics =
        Analytics(visitorCount: 0, userCount: 0); // Initialize analytics here
    fetchData();
    currentDate = DateTime.now();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.uri}/api/analytics'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          analytics = Analytics.fromJson(jsonData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              DateFormat.yMMMMd().format(currentDate), // Format date as desired
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 25, 112),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnalyticsCard(
                  title: 'Visitor Count Today',
                  count: analytics.visitorCount,
                ),
                AnalyticsCard(
                  title: 'User Count',
                  count: analytics.userCount,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    // View Detailed Analytics Functionality
                  },
                  child: const Text('View Detailed Analytics'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Analytics {
  final int visitorCount;
  final int userCount;

  Analytics({
    required this.visitorCount,
    required this.userCount,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      visitorCount: json['visitorCount'] ?? 0,
      userCount: json['userCount'] ?? 0,
    );
  }
}
