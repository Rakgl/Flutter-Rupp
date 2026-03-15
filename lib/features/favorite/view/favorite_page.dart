import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:flutter_methgo_app/features/shared/widgets/product_cart.dart';
import 'package:flutter_methgo_app/features/products/view/product_detail_page.dart';
import 'package:flutter_methgo_app/features/pets/view/pet_detail_page.dart';
import 'package:flutter_methgo_app/features/services/view/service_detail_page.dart';
import 'package:repository/repository.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteCubit>().fetchFavorites();
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
          if (state.status == FavoriteStatus.loading && state.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)));
          }
          if (state.status == FavoriteStatus.failure && state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Failed to load favorites'),
                  TextButton(
                    onPressed: () => context.read<FavoriteCubit>().fetchFavorites(),
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
                  Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 20),
                  const Text(
                    'No favorite items yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
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

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final item = state.favorites[index];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.type == 'product') {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => ProductDetailPage(productId: item.itemId!),
                        ));
                      } else if (item.type == 'pet') {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => PetDetailPage(petId: item.itemId!),
                        ));
                      } else if (item.type == 'service') {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => ServiceDetailPage(serviceId: item.itemId!),
                        ));
                      }
                    },
                    child: ProductCart(
                      type: item.type,
                      name: item.name,
                      price: item.price,
                      image: item.imageUrl,
                      isAdd: false,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        context.read<FavoriteCubit>().toggleFavorite(
                              id: item.itemId!,
                              itemType: item.type,
                            );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
