import 'package:flutter/material.dart';

class DeclinedRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "List of declined requests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Color.fromARGB(255, 25, 25, 112),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
