import 'package:flutter/material.dart';
import 'package:vma_frontend/src/models/user.dart'; 
import 'package:vma_frontend/src/screens/admin/user_detail_page.dart';
import 'package:vma_frontend/src/services/fetch_users.dart';
import 'package:vma_frontend/src/constants/constants.dart';
class UserCount extends StatefulWidget {
  const UserCount({super.key});

  @override
  _UserCountState createState() => _UserCountState();
}

class _UserCountState extends State<UserCount> {
  late Future<List<User>> _futureUsers;
  
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }
  void _fetchUsers() {
    setState(() {
      _futureUsers = FetchUsers().fetchUsers();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Constants.customColor, // Use Constants.customColor for app bar background color
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // Handle back button press if needed
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      '${user.fname} ${user.lname}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.role),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailPage(user: user),
                        ),
                      );
                      if (result == true) {
                        _fetchUsers(); 
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
