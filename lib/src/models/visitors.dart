class Visitor {
  final Object? id; // id can be of type Object to accommodate different types
  final List<String> names;
  final String? purpose;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfVisitors;
  final bool bringCar;
  final List<String> selectedPlateNumbers;
  final String? selectedHostName;
  final List<Possession> possessions;
  final bool approved;
  final bool declined;
  //final String declineReason;
  Visitor({
    this.id,
    required this.names,
    required this.purpose,
    required this.startDate,
    required this.endDate,
    required this.numberOfVisitors,
    required this.bringCar,
    required this.selectedPlateNumbers,
    required this.selectedHostName,
    required this.possessions,
    required this.approved,
    required this.declined,
    //required this.declineReason,
  });

  Visitor copyWith({
    Object? id,
    List<String>? names,
    String? purpose,
    DateTime? startDate,
    DateTime? endDate,
    int? numberOfVisitors,
    bool? bringCar,
    List<String>? selectedPlateNumbers,
    String? selectedHostName,
    List<Possession>? possessions,
    bool? approved,
    bool? declined,
    //String? declineReason,
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
      selectedHostName: selectedHostName ?? this.selectedHostName,
      possessions: possessions ?? this.possessions,
      approved: approved ?? this.approved,
      declined: declined ?? this.declined,
      //declineReason: declineReason ?? this.declineReason,
    );
  }

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['_id'] as String?,
      names: List<String>.from(json['name']),
      purpose: json['purpose'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      numberOfVisitors: json['numberOfVisitors'],
      bringCar: json['bringCar'],
      selectedPlateNumbers:
          List<String>.from(json['selectedPlateNumbers'] ?? []),
      selectedHostName: json['selectedHostName'],
      possessions: (json['possessions'] as List)
          .map((possessionJson) => Possession.fromJson(possessionJson))
          .toList(),
      approved: json['approved'] ?? false,
      declined: json['declined'] ?? false,
      //declineReason: json['declineReason'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': names,
      'purpose': purpose,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfVisitors': numberOfVisitors,
      'bringCar': bringCar,
      'selectedPlateNumbers': selectedPlateNumbers,
      'selectedHostName': selectedHostName,
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

class Possession {
  final String item;
  final int quantity;

  Possession({required this.item, required this.quantity});

  Map<String, dynamic> toJson() => {
        'item': item,
        'quantity': quantity,
      };

  factory Possession.fromJson(Map<String, dynamic> json) {
    return Possession(
      item: json['item'],
      quantity: json['quantity'],
    );
  }
}



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
