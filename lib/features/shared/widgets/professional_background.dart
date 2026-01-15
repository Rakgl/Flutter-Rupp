import 'package:flutter/material.dart';

class ProfessionalBackground extends StatelessWidget {
  const ProfessionalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          right: -80,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDDE6F5).withValues(alpha: 0.7),
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -150,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE5EBF7).withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
