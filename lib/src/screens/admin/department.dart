import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/models/departments.dart';

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({Key? key}) : super(key: key);

  @override
  _DepartmentsPageState createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data from the backend
  Future<void> _fetchData() async {
    try {
      final departments = await ApiService.fetchDepartments();
      setState(() {
        _departments = departments;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  // Show delete confirmation dialog
  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Department'),
          content: const Text('Are you sure you want to delete this department?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Constants.customColor),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Delete a department
  Future<void> _deleteDepartment(String id) async {
    // Show confirmation dialog
    final confirm = await _showDeleteConfirmationDialog();
    if (confirm == true) {
      try {
        await ApiService.deleteDepartment(id);
        setState(() {
          _departments.removeWhere((department) => department.id == id);
        });
      } catch (e) {
        print('Failed to delete department: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Departments',
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
                onPressed: () => _showAddDepartmentDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.customColor,
                ),
                child: const Text(
                  'Add Department',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Here's a list of departments",
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
                        'Departments',
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
                        itemCount: _departments.length,
                        itemBuilder: (context, index) {
                          final department = _departments[index];
                          return ListTile(
                            title: Text(department.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 25, 25, 112)),
                              onPressed: () => _deleteDepartment(department.id),
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

  void _showAddDepartmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddDepartmentDialog(
          onDepartmentAdded: (department) {
            setState(() {
              _departments.add(department);
            });
          },
        );
      },
    );
  }
}

class _AddDepartmentDialog extends StatefulWidget {
  final Function(Department) onDepartmentAdded;

  const _AddDepartmentDialog({required this.onDepartmentAdded});

  @override
  _AddDepartmentDialogState createState() => _AddDepartmentDialogState();
}

class _AddDepartmentDialogState extends State<_AddDepartmentDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Department'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Enter Department Name',
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
            final name = _nameController.text;
            if (name.isNotEmpty) {
              final newDepartment = Department(id: '', name: name); // Create a new Department instance
              try {
                final createdDepartment = await ApiService.createDepartment(newDepartment);
                widget.onDepartmentAdded(createdDepartment);
                Navigator.of(context).pop();
              } catch (e) {
                print('Failed to add department: $e');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.customColor,
          ),
          child: const Text(
            'Add Department',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
