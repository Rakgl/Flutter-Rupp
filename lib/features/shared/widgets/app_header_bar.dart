import 'package:flutter/material.dart';

class AppHeaderBar extends StatelessWidget {
  const AppHeaderBar({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Methgo',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  // color: AppColors.eerieBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            'https://static.wikia.nocookie.net/spiderman-films/images/b/be/Tom_Holland_Spidey_Suit.webp/revision/latest?cb=20230914135801',
          ),
        ),
      ],
    );
  }
}
