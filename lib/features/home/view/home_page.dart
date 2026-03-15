import 'package:api_http_client/api_http_client.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_methgo_app/features/products/view/products_page.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/categories/cubit/categories_cubit.dart';
import 'package:flutter_methgo_app/features/categories/view/categories_page.dart';
import 'package:flutter_methgo_app/features/categories/view/category_detail_page.dart';
import 'package:flutter_methgo_app/features/home/home.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pets_cubit.dart';
import 'package:flutter_methgo_app/features/pets/view/pets_page.dart';
import 'package:flutter_methgo_app/features/products/cubit/products_cubit.dart';
import 'package:flutter_methgo_app/features/services/cubit/services_cubit.dart';
import 'package:flutter_methgo_app/features/services/view/services_page.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:flutter_methgo_app/features/products/view/product_detail_page.dart';
import 'package:flutter_methgo_app/features/pets/view/pet_detail_page.dart';
import 'package:flutter_methgo_app/features/services/view/service_detail_page.dart';
import 'package:flutter_methgo_app/features/shared/widgets/app_header_bar.dart';
import 'package:flutter_methgo_app/features/shared/widgets/category_list.dart';
import 'package:flutter_methgo_app/features/shared/widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
    context.read<PetsCubit>().fetchPets();
    context.read<ProductsCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeaderBar(subtitle: 'Welcome back!'),
              const SizedBox(height: 24),
              const SearchButton(),
              const SizedBox(height: 24),

              // ── Category filter chips ─────────────────────────────────
              BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, categoriesState) {
                  final categories =
                      categoriesState.status == CategoriesStatus.success
                          ? categoriesState.categories
                          : const <Category>[];
                  final labels = ['All', ...categories.map((c) => c.name)];
                  return CategoryList(
                    categories: labels,
                    onCategoryTap: (int index) {
                      if (index == 0) {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => const CategoriesPage(),
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => CategoryDetailPage(
                            categoryId: categories[index - 1].id,
                          ),
                        ));
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 28),

              // ══ SERVICES SECTION ══════════════════════════════════════
              _SectionHeader(
                title: 'Services',
                icon: Icons.spa_rounded,
                color: const Color(0xFF7C3AED),
                onSeeAll: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => const ServicesPage()),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<ServicesCubit, ServicesState>(
                builder: (context, state) {
                  if (state.status == ServicesStatus.loading) {
                    return const _HorizontalLoadingShimmer(
                        color: Color(0xFF7C3AED));
                  }
                  if (state.services.isEmpty) {
                    return const _EmptySection(label: 'No services yet');
                  }
                  return SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.services.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final s = state.services[index];
                        return _FadeInItem(
                          index: index,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ServiceDetailPage(serviceId: s.id),
                              ),
                            ),
                            child: _ServiceCard(
                              id: s.id,
                              name: s.name,
                              price: s.price,
                              duration: s.durationMinutes,
                              image: s.imageUrl ?? '',
                              isFavorite: s.isFavorite,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // ══ PETS SECTION ═════════════════════════════════════════
              _SectionHeader(
                title: 'Pets',
                icon: Icons.pets_rounded,
                color: const Color(0xFF10B981),
                onSeeAll: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const PetsPage()),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<PetsCubit, PetsState>(
                builder: (context, state) {
                  if (state.status == PetsStatus.loading) {
                    return const _HorizontalLoadingShimmer(
                        color: Color(0xFF10B981));
                  }
                  if (state.pets.isEmpty) {
                    return const _EmptySection(label: 'No pets available');
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.pets.length > 8 ? 8 : state.pets.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final pet = state.pets[index];
                        return _FadeInItem(
                          index: index,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => PetDetailPage(petId: pet.id),
                              ),
                            ),
                            child: _PetCard(
                              id: pet.id,
                              name: pet.name,
                              image: pet.imageUrl ?? '',
                              breed: pet.breed ?? '',
                              isFavorite: pet.isFavorite,
                              price: pet.price ?? '0',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // ══ PRODUCTS SECTION ─────────────────────────────────────
              _SectionHeader(
                title: 'Products',
                icon: Icons.shopping_bag_rounded,
                color: const Color(0xFF3B82F6),
                onSeeAll: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProductsPage()),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading &&
                      state.products.isEmpty) {
                    return const _HorizontalLoadingShimmer(
                        color: Color(0xFF3B82F6));
                  }
                  if (state.products.isEmpty) {
                    return const _EmptySection(label: 'No products available');
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          state.products.length > 8 ? 8 : state.products.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return _FadeInItem(
                          index: index,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ProductDetailPage(productId: product.id),
                              ),
                            ),
                            child: _ProductCard(
                              id: product.id,
                              name: product.name,
                              price: product.price.toStringAsFixed(2),
                              image: product.imageUrl ?? '',
                              category: product.categoryName ?? '',
                              isFavorite: product.isFavorite,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
    required this.onSeeAll,
  });
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('See all',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const SizedBox(width: 3),
              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: color),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.image,
    required this.isFavorite,
  });
  final String id;
  final String name;
  final String price;
  final int duration;
  final String image;
  final bool isFavorite;

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
            // Background Image
            if (image.startsWith('http'))
              Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder,
              )
            else
              _placeholder,

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8)
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
                      _AnimatedFavIcon(
                        id: id,
                        itemType: 'service',
                        isInitialFav: isFavorite,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
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
                                  '\$$price • ${duration}min',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<CardCubit>()
                                  .addToCart(id, itemType: 'service');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$name added to cart!'),
                                  backgroundColor: const Color(0xFF7C3AED),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.add_shopping_cart_rounded,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
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

// ── Pet Card ───────────────────────────────────────────────────────────────────
class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.id,
    required this.name,
    required this.image,
    required this.breed,
    required this.isFavorite,
    this.price = '0',
  });
  final String id;
  final String name;
  final String image;
  final String breed;
  final bool isFavorite;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
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
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: image.startsWith('http')
                    ? Image.network(image,
                        height: 85, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder)
                    : _placeholder,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _AnimatedFavIcon(
                  id: id,
                  itemType: 'pet',
                  isInitialFav: isFavorite,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                if (breed.isNotEmpty)
                  Text(breed,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$$price',
                        style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<CardCubit>()
                            .addToCart(id, itemType: 'pet');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name added to cart!'),
                            backgroundColor: const Color(0xFF10B981),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_shopping_cart_rounded,
                            size: 16, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
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
          child: Icon(Icons.pets_rounded, size: 36, color: Color(0xFF10B981)),
        ),
      );
}

