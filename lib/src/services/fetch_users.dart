import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vma_frontend/src/models/user.dart'; 
import 'package:vma_frontend/src/constants/constants.dart'; 

class FetchUsers {
  final Dio _dio = Dio();

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get('${Constants.uri}/api/users');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
