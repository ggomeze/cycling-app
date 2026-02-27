String formatKm(double km) {
  return '${km.toStringAsFixed(2)} km';
}

String formatDuration(double hours) {
  final int totalMinutes = (hours * 60).round();
  final int h = totalMinutes ~/ 60;
  final int m = totalMinutes % 60;
  return '${h}h ${m}m';
}
