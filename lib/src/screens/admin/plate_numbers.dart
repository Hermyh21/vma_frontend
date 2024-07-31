import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/plate_region.dart';
import 'package:vma_frontend/src/models/plate_code.dart';
import 'package:vma_frontend/src/services/api_service.dart';

class AllowedPlateNumbersPage extends StatefulWidget {
  const AllowedPlateNumbersPage({Key? key}) : super(key: key);

  @override
  _AllowedPlateNumbersPageState createState() => _AllowedPlateNumbersPageState();
}

class _AllowedPlateNumbersPageState extends State<AllowedPlateNumbersPage> {
  List<PlateRegion> _plateRegions = [];
  List<PlateCode> _plateCodes = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data from the backend
  Future<void> _fetchData() async {
    try {
      final regions = await ApiService.fetchRegions();
      final codes = await ApiService.fetchPlateCodes();
      setState(() {
        _plateRegions = regions;
        _plateCodes = codes;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  // Delete a plate region
  Future<void> _deleteRegion(String id) async {
    try {
      await ApiService.deleteRegion(id);
      setState(() {
        _plateRegions.removeWhere((region) => region.id == id);
      });
    } catch (e) {
      print('Failed to delete region: $e');
    }
  }

  // Delete a plate code
  Future<void> _deleteCode(String id) async {
    try {
      await ApiService.deletePlateCode(id);
      setState(() {
        _plateCodes.removeWhere((code) => code.id == id);
      });
    } catch (e) {
      print('Failed to delete code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plate Numbers',
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
          padding: const EdgeInsets.all(16.0), // Padding for the entire content
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _showAddCodeDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.customColor,
                    ),
                    child: const Text(
                      'Add Code',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _showAddRegionDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.customColor,
                    ),
                    child: const Text(
                      'Add Region',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Below are the allowed plate codes and regions',
                style: TextStyle(color: Color.fromARGB(255, 25, 25, 112)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0), // Padding between containers
                      child: Container(
                        color: Constants.customColor[50], // Set the background color
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Plate Codes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 25, 25, 112),
                                ),
                              ),
                            ),
                            // Ensure the ListView has constraints
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.4, // Adjust height as needed
                              ),
                              child: ListView.builder(
                                itemCount: _plateCodes.length,
                                itemBuilder: (context, index) {
                                  final code = _plateCodes[index];
                                  return ListTile(
                                    title: Text('Code: ${code.code}'),
                                    subtitle: Text('Description: ${code.description}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 25, 25, 112)),
                                      onPressed: () => _deleteCode(code.id),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0), // Padding between containers
                      child: Container(
                        color: Constants.customColor[50], // Set the background color
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Plate Regions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 25, 25, 112),
                                ),
                              ),
                            ),
                            // Ensure the ListView has constraints
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.4, // Adjust height as needed
                              ),
                              child: ListView.builder(
                                itemCount: _plateRegions.length,
                                itemBuilder: (context, index) {
                                  final region = _plateRegions[index];
                                  return ListTile(
                                    title: Text('Region: ${region.region}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 25, 25, 112)),
                                      onPressed: () => _deleteRegion(region.id),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddRegionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddRegionDialog(
          onRegionAdded: (region) {
            setState(() {
              _plateRegions.add(region);
            });
          },
        );
      },
    );
  }

  void _showAddCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddCodeDialog(
          onCodeAdded: (code) {
            setState(() {
              _plateCodes.add(code);
            });
          },
        );
      },
    );
  }
}

class _AddRegionDialog extends StatefulWidget {
  final Function(PlateRegion) onRegionAdded;

  const _AddRegionDialog({required this.onRegionAdded});

  @override
  _AddRegionDialogState createState() => _AddRegionDialogState();
}

class _AddRegionDialogState extends State<_AddRegionDialog> {
  final TextEditingController _regionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Region'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _regionController,
            decoration: const InputDecoration(
              labelText: 'Enter Region',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Example: AA',
            style: TextStyle(color: Colors.grey),
          ),
        ],
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
            final region = _regionController.text;
            try {
              final newRegion = await ApiService.addRegion(region);
              widget.onRegionAdded(newRegion);
              Navigator.of(context).pop();
            } catch (e) {
              print('Failed to add region: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.customColor,
          ),
          child: const Text(
            'Add Region',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _AddCodeDialog extends StatefulWidget {
  final Function(PlateCode) onCodeAdded;

  const _AddCodeDialog({required this.onCodeAdded});

  @override
  _AddCodeDialogState createState() => _AddCodeDialogState();
}

class _AddCodeDialogState extends State<_AddCodeDialog> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Enter Code',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Enter Description',
            ),
          ),
        ],
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
            final code = _codeController.text;
            final description = _descriptionController.text;
            try {
              final newCode = await ApiService.addPlateCode(code, description);
              widget.onCodeAdded(newCode);
              Navigator.of(context).pop();
            } catch (e) {
              print('Failed to add code: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.customColor,
          ),
          child: const Text(
            'Add Code',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
