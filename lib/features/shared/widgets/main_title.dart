import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  final String title;
  final bool isBack;
  const MainTitle({super.key, required this.title, required this.isBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A7BD6),
                fontFamily: 'Cursive',
              ),
            ),
            if (isBack)
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  size: 28,
                ),
              ),
          ],
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
