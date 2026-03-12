import 'package:flutter/material.dart';

class CategoryCart extends StatelessWidget {
  final String type;
  final String name;
  final String description;
  final String image;

  const CategoryCart({
    super.key,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
  });

  // Pick a consistent accent color per category type
  Color get _accentColor {
    switch (type.toUpperCase()) {
      case 'PET':
        return const Color(0xFF7C3AED); // purple
      case 'PRODUCT':
        return const Color(0xFF3B82F6); // blue
      default:
        return const Color(0xFF0EA5E9); // sky
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ──────────────────────────────────────────
          if (image.isNotEmpty && image.startsWith('http'))
            Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder,
            )
          else
            _placeholder,

          // ── Dark gradient overlay ─────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.55),
                  Colors.black.withOpacity(0.72),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Type chip
                if (type.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                // Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                // Description
                if (description.isNotEmpty)
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _placeholder => ColoredBox(
        color: _accentColor.withOpacity(0.25),
        child: Center(
          child: Icon(Icons.category_rounded, size: 64, color: _accentColor),
        ),
      );
}
