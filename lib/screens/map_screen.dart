import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';

import '../models/ride_route.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.route});

  final RideRoute route;

  List<LatLng> _decodePolyline(String polyline) {
    final points = PolylinePoints().decodePolyline(polyline);
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<LatLng> routePoints = _decodePolyline(route.geometryPolyline);

    if (routePoints.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: const Center(child: Text('No se pudo cargar la ruta.')),
      );
    }

    final bounds = LatLngBounds.fromPoints(routePoints);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(32),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.cycling_app',
          ),
          PolylineLayer(
            polylines: [
              Polyline(points: routePoints, strokeWidth: 4, color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}
