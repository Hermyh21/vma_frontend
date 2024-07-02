class Analytics {
  final int visitorCount;
  final int userCount;

  Analytics({
    required this.visitorCount,
    required this.userCount,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      visitorCount: json['visitorCount'] ?? 0,
      userCount: json['userCount'] ?? 0,
    );
  }
}
