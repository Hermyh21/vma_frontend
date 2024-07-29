import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/plate_region.dart';
import 'package:vma_frontend/src/models/plate_code.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.uri,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ),
  );

  // Fetch Visitor Logs
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
//fetch new requests
 static Future<List<Visitor>> fetchNewRequests(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await _dio.get(
        '/api/newRequests',
        queryParameters: {
          'date': formattedDate,
          'approved': false,
          'declined': false,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load visitor logs');
      }
    } catch (e) {
      throw Exception('Failed to fetch new requests: $e');
    }
  }
  
  // Fetch Approved Visitors
  static Future<List<Visitor>> fetchApprovedVisitors(bool approved) async {
    try {
      final response = await _dio.get(
        '/api/approvedVisitors',
        queryParameters: {
          
          'approved': true,
          'declined': false,
        },
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
    // Fetch Visitors Yet to arrive
  static Future<List<Visitor>> visitorsYetToArrive(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Fetching visitors yet to arrive for date: $formattedDate');
    
      final response = await _dio.get(
        '/api/yetToArrive',
        queryParameters: {
          'date': formattedDate,
          'approved': true,
          'isInside': false,
          'hasLeft': false,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print('Visitors fetched successfully: $data');
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        print('Failed to load visitor logs with status code: ${response.statusCode}');
        throw Exception('Failed to load visitor logs');
      }
    } catch (e) {
      throw Exception('Failed to fetch new requests: $e');
    }
  }
 //fetch visitors inside
 static Future<List<Visitor>> fetchVisitorsInside(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Fetching visitors yet to arrive for date: $formattedDate');
    
      final response = await _dio.get(
        '/api/fetchInside',
        queryParameters: {
          'date': formattedDate,
          'approved': true,
          'isInside': true,
          'hasLeft': false,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print('Visitors to arrive rfetched successfully: $data');
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        print('Failed to load visitor logs with status code: ${response.statusCode}');
        throw Exception('Failed to load visitor logs');
      }
    } catch (e) {
      throw Exception('Failed to fetch visitors who left: $e');
    }
  }
//fetch visitors inside
 static Future<List<Visitor>> fetchVisitorsLeft(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Fetching visitors yet to arrive for date: $formattedDate');
    
      final response = await _dio.get(
        '/api/fetchLeft',
        queryParameters: {
          'date': formattedDate,
          'approved': true,
          'isInside': true,
          'hasLeft': true,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print('Visitors left: $data');
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        print('Failed to load visitor logs with status code: ${response.statusCode}');
        throw Exception('Failed to load visitor logs');
      }
    } catch (e) {
      throw Exception('Failed to visitors left: $e');
    }
  }

  //fetch declined visitors
  static Future<List<Visitor>> fetchDeclinedVisitors(bool declined) async {
    try {
      final response = await _dio.get(
        '/api/declinedVisitors',
        queryParameters: {
          
          'approved': false,
          'declined': true,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load decline visitors');
      }
    } catch (e) {
      throw Exception('Failed to fetch decline visitors: $e');
    }
  }

  // Get Visitor by ID
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
// Approve Visitor
  static Future<void> approveVisitor(String visitorId) async {

  
    try {
      
      final response = await _dio.put('${Constants.uri}/api/approveVisitor/$visitorId');
      
      return response.data;
    } catch (error) {
      print('Error in approveVisitor: $error');
      throw Exception('Failed to approve visitor: $error');
    }
  }
//let visitor inside
  static Future<void> visitorsInside(String visitorId) async {  
    try {      
      final response = await _dio.put('${Constants.uri}/api/visitorsInside/$visitorId');      
      return response.data;
    } catch (error) {
      print('Error in visitors inside: $error');
      throw Exception('Failed to let visitor inside: $error');
    }
  }
  // let visitor leave
  static Future<void> visitorLeft(String visitorId) async {  
    try {      
      final response = await _dio.put('${Constants.uri}/api/visitorLeft/$visitorId');      
      return response.data;
    } catch (error) {
      print('Error in visitors left: $error');
      throw Exception('Failed to let visitor leave: $error');
    }
  }
  // Decline Visitor
 static Future<void> declineVisitor(String visitorId, String declineReason) async {
  try {
    final response = await _dio.put(
      '/api/declineVisitor/$visitorId',
      data: {'declineReason': declineReason},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to decline visitor');
    }
  } catch (e) {
    throw Exception('Failed to decline visitor: $e');
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

  // Add Regions
  static Future<PlateRegion> addRegion(String region) async {
  try {
    print('Sending region: $region'); // Debug log
    final response = await _dio.post(
      '/api/Plate/PlateRegion',
      data: {'region': region},
    );
    return PlateRegion.fromJson(response.data);
  } catch (e) {
    throw Exception('Failed to add region: $e');
  }
}


  static Future<PlateCode> addPlateCode(String code, String description) async {
    try {
      final response = await _dio.post(
        '/api/Plate/PlateCode',
        data: {'code': code, 'description': description},
      );
      return PlateCode.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add plate code: $e');
    }
  }

  // Delete Region
  static Future<void> deleteRegion(String id, String token) async {
    try {
      await _dio.delete(
        '/api/Plate/plate-regions/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (error) {
      throw Exception('Failed to delete region: $error');
    }
  }

  // Delete Plate Code
  static Future<void> deletePlateCode(String id, String token) async {
    try {
      await _dio.delete(
        '/api/Plate/plate-code/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (error) {
      throw Exception('Failed to delete plate code: $error');
    }
  }
  static Future<List<PlateRegion>> fetchRegions() async {
    try {
      final response = await _dio.get('/api/Plate/PlateRegion');
      List<dynamic> data = response.data;
      return data.map((json) => PlateRegion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch regions: $e');
    }
  }

  // Fetch all plate codes
  static Future<List<PlateCode>> fetchPlateCodes() async {
    try {
      final response = await _dio.get('/api/Plate/PlateCode');
      List<dynamic> data = response.data;
      return data.map((json) => PlateCode.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch plate codes: $e');
    }
  }
 
   Future<List<Map<String, dynamic>>> getAllPossessions() async {
    try {
      final response = await _dio.get('/possessions');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print("Error fetching possessions: $e");
      throw e;
    }
  }

  Future<void> createPossession(String name, bool checked) async {
    try {
      final response = await _dio.post('/possessions', data: {
        'name': name,
        'checked': checked,
      });
      return response.data;
    } catch (e) {
      print("Error creating possession: $e");
      throw e;
    }
  }

  Future<void> updatePossession(String id, String name, bool checked) async {
    try {
      final response = await _dio.put('/possessions/$id', data: {
        'name': name,
        'checked': checked,
      });
      return response.data;
    } catch (e) {
      print("Error updating possession: $e");
      throw e;
    }
  }

  Future<void> deletePossession(String id) async {
    try {
      final response = await _dio.delete('/possessions/$id');
      return response.data;
    } catch (e) {
      print("Error deleting possession: $e");
      throw e;
    }
  }
}
