import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:convert/convert.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.uri,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ),
  );

  static Future<List<Visitor>> fetchVisitorLogs(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await _dio.get(
        '/api/getVisitors',
        queryParameters: {'date': formattedDate},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load visitor logs');
      }
    } catch (e) {
      throw Exception('Failed to fetch visitor logs: $e');
    }
  }
static Future<List<Visitor>> fetchApprovedVisitors(bool approved) async {
  try {
    final response = await _dio.get(
      '/api/getapprovedVisitors',
      queryParameters: {'approved': approved.toString()},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((json) => Visitor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load approved visitors');
    }
  } catch (e) {
    throw Exception('Failed to fetch approved visitors: $e');
  }
}

  static Future<Visitor> getVisitorById(String visitorId) async {
    try {
      final response = await _dio.get(
        '/api/getVisitor/$visitorId',
      );

      if (response.statusCode == 200) {
        return Visitor.fromJson(response.data);
      } else {
        throw Exception('Failed to load visitor');
      }
    } catch (e) {
      throw Exception('Failed to load visitor: $e');
    }
  }
  // static Future<Map<String, dynamic>> fetchVisitorData(String visitorId) async {
  //   try {
  //     final response = await _dio.get(
  //       '/api/visitors/$visitorId',
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       throw Exception('Failed to load visitor data');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to fetch visitor data: $e');
  //   }
  // }

  static Future<void> updateVisitorStatus(String id,
      {bool? approved, bool? declined, String? declineReason}) async {
    try {
      final response = await _dio.put(
        '/api/updateVisitorStatus',
        data: {
          'id': id,
          'approved': approved,
          'declined': declined,
          //'declineReason': declineReason,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update visitor status');
      }
    } catch (e) {
      throw Exception('Failed to update visitor status: $e');
    }
  }

  static Future<void> deleteVisitorById(String visitorId) async {
    try {
      final response = await _dio.delete(
        '/api/deleteVisitor/$visitorId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete visitor');
      }
    } catch (e) {
      throw Exception('Failed to delete visitor: $e');
    }
  }
}
