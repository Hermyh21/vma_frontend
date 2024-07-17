import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vma_frontend/src/models/visitors.dart'; // Import the Visitor model

class CheckVisitorScreen extends StatelessWidget {
  final String visitorId;

  CheckVisitorScreen({required this.visitorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Visitor'),
      ),);
      
    
  }
}
