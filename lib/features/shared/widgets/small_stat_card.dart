import 'package:flutter/material.dart';

class SmallStatCard extends StatelessWidget {
  const SmallStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final parts = value.split('★');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
              children: [
                TextSpan(text: parts[0]),
                if (value.contains('★'))
                  const TextSpan(
                    text: '★',
                    style: TextStyle(color: Colors.orange),
                  ),
                if (parts.length > 1) TextSpan(text: parts[1]),
              ],
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
