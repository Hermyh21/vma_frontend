import 'package:flutter/material.dart';
import 'package:vma_frontend/src/services/auth_services.dart';
import 'package:vma_frontend/src/utils/utils.dart' as utils; // Add a prefix
import 'admin/admin_dashboard.dart';
import '../constants/constants.dart';
import 'package:vma_frontend/src/screens/depHead/dep_head_home.dart';
import 'package:vma_frontend/src/screens/approvalDivision/approval_div_screen.dart';
import 'package:vma_frontend/src/screens/securityDivision/security_screen.dart';

class SignInApp extends StatelessWidget {
  const SignInApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignInScreen(),
        '/admin': (context) => AdminDashboard(),
        '/approvaldivision': (context) => ApprovalDivision(),
        '/security': (context) => SecurityScreen(),
        '/departmenthead': (context) => DepartmentHeadsPage(),
      },
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Image.asset('assets/logo.png', width: 400, height: 100),
            ),
          ),
          const Text(
            'Welcome to Secure Gate',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Please enter your email and password to login',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SignInForm(),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        final emailTextController = TextEditingController();
                        final authService = AuthService();

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Forgot Password?'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Enter your email to reset your password.',
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: emailTextController,
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                  ),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  final email = emailTextController.text;
                                  if (email.isNotEmpty) {
                                    authService.forgotPassword(
                                      context: context,
                                      email: email,
                                    );
                                  } else {
                                    utils.showSnackBar(context,
                                        'Please enter your email'); // Use prefix
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Constants.customColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final AuthService authService = AuthService();
  double _formProgress = 0;
  String? _loginError;
  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [emailTextController, passwordTextController];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  Future<void> loginUser() async {
    if (_formProgress == 1) {
      // Ensure form is fully completed.
      try {
        authService.signinUser(
          context: context,
          email: emailTextController.text,
          password: passwordTextController.text,
        );
        setState(() {
          _loginError = null; // Clear error if login is successful
        });
      } catch (e) {
        setState(() {
          _loginError = 'Incorrect email or password';
        });
      }
    }
  }

  void forgotPassword() {
    // Ensure form is fully completed.
    authService.forgotPassword(
      context: context,
      email: emailTextController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _formProgress,
            valueColor: AlwaysStoppedAnimation<Color>(Constants.customColor),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: emailTextController,
              decoration: const InputDecoration(
                hintText: 'email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: passwordTextController,
              decoration: const InputDecoration(
                hintText: 'password',
              ),
              obscureText: true,
            ),
          ),
          if (_loginError != null) // Display error message if login fails
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _loginError!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor:
                    _formProgress == 1 ? Constants.customColor : Colors.grey,
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Utility function to show SnackBar
// void showSnackBar(BuildContext context, String message) {
//   final snackBar = SnackBar(content: Text(message));
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
