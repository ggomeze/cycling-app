import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';

class RouteMapView extends StatelessWidget {
  const RouteMapView({
    super.key,
    required this.geometryPolyline,
    this.height = 120,
    this.borderRadius = 16,
  });

  final String geometryPolyline;
  final double height;
  final double borderRadius;

  List<LatLng> _decodePolyline(String polyline) {
    final points = PolylinePoints().decodePolyline(polyline);
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final routePoints = _decodePolyline(geometryPolyline);

    if (routePoints.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE7E9EE),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: const Text('Sin preview de mapa'),
      );
    }

    final bounds = LatLngBounds.fromPoints(routePoints);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
            initialCameraFit: CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(20),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.cycling_app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 4,
                  color: const Color(0xFF2F80C8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
