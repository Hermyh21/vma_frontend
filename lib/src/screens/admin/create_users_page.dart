import 'package:flutter/material.dart';
import 'package:vma_frontend/src/services/auth_services.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/departments.dart';
import 'package:vma_frontend/src/services/api_service.dart';
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  String? _selectedRole;
  String? _selectedDepartment;
  final AuthService authService = AuthService();
  final List<String> _roles = [
    'Admin',
    'Security',
    'Approval Division',
    'Head of Department'
  ];
 List<Department> _departments = [];
  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }
Future<void> _fetchDepartments() async {
    try {
      final departments = await ApiService.fetchDepartments();
      setState(() {
        _departments = departments;
      });
    } catch (e) {
      print('Failed to fetch departments: $e');
    }
  }
  void _clearFormFields() {
    _emailController.clear();
    _passwordController.clear();
    _fnameController.clear();
    _lnameController.clear();
    _phonenumberController.clear();
    _departmentController.clear();
    setState(() {
      _selectedDepartment = null;
      _selectedRole=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please fill in the following form to add users",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextFormField(
                          controller: _fnameController,
                          labelText: 'First Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            } else if (!RegExp(r'^[a-zA-Z]+$')
                                .hasMatch(value)) {
                              return 'First name should contain only letters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextFormField(
                          controller: _lnameController,
                          labelText: 'Last Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            } else if (!RegExp(r'^[a-zA-Z]+$')
                                .hasMatch(value)) {
                              return 'Last name should contain only letters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          items: _roles.map((String role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextFormField(
                          controller: _phonenumberController,
                          labelText: 'Phone Number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (!RegExp(r'^09\d{8}$').hasMatch(value)) {
                              return 'Please enter a correct phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _selectedDepartment,
                          decoration: InputDecoration(
                            labelText: 'Department',
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          items: _departments.map((Department department) {
                            return DropdownMenuItem(
                              value: department.name,
                              child: Text(department.name),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDepartment = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a department';
                            }
                            return null;
                          },
                        ),
                        // _buildTextFormField(
                        //   controller: _departmentController,
                        //   labelText: 'Department',
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter your department';
                        //     } else if (!RegExp(r'^[a-zA-Z\s]+$')
                        //         .hasMatch(value)) {
                        //       return 'Department should contain only letters and spaces';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        const SizedBox(height: 16.0),
                        _buildTextFormField(
                          controller: _emailController,
                          labelText: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextFormField(
                          controller: _passwordController,
                          labelText: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            } else if (!RegExp(r'(?=.*[0-9])(?=.*[!@#$%^&*])')
                                .hasMatch(value)) {
                              return 'Password must contain at least one number and one special character';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final response = await authService.createUser(
                                    context: context,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    fname: _fnameController.text,
                                    lname: _lnameController.text,
                                    role: _selectedRole!,
                                    phonenumber: _phonenumberController.text,
                                    department: _selectedDepartment!,
                                  );
                                  if (response != null) {
                                    print('Server response data: $response');
                                    // Handle the successful response here
                                  }
                                  _clearFormFields();
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                      Text('Failed to create user: $error'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.customColor,
                            ),
                            child: const Text(
                              'Create User',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Focus(
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                enabledBorder: hasFocus || Focus.of(context).hasPrimaryFocus
                    ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                    Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                )
                    : InputBorder.none,
              ),
              validator: validator,
              obscureText: obscureText,
            );
          },
        ),
      ),
    );
  }
}
