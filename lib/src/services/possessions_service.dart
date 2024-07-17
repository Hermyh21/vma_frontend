import 'package:dio/dio.dart';
import 'package:vma_frontend/src/constants/constants.dart'; 

class PossessionsService {
  final Dio _dio = Dio();

  Future<List<dynamic>> getAllPossessions() async {
    try {
      final response = await _dio.get('${Constants.uri}/possessions');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load possessions');
    }
  }

  Future<void> createPossession(String name, bool checked) async {
  try {
    await _dio.post('${Constants.uri}/possessions', data: {'name': name, 'checked': checked});
  } catch (e) {
    if (e is DioError) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
    } else {
      print('Error: $e');
    }
    throw Exception('Failed to create possession');
  }
}


  Future<void> updatePossession(String id, String name, bool checked) async {
    try {
      await _dio.put('${Constants.uri}/possessions/$id', data: {'name': name, 'checked': checked});
    } catch (e) {
      throw Exception('Failed to update possession');
    }
  }

  Future<void> deletePossession(String id) async {
    try {
      await _dio.delete('${Constants.uri}/possessions/$id');
    } catch (e) {
      throw Exception('Failed to delete possession');
    }
  }
}
