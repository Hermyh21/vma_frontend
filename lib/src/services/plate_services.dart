import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchPlateRegions() async {
  final response =
      await http.get(Uri.parse('http://localhost:4000/api/plate-regions'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => item['name'].toString()).toList();
  } else {
    throw Exception('Failed to load plate regions');
  }
}

Future<List<String>> fetchPlateCodes() async {
  final response =
      await http.get(Uri.parse('http://localhost:4000/api/plate-codes'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => item['code'].toString()).toList();
  } else {
    throw Exception('Failed to load plate codes');
  }
}
