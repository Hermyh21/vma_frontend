import 'package:flutter/material.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Access Undefined',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unauthorized Access: Your user role has not been recognized or is pending approval.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perhaps add a logout or contact admin feature
                Navigator.of(context)
                    .pop(); // Go back to the login screen or home page
              },
              child: Text('Return to Home'),
            )
          ],
        ),
      ),
    );
  }
}
