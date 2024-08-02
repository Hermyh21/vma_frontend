import 'package:vma_frontend/src/models/possessions.dart';
class Visitor {
  final String? id; 
  final List<String> names;
  final String? purpose;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfVisitors;
  final bool bringCar;
  final List<String> selectedPlateNumbers;  
  final List<Possession> possessions;
  final bool approved;
  final bool declined;
  final String declineReason;
  final bool isInside;
  final bool hasLeft;
  Visitor({
    
    this.id,
    required this.names,
    required this.purpose,
    required this.startDate,
    required this.endDate,
    required this.numberOfVisitors,
    required this.bringCar,
    required this.selectedPlateNumbers,    
    required this.possessions,
    required this.approved,
    required this.declined,
    required this.declineReason,
    required this.isInside,
    required this.hasLeft,
  });

  Object? get name => null;

  // get declineReason => null;

  Visitor copyWith({
    String? id,
    List<String>? names,
    String? purpose,
    DateTime? startDate,
    DateTime? endDate,
    int? numberOfVisitors,
    bool? bringCar,
    List<String>? selectedPlateNumbers,

    List<Possession>? possessions,
    bool? approved,
    bool? declined,
    String? declineReason,
    bool? isInside,
    bool? hasLeft,
  }) {
    return Visitor(
      id: id ?? this.id,
      names: names ?? this.names,
      purpose: purpose ?? this.purpose,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfVisitors: numberOfVisitors ?? this.numberOfVisitors,
      bringCar: bringCar ?? this.bringCar,
      selectedPlateNumbers: selectedPlateNumbers ?? this.selectedPlateNumbers,
      
      possessions: possessions ?? this.possessions,
      approved: approved ?? this.approved,
      declined: declined ?? this.declined,
      declineReason: declineReason ?? this.declineReason,
      isInside: isInside ?? this.isInside,
      hasLeft: hasLeft ?? this.hasLeft,
    );
  }

  factory Visitor.fromJson(Map<String, dynamic> json) {    
    return Visitor(
      id: json['_id'] ?? json['id'] as String?,
      names: List<String>.from(json['name']),
      purpose: json['purpose'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      numberOfVisitors: json['numberOfVisitors'],
      bringCar: json['bringCar'],
      selectedPlateNumbers:
          List<String>.from(json['selectedPlateNumbers'] ?? []),
      
      possessions: (json['possessions'] as List)
          .map((possessionJson) => Possession.fromJson(possessionJson))
          .toList(),
      approved: json['approved'] ?? false,
      declined: json['declined'] ?? false,
      declineReason: json['declineReason'],
      isInside: json['isInside'] ?? false,
      hasLeft: json['hasLeft'] ?? false,
    );
  }
factory Visitor.fromJson22(Map<String, dynamic> json) {
    String nameString = json['name'] as String;
    List<String> nameList =
        nameString.replaceAll("[", "").replaceAll("]", "").split(", ");

    return Visitor(
      id: json['_id'] ?? json['id'] as String?,
      names: nameList,
      purpose: json['purpose'],
      startDate: DateTime.parse(json['startDate']).toLocal(),
      endDate: DateTime.parse(json['endDate']).toLocal(),
      numberOfVisitors: nameList.length,
      bringCar: json['bringCar'] != null ? true : false,
      selectedPlateNumbers: [],
      possessions: [],
      approved: json['approved'] ?? false,
      declined: json['declined'] ?? false,
      declineReason: "reason here", // Handle null value
      isInside: json['isInside'] ?? false,
      hasLeft: json['hasLeft'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'name': names,
      'purpose': purpose,
      'startDate': DateTime(startDate.year, startDate.month, startDate.day).toIso8601String(),
    'endDate': DateTime(endDate.year, endDate.month, endDate.day).toIso8601String(),
      'numberOfVisitors': numberOfVisitors,
      'bringCar': bringCar,
      'selectedPlateNumbers': selectedPlateNumbers,
      
      'possessions':
          possessions.map((possession) => possession.toJson()).toList(),
      'approved': approved,
      'declined': declined,
      //'declineReason': declineReason,
    };
    if (id != null) {
      data['_id'] = id as Object; // Cast id to Object
    }
    return data;
  }
}

// class Possession {
//   final String id;
//   final String item;

//   Possession({required this.id, required this.item});

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'item': item,
//       };

//   factory Possession.fromJson(Map<String, dynamic> json) {
//     return Possession(
//       id: json['id'] as String,
//       item: json['item'] as String,
//     );
//   }
// }



// Visitor visitorFromJson(Map<String, dynamic> json) {
//   // Include the id field if present in the JSON
//   return Visitor.fromJson(json)..id = json['_id'];
// }

// Map<String, dynamic> visitorToJson(Visitor visitor) {
//   // Exclude the id field when converting to JSON
//   final Map<String, dynamic> data = visitor.toJson();
//   data.remove('_id');
//   return data;
// }
