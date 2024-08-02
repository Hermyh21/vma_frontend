import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/models/plate_region.dart';
import 'package:vma_frontend/src/models/plate_code.dart';
import 'package:vma_frontend/src/models/possessions.dart';
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
//fetch visitors who left
 static Future<List<Visitor>> fetchVisitorsLeft(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Fetching visitors yet to arrive for date: $formattedDate');
    
      final response = await _dio.get(
        '/api/fetchLeft',
        queryParameters: {
          'date': formattedDate,
          'approved': true,
          'isInside': false,
          'hasLeft': true,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print('Visitors left: $data');
        return data.map((json) => Visitor.fromJson(json)).toList();
      } else {
        print('Failed to load visitors who left: ${response.statusCode}');
        throw Exception('Failed to load visitor logs');
      }
    } catch (e) {
      throw Exception('Failed to fetch visitors who left: $e');
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

  // Add Region
  static Future<PlateRegion> addRegion(String region) async {
    try {
      print('Sending region: $region'); // Debug log
      final response = await _dio.post(
        '/api/Plate/PlateRegion',
        data: {'region': region},
      );
      print('Received response: ${response.data}'); // Debug log
      if (response.data == null) {
        throw Exception('API response is null');
      }
      print('Response JSON: ${response.data}'); // Debug log
      return PlateRegion.fromJson(response.data);
    } catch (e) {
      print('Exception: $e'); // Debug log
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
static Future<void> deleteRegion(String id) async {
  try {
    print('Attempting to delete region with id: $id'); // Debug log
    final response = await _dio.delete('/api/Plate/plate-regions/$id');
    print('Delete region response status code: ${response.statusCode}'); // Debug log
    if (response.statusCode == 204) {
      print('Region deleted successfully.');
    } else {
      print('Failed to delete region. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Failed to delete region: $error'); // Debug log
    throw Exception('Failed to delete region: $error');
  }
}


 // Delete Plate Code
static Future<void> deletePlateCode(String id) async {
  try {
    print('Attempting to delete plate code with id: $id'); // Debug log
    final response = await _dio.delete('/api/Plate/plate-code/$id');
    print('Delete plate code response status code: ${response.statusCode}'); // Debug log
    if (response.statusCode == 204) {
      print('Plate code deleted successfully.');
    } else {
      print('Failed to delete plate code. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Failed to delete plate code: $error'); // Debug log
    throw Exception('Failed to delete plate code: $error');
  }
}

// Fetch all plate regions
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
 
   // Fetch possessions from the backend
  static Future<List<Possession>> fetchPossessions() async {
  try {
    print('Fetching possessions from the backend...');
    final response = await _dio.get('/possessions');
    
    print('Response status code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      print('Data received: $data');
      return data.map((possessionJson) => Possession.fromJson(possessionJson)).toList();
    } else {
      throw Exception('Failed to load possessions');
    }
  } catch (e) {
    print('Error fetching possessions: $e');
    throw Exception('Failed to load possessions: $e');
  }
}


  // Add a new possession to the backend
  static Future<Possession> addPossession(String item) async {
  try {
    print('Adding possession with item: $item');
    final response = await _dio.post('/possessions', data: {'item': item});
    
    print('Response status code for possession: ${response.statusCode}');
    
    if (response.statusCode == 201) {
      print('Possession added successfully: ${response.data}');
      return Possession.fromJson(response.data);
    } else {
      throw Exception('Failed to add possession');
    }
  } catch (e) {
    print('Error adding possession: $e');
    throw Exception('Failed to add possession: $e');
  }
}


  // Delete a possession from the backend
  static Future<void> deletePossession(String id) async {
  try {
    print('Deleting possession with id: $id');
    final response = await _dio.delete('/possessions/$id');
    
    print('Response status code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('Possession deleted successfully');
    } else {
      throw Exception('Failed to delete possession');
    }
  } catch (e) {
    print('Error deleting possession: $e');
    throw Exception('Failed to delete possession: $e');
  }
}

}