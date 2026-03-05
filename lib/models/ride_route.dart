class RideRoute {
  final String id;
  final double distanceKm;
  final double durationH;
  final int score;
  final double? elevationGainM;
  final List<String> reasons;
  final String geometryPolyline;
  final List<String> forecastTimes;
  final List<double> precipitationMm;
  final List<double> precipitationProbability;

  const RideRoute({
    required this.id,
    required this.distanceKm,
    required this.durationH,
    required this.score,
    this.elevationGainM,
    required this.reasons,
    required this.geometryPolyline,
    this.forecastTimes = const [],
    this.precipitationMm = const [],
    this.precipitationProbability = const [],
  });

  factory RideRoute.fromJson(Map<String, dynamic> json) {
    return RideRoute(
      id: json['id'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      durationH: (json['duration_h'] as num).toDouble(),
      score: json['score'] as int,
      elevationGainM: (json['elevation_gain_m'] as num?)?.toDouble(),
      reasons: List<String>.from(json['reasons'] as List<dynamic>),
      geometryPolyline: json['geometry_polyline'] as String,
      forecastTimes: List<String>.from(
        (json['forecast_times'] as List<dynamic>?) ?? const [],
      ),
      precipitationMm:
          ((json['precipitation_mm'] as List<dynamic>?) ?? const [])
              .map((v) => (v as num).toDouble())
              .toList(),
      precipitationProbability:
          ((json['precipitation_probability'] as List<dynamic>?) ?? const [])
              .map((v) => (v as num).toDouble())
              .toList(),
    );
  }
}
