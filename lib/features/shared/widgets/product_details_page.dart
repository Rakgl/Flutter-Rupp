import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              // Navigator.
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ],
      ),
    );
  }
}
