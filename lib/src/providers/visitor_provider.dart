import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/constants/constants.dart';

class VisitorProvider extends ChangeNotifier {
  List<Visitor> _visitors = [];
  Visitor? _selectedVisitor;

  List<Visitor> get visitors => _visitors;
  Visitor? get selectedVisitor => _selectedVisitor;

  void setVisitors(List<Map<String, dynamic>> jsonList) {
    _visitors = jsonList.map((json) => Visitor.fromJson(json)).toList();
    notifyListeners();
  }

  void setVisitorFromModel(Visitor visitor) {
    _selectedVisitor = visitor;
    notifyListeners();
  }

  Future<void> fetchVisitors() async {
    try {
      final dio = Dio();
      final response = await dio.get('${Constants.uri}/visitors');
      final List<dynamic> visitorData = response.data;

      _visitors = visitorData.map((data) => Visitor.fromJson(data)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching visitors: $e');
    }
  }

  List<Visitor> get visitorsInside => _visitors.where((visitor) => visitor.isInside).toList();
List<Visitor> get visitorsLeft => _visitors.where((visitor) => visitor.hasLeft).toList();
  void approveVisitor(String visitorId) {
    final index = _visitors.indexWhere((visitor) => visitor.id == visitorId);
    if (index != -1) {
      _visitors[index] = _visitors[index].copyWith(approved: true);
      notifyListeners();
    }
  }

  void removeVisitor(String visitorId) {
    _visitors.removeWhere((visitor) => visitor.id == visitorId);
    notifyListeners();
  }

  void declineVisitor(String visitorId) {
    final index = _visitors.indexWhere((visitor) => visitor.id == visitorId);
    if (index != -1) {
      _visitors[index] = _visitors[index].copyWith(declined: true);
      notifyListeners();
    }
  }
}
