import 'package:api_http_client/api_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/products/cubit/products_cubit.dart';
import 'package:flutter_methgo_app/features/products/view/product_detail_page.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:go_router/go_router.dart';



class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  static const path = '/products';

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: CustomScrollView(
        slivers: [
          // ── Premium Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Shop Products',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: -20,
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      size: 140,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black45],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Spacer for top ───────────────────────────────────────────
          const SliverPadding(padding: EdgeInsets.only(top: 16)),

          // ── Grid Content ─────────────────────────────────────────────
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state.status == ProductStatus.loading || state.status == ProductStatus.initial) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
                );
              }
              if (state.status == ProductStatus.failure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(state.errorMessage ?? 'Failed to fetch products'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<ProductsCubit>().fetchProducts(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No products found', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = state.products[index];
                      return _PremiumProductCard(product: product);
                    },
                    childCount: state.products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PremiumProductCard extends StatelessWidget {
  const _PremiumProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(ProductDetailPage.path, extra: product.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    child: product.imageUrl != null &&
                            product.imageUrl!.startsWith('http')
                        ? Image.network(
                            product.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder,
                          )
                        : _placeholder,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, favoriteState) {
                        final isFav = product.isFavorite ||
                            favoriteState.favorites.any((f) =>
                                f.type == 'product' && f.itemId == product.id);
                        return GestureDetector(
                          onTap: () {
                            context.read<FavoriteCubit>().toggleFavorite(
                                  id: product.id,
                                  itemType: 'product',
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Text Area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.categoryName ?? 'Product',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                    GestureDetector(
                      onTap: () {
                        context.read<CardCubit>().addToCart(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            backgroundColor: const Color(0xFF3B82F6),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 18,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _placeholder => Container(
        width: double.infinity,
        color: const Color(0xFF3B82F6).withOpacity(0.08),
        child: const Center(
          child: Icon(Icons.shopping_bag_outlined, size: 42, color: Color(0xFF3B82F6)),
        ),
      );
}
