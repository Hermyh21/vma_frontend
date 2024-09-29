import 'package:flutter/material.dart';
import 'package:vma_frontend/src/models/user.dart'; 
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/services/fetch_users.dart';
class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

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
        title: Text(
          "User: ${user.fname} ${user.lname}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.customColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8,),
                    _buildDetailItem(Icons.person, 'Name', '${user.fname} ${user.lname}'),            
                    const SizedBox(height: 8,),
                    _buildDetailItem(Icons.business, 'Department', user.department),
                    const SizedBox(height: 8,),
                    _buildDetailItem(Icons.phone, 'Phone Number', user.phonenumber),
                    const SizedBox(height: 8,),
                    _buildDetailItem(Icons.email, 'Email', user.email),
                    const SizedBox(height: 8,),
                    _buildDetailItem(Icons.work, 'Role', user.role),
                    const SizedBox(height: 8,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showDeleteConfirmationDialog(context),
              icon: const Icon(Icons.delete),
              label: const Text('Delete User', style: TextStyle(color: Color.fromARGB(255, 25, 25, 112), ),),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Constants.customColor),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context) async {
    try {
      await FetchUsers().deleteUser(user.id); 
      Navigator.of(context).pop(); 
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      Navigator.of(context).pop(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }
}
