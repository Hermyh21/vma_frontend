class Region {
  String id;
  String name;
  String code;

  Region({required this.id, required this.name, required this.code});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['_id'],
      name: json['name'],
      code: json['code'],
    );
  }
}