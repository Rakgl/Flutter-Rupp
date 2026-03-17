import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:flutter_methgo_app/features/products/view/product_detail_page.dart';
import 'package:flutter_methgo_app/features/pets/view/pet_detail_page.dart';
import 'package:flutter_methgo_app/features/services/view/service_detail_page.dart';
import 'package:api_http_client/api_http_client.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<FavoriteCubit>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Favorites',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.status == FavoriteStatus.loading &&
              state.favorites.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            );
          }
          if (state.status == FavoriteStatus.failure &&
              state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Failed to load favorites'),
                  TextButton(
                    onPressed: () =>
                        context.read<FavoriteCubit>().fetchFavorites(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 80,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No favorite items yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Items you favorite will appear here',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          final services =
              state.favorites.where((f) => f.type == 'service').toList();
          final pets =
              state.favorites.where((f) => f.type == 'pet').toList();
          final products =
              state.favorites.where((f) => f.type == 'product').toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              if (services.isNotEmpty) ...[
                _SectionHeader(
                  icon: Icons.spa_rounded,
                  title: 'Services',
                  color: const Color(0xFF7C3AED),
                  count: services.length,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = services[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ServiceDetailPage(serviceId: item.itemId!),
                          ),
                        ),
                        child: _FavServiceCard(item: item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (pets.isNotEmpty) ...[
                _SectionHeader(
                  icon: Icons.pets_rounded,
                  title: 'Marketplace',
                  color: const Color(0xFF10B981),
                  count: pets.length,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = pets[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                PetDetailPage(petId: item.itemId!),
                          ),
                        ),
                        child: _FavPetCard(item: item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (products.isNotEmpty) ...[
                _SectionHeader(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Accessories',
                  color: const Color(0xFF3B82F6),
                  count: products.length,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ProductDetailPage(productId: item.itemId!),
                          ),
                        ),
                        child: _FavProductCard(item: item),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ── Section Header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    required this.count,
  });

  final IconData icon;
  final String title;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Favorite Icon ───────────────────────────────────────────────────────────

class _FavIcon extends StatelessWidget {
  const _FavIcon({required this.item});

  final FavoriteItemModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FavoriteCubit>().toggleFavorite(
              id: item.itemId!,
              itemType: item.type,
            );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.favorite, color: Colors.red, size: 18),
      ),
    );
  }
}

// ── Service Card (matches home page style) ──────────────────────────────────

class _FavServiceCard extends StatelessWidget {
  const _FavServiceCard({required this.item});

  final FavoriteItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (item.imageUrl.startsWith('http'))
              CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _placeholder,
              )
            else
              _placeholder,

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.spa_rounded,
                            color: Colors.white, size: 18),
                      ),
                      _FavIcon(item: item),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _placeholder => const ColoredBox(
        color: Color(0xFF7C3AED),
        child: Center(
          child: Icon(Icons.spa_rounded, size: 36, color: Colors.white30),
        ),
      );
}

// ── Pet / Marketplace Card (matches home page style) ────────────────────────

class _FavPetCard extends StatelessWidget {
  const _FavPetCard({required this.item});

  final FavoriteItemModel item;

  String get _breed =>
      item.details['breed']?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: item.imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _placeholder,
                      )
                    : _placeholder,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _FavIcon(item: item),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                if (_breed.isNotEmpty)
                  Text(
                    _breed,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _placeholder => Container(
        height: 100,
        color: const Color(0xFF10B981).withOpacity(0.15),
        child: const Center(
          child:
              Icon(Icons.pets_rounded, size: 36, color: Color(0xFF10B981)),
        ),
      );
}

// ── Product / Accessory Card (matches home page style) ──────────────────────

class _FavProductCard extends StatelessWidget {
  const _FavProductCard({required this.item});

  final FavoriteItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: item.imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _placeholder,
                      )
                    : _placeholder,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _FavIcon(item: item),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _placeholder => Container(
        height: 120,
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        child: const Center(
          child: Icon(Icons.shopping_bag_outlined,
              size: 36, color: Color(0xFF3B82F6)),
        ),
      );
}
