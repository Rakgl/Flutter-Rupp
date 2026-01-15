import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    required this.title,
    required this.desc,
    required this.backgroundColor,
    required this.accentColor,
    super.key,
  });

  final String title;
  final String desc;
  final Color backgroundColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: accentColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(fontSize: 13, color: accentColor.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}
