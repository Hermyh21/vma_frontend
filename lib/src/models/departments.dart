class Department {
  final String id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromMap(Map<String, dynamic> json) {
    return Department(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
