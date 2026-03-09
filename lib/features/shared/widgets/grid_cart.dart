import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/shared/widgets/product_cart.dart';

class GridCart extends StatelessWidget {
  const GridCart({
    super.key,
    this.isAdd = false,
  });

  final bool isAdd;

  static const List<_ProductItem> _products = [
    _ProductItem(
      type: 'Dogs',
      name: 'Pug',
      price: 124.9,
      image: 'assets/images/rakrak.png',
    ),
    _ProductItem(
      type: 'Dogs',
      name: 'Bulldog',
      price: 210.5,
      image: 'assets/images/ferry.png',
    ),
    _ProductItem(
      type: 'Dogs',
      name: 'Shiba',
      price: 300,
      image: 'assets/images/splash_img.png',
    ),
    _ProductItem(
      type: 'Dogs',
      name: 'Husky',
      price: 450,
      image: 'assets/images/rakrak.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = _products[index];

        return ProductCart(
          isAdd: isAdd,
          type: product.type,
          name: product.name,
          price: product.price,
          image: product.image,
        );
      },
    );
  }
}

class _ProductItem {
  const _ProductItem({
    required this.type,
    required this.name,
    required this.price,
    required this.image,
  });

  final String type;
  final String name;
  final double price;
  final String image;
}
