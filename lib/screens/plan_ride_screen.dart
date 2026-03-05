import 'package:flutter/material.dart';

import '../models/ride_route.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';
import '../widgets/route_map_view.dart';
import '../widgets/score_badge.dart';
import 'route_detail_screen.dart';

class PlanRideScreen extends StatefulWidget {
  const PlanRideScreen({super.key});

  @override
  State<PlanRideScreen> createState() => _PlanRideScreenState();
}

class _PlanRideScreenState extends State<PlanRideScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _loading = false;
  List<RideRoute> _routes = [];

  Future<void> _planRoutes() async {
    setState(() => _loading = true);

    try {
      final routes = await _apiService.plan(_controller.text);
      if (!mounted) {
        return;
      }
      setState(() => _routes = routes);
    } catch (e, st) {
      debugPrint('PLAN ERROR: $e');
      debugPrint('$st');
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente de Pina')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(18),
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.directions_bike_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Planifica por tiempo real',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Texto libre + meteorología + rutas sugeridas',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        minLines: 2,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Describe tu salida',
                          hintText:
                              'Ej: Salida desde Altea a las 15:30 para hacer 2h...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5A1F),
                          ),
                          onPressed: _loading ? null : _planRoutes,
                          child: const Text('Generar rutas'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_routes.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Text(
                    'Escribe tu ruta ideal y genera opciones.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final route = _routes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RouteDetailScreen(route: route),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${formatKm(route.distanceKm)} · ${formatDuration(route.durationH)}${route.elevationGainM != null ? ' · +${route.elevationGainM!.toStringAsFixed(0)} m' : ''}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ScoreBadge(score: route.score),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RouteMapView(
                              geometryPolyline: route.geometryPolyline,
                              height: 110,
                              borderRadius: 14,
                            ),
                            const SizedBox(height: 10),
                            if (route.reasons.isEmpty)
                              Text(
                                'Sin motivos destacados',
                                style: theme.textTheme.bodySmall,
                              )
                            else
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: route.reasons
                                    .map(
                                      (reason) => Chip(
                                        visualDensity: VisualDensity.compact,
                                        label: Text(reason),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: _routes.length),
              ),
            ),
        ],
      ),
    );
  }
}
