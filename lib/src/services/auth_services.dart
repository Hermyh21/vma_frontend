import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vma_frontend/src/models/user.dart';
import 'package:vma_frontend/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:vma_frontend/src/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vma_frontend/src/screens/admin/admin_dashboard.dart';
import 'package:vma_frontend/src/screens/depHead/dep_head_home.dart';
import 'package:vma_frontend/src/screens/approvalDivision/approval_div_screen.dart';
import 'package:vma_frontend/src/screens/securityDivision/security_screen.dart';
import 'package:vma_frontend/src/default_screen.dart';
import 'package:vma_frontend/src/screens/login.dart';

class AuthService {
  Future<Map<String, dynamic>?> createUser({
    required BuildContext context,
    required String email,
    required String password,
    required String fname,
    required String lname,
    required String role,
    required String phonenumber,
    required String department,
  }) async {
    try {
      User user = User(
        id: '',
        fname: fname,
        lname: lname,
        department: department,
        phonenumber: phonenumber,
        email: email,
        password: password,
        token: '',
        role: role,
      );

      Dio dio = Dio();
      print("user ${user.toJson()}");

      Response response = await dio.post(
        '${Constants.uri}/api/createUser',
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // Debug print the response data
      print("Server response data: ${response.data}");

      // Assuming the response data is a JSON object
      if (response.data is Map<String, dynamic>) {
        handleDioResponse(
          context: context,
          response: response,
          onSuccess: () {
            showSnackBar(context, "User Created successfully!");
          },
        );
        return response.data;
      } else {
        throw Exception('Expected a JSON object as response data');
      }
    } catch (e) {
      if (e is DioError) {
        handleDioError(context, e);
      } else {
        showSnackBar(context, 'Unexpected Error: $e');
        print('Unexpected Error: $e');
      }
    }
    return null;
  }

  void signinUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      Dio dio = Dio();
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      Response response = await dio.post(
        '${Constants.uri}/api/signin',
        data: {'email': email, 'password': password},
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      handleDioResponse(
        context: context,
        response: response,
        onSuccess: () async {
          print("user signing response.data ${response.data}");
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final token = data['token'];
            final userId = data['_id'];
            final userRole = data['role'].toLowerCase();

            print("extracted user data: token=$token, userId=$userId, userRole=$userRole");
// Update user provider with fetched user details
          userProvider.setUser(data);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', data['token']);
            await prefs.setString('user', json.encode(data));

            // Conditional navigation based on roles
            switch (userRole) {
              case 'admin':
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                        (route) => false);
                break;
              case 'head of department':
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => DepartmentHeadsPage()),
                        (route) => false);
                break;
              case 'approval division':
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ApprovalDivision()),
                        (route) => false);
                break;
              case 'security':
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SecurityScreen()),
                        (route) => false);
                break;
              default:
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const DefaultScreen()),
                        (route) => false);
                break;
            }
          } else {
            throw Exception('Expected a JSON object as response data');
          }
        },
      );
    } catch (e) {
      if (e is DioError) {
        handleDioError(context, e);
      } else {
        showSnackBar(context, 'Unexpected Error: $e');
        print('Unexpected Error: $e');
      }
    }
  }

  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
        // Redirect to login if token is not found
        Navigator.of(context).pushReplacementNamed('/');
        return;
      }
      Dio dio = Dio();

      // POST request without user data
      Response postResponse = await dio.post(
        '${Constants.uri}/',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        ),
      );

      // Decode response from POST request
      var postResponseBody = jsonDecode(postResponse.data);

      // Check the response from POST request
      if (postResponseBody == true) {
        // GET user details
        Response getResponse = await dio.get(
          '${Constants.uri}/user',
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            },
          ),
        );

        var userDetails = jsonDecode(getResponse.data);
        // Redirect based on user role
        switch (userDetails['role'].toLowerCase()) {
          case 'admin':
            Navigator.of(context).pushReplacementNamed('/admin');
            break;
          case 'head of department':
            Navigator.of(context).pushReplacementNamed('/head of department');
            break;
          case 'approval division':
            Navigator.of(context).pushReplacementNamed('/approval division');
            break;
          case 'security':
            Navigator.of(context).pushReplacementNamed('/security');
            break;
          default:
            Navigator.of(context).pushReplacementNamed('/');
            break;
        }
      } else {
        // Redirect to login if response is not true
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      print('Error: $e');
      // Redirect to login page on error
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void signout(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SignInApp(),
        ),
            (route) => false);
  }
  void logout(BuildContext context) async {
  try {
    Dio dio = Dio();
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Retrieve the token from SharedPreferences
    String? token = prefs.getString('token');
print('Token: $token');
    if (token == null) {
      showSnackBar(context, 'No token found, authorization denied');
      return;
    }

    // Optional: Make a request to the backend logout endpoint
    Response response = await dio.post(
      '${Constants.uri}/logout',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,  // Include the token in the header
        },
      ),
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Clear the token and user data from SharedPreferences
      await prefs.remove('token');
      await prefs.remove('user');

      // Clear the user data from UserProvider if needed
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(null);  // Update UserProvider with null

      // Navigate to the login screen
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SignInApp(),
        ),
        (route) => false,
      );
    } else {
      showSnackBar(context, 'Logout failed: ${response.statusMessage}');
    }
  } catch (e) {
    if (e is DioError) {
      handleDioError(context, e);
    } else {
      showSnackBar(context, 'Unexpected Error: $e');
      print('Unexpected Error: $e');
    }
  }
}

  void handleDioError(BuildContext context, DioError e) {
    String errorMessage;

    switch (e.type) {
      case DioErrorType.cancel:
        errorMessage = "Request to server was cancelled.";
        break;
      case DioErrorType.connectTimeout:
        errorMessage = "Connection timeout with server.";
        break;
      case DioErrorType.sendTimeout:
        errorMessage = "Send timeout in connection with server.";
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = "Receive timeout in connection with server.";
        break;
      case DioErrorType.response:
        if (e.response != null && e.response?.data != null) {
          errorMessage =
              "Error: ${e.response?.statusCode} - ${e.response?.data['message'] ?? e.response?.statusMessage}";
          print('Response data: ${e.response?.data}');
        } else {
          errorMessage =
              "Received invalid status code: ${e.response?.statusCode}";
        }
        break;
      case DioErrorType.other:
        errorMessage =
            "Connection to server failed due to internet connection.";
        break;
      default:
        errorMessage = "Unexpected error occurred.";
        break;
    }

    showSnackBar(context, errorMessage);
    print('Dio Error: $errorMessage');
  }
  

  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        '${Constants.uri}/forgot-password',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleDioResponse(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(context, "Password reset email sent!");
        },
      );
    } catch (e) {
      if (e is DioError) {
        handleDioError(context, e);
      } else {
        showSnackBar(context, 'Unexpected Error: $e');
        print('Unexpected Error: $e');
      }
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String token,
    required String newPassword,
  }) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        '${Constants.uri}/reset-password',
        data: {'token': token, 'newPassword': newPassword},
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleDioResponse(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(context, "Password has been reset!");
          Navigator.of(context).pushReplacementNamed('/login');
        },
      );
    } catch (e) {
      if (e is DioError) {
        handleDioError(context, e);
      } else {
        showSnackBar(context, 'Unexpected Error: $e');
        print('Unexpected Error: $e');
      }
    }
  }

  void handleDioResponse({
    required BuildContext context,
    required Response response,
    required Function onSuccess,
  }) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      onSuccess();
    } else {
      showSnackBar(context, response.data.toString());
      print('Response Error: ${response.data.toString()}');
    }
  }
}
