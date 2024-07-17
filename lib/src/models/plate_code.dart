class PlateCode {
  String id;
  String code;
  String description;

  PlateCode({required this.id, required this.code, required this.description});

  factory PlateCode.fromJson(Map<String, dynamic> json) {
    return PlateCode(
      id: json['_id'],
      code: json['code'],
      description: json['description'],
    );
  }
}