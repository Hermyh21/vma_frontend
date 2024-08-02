import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/models/possessions.dart';
class AllowedPossessionsPage extends StatefulWidget {
  const AllowedPossessionsPage({Key? key}) : super(key: key);

  @override
  _AllowedPossessionsPageState createState() => _AllowedPossessionsPageState();
}

class _AllowedPossessionsPageState extends State<AllowedPossessionsPage> {
  List<Possession> _possessions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data from the backend
  Future<void> _fetchData() async {
    try {
      final possessions = await ApiService.fetchPossessions();
      setState(() {
        _possessions = possessions;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  // Delete a possession
  Future<void> _deletePossession(String id) async {
    try {
      await ApiService.deletePossession(id);
      setState(() {
        _possessions.removeWhere((possession) => possession.id == id);
      });
    } catch (e) {
      print('Failed to delete possession: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Possessions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.customColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: () => _showAddPossessionDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.customColor,
                ),
                child: const Text(
                  'Add Possession',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Below are the allowed possessions',
                style: TextStyle(color: Color.fromARGB(255, 25, 25, 112)),
              ),
              const SizedBox(height: 20),
              Container(
                color: Constants.customColor[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Possessions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 25, 25, 112),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        itemCount: _possessions.length,
                        itemBuilder: (context, index) {
                          final possession = _possessions[index];
                          return ListTile(
                            title: Text('Item: ${possession.item}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 25, 25, 112)),
                              onPressed: () => _deletePossession(possession.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPossessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddPossessionDialog(
          onPossessionAdded: (possession) {
            setState(() {
              _possessions.add(possession);
            });
          },
        );
      },
    );
  }
}

class _AddPossessionDialog extends StatefulWidget {
  final Function(Possession) onPossessionAdded;

  const _AddPossessionDialog({required this.onPossessionAdded});

  @override
  _AddPossessionDialogState createState() => _AddPossessionDialogState();
}

class _AddPossessionDialogState extends State<_AddPossessionDialog> {
  final TextEditingController _itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Possession'),
      content: TextField(
        controller: _itemController,
        decoration: const InputDecoration(
          labelText: 'Enter Possession',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final item = _itemController.text;
            try {
              final newPossession = await ApiService.addPossession(item);
              widget.onPossessionAdded(newPossession);
              Navigator.of(context).pop();
            } catch (e) {
              print('Failed to add possession: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.customColor,
          ),
          child: const Text(
            'Add Possession',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