// ── Product Card ──────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.isFavorite,
  });
  final String id;
  final String name;
  final String price;
  final String image;
  final String category;
  final bool isFavorite;

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
                child: image.startsWith('http')
                    ? Image.network(image,
                        height: 110, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder)
                    : _placeholder,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _AnimatedFavIcon(
                  id: id,
                  itemType: 'product',
                  isInitialFav: isFavorite,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$$price',
                        style: const TextStyle(
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    GestureDetector(
                      onTap: () {
                        context.read<CardCubit>().addToCart(id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name added to cart!'),
                            backgroundColor: const Color(0xFF3B82F6),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_shopping_cart_rounded,
                            size: 16, color: Color(0xFF3B82F6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _placeholder => Container(
        height: 110,
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        child: const Center(
          child: Icon(Icons.shopping_bag_outlined,
              size: 36, color: Color(0xFF3B82F6)),
        ),
      );
}

// ── Loading shimmer ───────────────────────────────────────────────────────────

class _HorizontalLoadingShimmer extends StatelessWidget {
  const _HorizontalLoadingShimmer({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, __) => Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated Favorite Icon ──────────────────────────────────────────────────
class _AnimatedFavIcon extends StatefulWidget {
  const _AnimatedFavIcon({
    required this.id,
    required this.itemType,
    required this.isInitialFav,
  });
  final String id;
  final String itemType;
  final bool isInitialFav;

  @override
  State<_AnimatedFavIcon> createState() => _AnimatedFavIconState();
}

class _AnimatedFavIconState extends State<_AnimatedFavIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, favoriteState) {
        final isFav = widget.isInitialFav ||
            favoriteState.favorites.any(
                (f) => f.type == widget.itemType && f.itemId == widget.id);

        return GestureDetector(
          onTap: () {
            _controller.forward(from: 0);
            context.read<FavoriteCubit>().toggleFavorite(
                  id: widget.id,
                  itemType: widget.itemType,
                );
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

// ── Staggered Fade In Wrapper ───────────────────────────────────────────────
class _FadeInItem extends StatefulWidget {
  const _FadeInItem({required this.child, required this.index});
  final Widget child;
  final int index;

  @override
  State<_FadeInItem> createState() => _FadeInItemState();
}

class _FadeInItemState extends State<_FadeInItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(label,
          style: const TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }
}
