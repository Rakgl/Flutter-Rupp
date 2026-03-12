import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/products/cubit/products_cubit.dart';
import 'package:flutter_methgo_app/features/shared/widgets/product_cart.dart';

class GridCart extends StatefulWidget {
  const GridCart({
    super.key,
    this.isAdd = false,
  });

  final bool isAdd;

  @override
  State<GridCart> createState() => _GridCartState();
}

class _GridCartState extends State<GridCart> {
  @override
  void initState() {
    super.initState();
    // Fetch products if they are empty
    final cubit = context.read<ProductsCubit>();
    if (cubit.state.products.isEmpty && cubit.state.status != ProductStatus.loading) {
      cubit.fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state.status == ProductStatus.loading && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ProductStatus.failure && state.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'Failed to load products'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<ProductsCubit>().fetchProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.products.isEmpty) {
          return const Center(child: Text('No products available.'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = state.products[index];

            return ProductCart(
              isAdd: widget.isAdd,
              type: product.categoryName ?? '',
              name: product.name,
              price: product.price,
              image: product.imageUrl ?? '',
            );
          },
        );
      },
    );
  }
}
