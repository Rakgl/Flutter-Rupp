import 'package:flutter/material.dart';

class ProductCart extends StatelessWidget {
  final String type;
  final String name;
  final double price;
  final String image;
  final bool isAdd;

  const ProductCart({
    super.key,
    required this.type,
    required this.name,
    required this.price,
    required this.image,
    required this.isAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: image.startsWith('http')
                      ? Image.network(
                          image,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 120),
                        )
                      : Image.asset(
                          image,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                ),
                if (isAdd)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            type,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$ $price",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              const Icon(
                Icons.favorite_border_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
