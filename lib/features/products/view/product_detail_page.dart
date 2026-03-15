import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/products/cubit/product_detail_cubit.dart';
import 'package:repository/repository.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:api_http_client/api_http_client.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  static const path = '/product-detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailCubit(
        productRepository: context.read<ProductRepository>(),
      )..fetchProduct(productId),
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavoriteCubit, FavoriteState>(
          listenWhen: (previous, current) =>
              previous.status == FavoriteStatus.loading &&
              current.status == FavoriteStatus.success,
          listener: (context, state) {
            // When favorites are updated, refresh the product to get latest is_favorite status
            final product = context.read<ProductDetailCubit>().state.product;
            if (product != null) {
              context.read<ProductDetailCubit>().fetchProduct(product.id);
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state.status == ProductDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProductDetailStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            }
            final product = state.product;
            if (product == null) {
              return const Center(child: Text('Product not found'));
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  actions: [
                    BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, favoriteState) {
                        // Check if this product is in the global favorites list
                        final isFavoritedInList = favoriteState.favorites.any(
                          (f) => f.type == 'product' && f.itemId == product.id,
                        );

                        // Use either the product's own isFavorite field OR the global list status
                        final isFavorite = product.isFavorite || isFavoritedInList;

                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
                          ),
                          onPressed: () {
                            context.read<FavoriteCubit>().toggleFavorite(
                                  id: product.id,
                                  itemType: 'product',
                                );
                          },
                        );
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 100),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (product.categoryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.categoryName!,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description ?? 'No description available',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
              builder: (context, state) {
                final product = state.product;
                return ElevatedButton(
                  onPressed: () {
                    if (product != null) {
                      context.read<CardCubit>().addToCart(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Cart${product != null ? " (\$${product.price.toStringAsFixed(2)})" : ""}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
