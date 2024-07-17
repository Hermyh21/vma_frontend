import 'package:flutter/material.dart';
import 'package:vma_frontend/src/services/possessions_service.dart';
import 'package:vma_frontend/src/constants/constants.dart';
class AllowedPossessionsPage extends StatefulWidget {
  @override
  _AllowedPossessionsPageState createState() => _AllowedPossessionsPageState();
}

class _AllowedPossessionsPageState extends State<AllowedPossessionsPage> {
  final TextEditingController _possessionController = TextEditingController();
  final PossessionsService _service = PossessionsService();
  List<Map<String, dynamic>> possessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPossessions();
  }

  Future<void> _fetchPossessions() async {
    try {
      final data = await _service.getAllPossessions();
      setState(() {
        possessions = data.map((item) => Map<String, dynamic>.from(item)).toList();
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addPossession() async {
    if (_possessionController.text.isNotEmpty) {
      try {
        await _service.createPossession(_possessionController.text, false);
        _possessionController.clear();
        _fetchPossessions();
      } catch (e) {
        print("not successful");
        print(e);
      }
    }
  }

  Future<void> _updatePossession(int index, String newValue) async {
    try {
      await _service.updatePossession(possessions[index]['_id'], newValue, possessions[index]['checked']);
      _fetchPossessions();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _deletePossession(int index) async {
    try {
      await _service.deletePossession(possessions[index]['_id']);
      _fetchPossessions();
    } catch (e) {
      // Handle error
    }
  }

  void _showUpdateDialog(int index) {
    TextEditingController _updateController = TextEditingController();
    _updateController.text = possessions[index]['name'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Possession'),
          content: TextField(
            controller: _updateController,
            decoration: const InputDecoration(hintText: 'Enter new value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updatePossession(index, _updateController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Allowed Possessions',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _possessionController,
              decoration: InputDecoration(
                labelText: 'Add Possession',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addPossession,
                ),
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: possessions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(possessions[index]['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showUpdateDialog(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deletePossession(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

