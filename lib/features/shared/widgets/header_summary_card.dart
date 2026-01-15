import 'package:flutter/material.dart';

class HeaderSummaryCard extends StatelessWidget {
  const HeaderSummaryCard({
    required this.title,
    required this.value,
    required this.footerIcon,
    required this.footerText,
    required this.footerColor,
    required this.trailingText,
    super.key,
  });

  final String title;
  final String value;
  final IconData footerIcon;
  final String footerText;
  final Color footerColor;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(footerIcon, color: footerColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    footerText,
                    style: TextStyle(
                      color: footerColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                trailingText,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
