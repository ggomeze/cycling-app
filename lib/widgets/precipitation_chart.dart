import 'dart:math' as math;

import 'package:flutter/material.dart';

class PrecipitationChart extends StatelessWidget {
  const PrecipitationChart({
    super.key,
    required this.times,
    required this.probabilities,
    required this.intensities,
  });

  final List<String> times;
  final List<double> probabilities;
  final List<double> intensities;

  @override
  Widget build(BuildContext context) {
    if (times.isEmpty || probabilities.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Sin datos de precipitación')),
      );
    }

    final labels = times.map((t) => t.split('T').last).toList();
    final maxIntensity = intensities.isEmpty
        ? 1.0
        : math.max(1.0, intensities.reduce(math.max));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Precipitación durante la ruta',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AxisScale(
                title: 'mm/h',
                top: maxIntensity.toStringAsFixed(1),
                middle: (maxIntensity / 2).toStringAsFixed(1),
                bottom: '0.0',
                alignEnd: false,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: CustomPaint(
                    painter: _PrecipitationPainter(
                      probabilities: probabilities,
                      intensities: intensities,
                      maxIntensity: maxIntensity,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const _AxisScale(
                title: '%',
                top: '100',
                middle: '50',
                bottom: '0',
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(labels.first, style: Theme.of(context).textTheme.labelSmall),
              Text(
                labels[labels.length ~/ 2],
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(labels.last, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              _LegendDot(color: Color(0xFF4E9AD7), label: 'Probabilidad (%)'),
              SizedBox(width: 14),
              _LegendDot(
                color: Color(0xFFF5A623),
                label: 'Precipitación (mm/h)',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _AxisScale extends StatelessWidget {
  const _AxisScale({
    required this.title,
    required this.top,
    required this.middle,
    required this.bottom,
    required this.alignEnd,
  });

  final String title;
  final String top;
  final String middle;
  final String bottom;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final textAlign = alignEnd ? TextAlign.right : TextAlign.left;
    final crossAxisAlignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return SizedBox(
      height: 160,
      width: 34,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          Text(
            top,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const Spacer(),
          Text(
            middle,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const Spacer(),
          Text(
            bottom,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _PrecipitationPainter extends CustomPainter {
  _PrecipitationPainter({
    required this.probabilities,
    required this.intensities,
    required this.maxIntensity,
  });

  final List<double> probabilities;
  final List<double> intensities;
  final double maxIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x22000000)
      ..style = PaintingStyle.stroke;
    final areaPaint = Paint()
      ..color = const Color(0x334E9AD7)
      ..style = PaintingStyle.fill;
    final probPaint = Paint()
      ..color = const Color(0xFF4E9AD7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final intensityPaint = Paint()
      ..color = const Color(0xFFF5A623)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const hLines = 4;
    for (var i = 0; i <= hLines; i++) {
      final y = size.height * i / hLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final probPath = _buildLinePath(probabilities, size, maxY: 100);
    final areaPath = Path.from(probPath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final intensityPath = _buildLinePath(intensities, size, maxY: maxIntensity);

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(probPath, probPaint);
    canvas.drawPath(intensityPath, intensityPaint);
  }

  Path _buildLinePath(List<double> values, Size size, {required double maxY}) {
    final path = Path();
    if (values.isEmpty) {
      return path;
    }

    final safeMax = maxY <= 0 ? 1.0 : maxY;
    final last = values.length - 1;
    for (var i = 0; i < values.length; i++) {
      final x = last == 0 ? 0.0 : size.width * i / last;
      final normalized = (values[i].clamp(0, safeMax)) / safeMax;
      final y = size.height - (normalized * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _PrecipitationPainter oldDelegate) {
    return oldDelegate.probabilities != probabilities ||
        oldDelegate.intensities != intensities ||
        oldDelegate.maxIntensity != maxIntensity;
  }
}
