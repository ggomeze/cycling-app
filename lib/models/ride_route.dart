class RideRoute {
  final String id;
  final double distanceKm;
  final double durationH;
  final int score;
  final List<String> reasons;
  final String geometryPolyline;

  const RideRoute({
    required this.id,
    required this.distanceKm,
    required this.durationH,
    required this.score,
    required this.reasons,
    required this.geometryPolyline,
  });

  factory RideRoute.fromJson(Map<String, dynamic> json) {
    return RideRoute(
      id: json['id'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      durationH: (json['duration_h'] as num).toDouble(),
      score: json['score'] as int,
      reasons: List<String>.from(json['reasons'] as List<dynamic>),
      geometryPolyline: json['geometry_polyline'] as String,
    );
  }
}
