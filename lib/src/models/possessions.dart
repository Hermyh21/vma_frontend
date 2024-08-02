class Possession {
  final String id;
  final String item;

  Possession({required this.id, required this.item});

  factory Possession.fromJson(Map<String, dynamic> json) {
    return Possession(
      id: json['_id'] as String,
      item: json['item'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'item': item,
    };
  }
}
