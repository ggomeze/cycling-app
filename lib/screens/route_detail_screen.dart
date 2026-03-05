import 'package:flutter/material.dart';

import '../models/ride_route.dart';
import '../utils/formatters.dart';
import '../widgets/precipitation_chart.dart';
import '../widgets/route_map_view.dart';
import '../widgets/score_badge.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.route});

  final RideRoute route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de ruta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5A1F), Color(0xFFFF7A2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatKm(route.distanceKm)} · ${formatDuration(route.durationH)}${route.elevationGainM != null ? ' · +${route.elevationGainM!.toStringAsFixed(0)} m' : ''}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Salida optimizada por meteo y complejidad',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                    ],
                  ),
                ),
                ScoreBadge(score: route.score),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RouteMapView(
            geometryPolyline: route.geometryPolyline,
            height: 260,
            borderRadius: 18,
          ),
          const SizedBox(height: 16),
          PrecipitationChart(
            times: route.forecastTimes,
            probabilities: route.precipitationProbability,
            intensities: route.precipitationMm,
          ),
          const SizedBox(height: 16),
          Text(
            'Motivos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (route.reasons.isEmpty)
            Text('Sin motivos destacados.', style: theme.textTheme.bodyMedium)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: route.reasons
                  .map((reason) => Chip(label: Text(reason)))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
