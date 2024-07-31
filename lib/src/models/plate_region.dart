class PlateRegion {
  final String id;
  final String region;

  PlateRegion({required this.id, required this.region});

  factory PlateRegion.fromJson(Map<String, dynamic> json) {
    return PlateRegion(
      id: json['_id'] ?? '', 
      region: json['name'] ?? '', 
    );
  }
}
