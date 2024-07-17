import 'package:flutter/material.dart';
import 'package:vma_frontend/src/models/user.dart'; 
import 'package:vma_frontend/src/constants/constants.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

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
        title: Text(
          "User: ${user.fname} ${user.lname}",
          style: const TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Constants.customColor, // Use Constants.customColor for app bar background color
        iconTheme: const IconThemeData(color: Colors.white), // Set icon colors to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('First Name', user.fname),
                _buildDetailItem('Last Name', user.lname),
                _buildDetailItem('Department', user.department),
                _buildDetailItem('Phone Number', user.phonenumber),
                _buildDetailItem('Email', user.email),
                _buildDetailItem('Role', user.role),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
