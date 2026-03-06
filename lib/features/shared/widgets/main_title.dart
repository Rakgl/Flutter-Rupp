import 'package:flutter/widgets.dart';

class MainTitle extends StatelessWidget {
  final String title;
  const MainTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A7BD6), // blue color
            fontFamily: 'Cursive', // optional if you add custom font
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFF4A7BD6),
        ),
      ],
    );
  }
}
