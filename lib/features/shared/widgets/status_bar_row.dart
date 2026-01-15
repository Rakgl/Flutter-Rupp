import 'package:flutter/material.dart';

class StatusBarRow extends StatelessWidget {
  const StatusBarRow({
    required this.label,
    required this.percent,
    required this.count,
    this.color = Colors.amber,
    super.key,
  });

  final String label;
  final double percent;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70, // Increased to accommodate longer labels like "Completed"
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: const Color(0xFFF1F5F9),
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 30, // Increased for larger numbers
            child: Text(
              count,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
