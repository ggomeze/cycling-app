import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  const ScoreBadge({super.key, required this.score});

  final int score;

  Color _scoreColor() {
    if (score >= 85) {
      return const Color(0xFF2AA84A);
    }
    if (score >= 70) {
      return const Color(0xFFF5A623);
    }
    return const Color(0xFFE24B4B);
  }

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor();
    final normalized = (score.clamp(0, 100)) / 100.0;
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                '$score',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: normalized,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
