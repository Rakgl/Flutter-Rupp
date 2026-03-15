import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pets_cubit.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_methgo_app/features/pets/view/pet_detail_page.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  static const path = '/pets';

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PetsCubit>().fetchPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Meet Our Pets',
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
                        colors: [Color(0xFF10B981), Color(0xFF047857)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: -20,
                    child: Icon(
                      Icons.pets_rounded,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<PetsCubit>().fetchPets(search: value.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search pets (e.g. pug, siamese...)',
                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                context.read<PetsCubit>().fetchPets();
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Grid Content ─────────────────────────────────────────────
          BlocBuilder<PetsCubit, PetsState>(
            builder: (context, state) {
              if (state.status == PetsStatus.loading || state.status == PetsStatus.initial) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
                );
              }
              if (state.status == PetsStatus.failure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(state.errorMessage ?? 'Failed to fetch pets'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<PetsCubit>().fetchPets(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state.pets.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No pets found', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final pet = state.pets[index];
                      return _PremiumPetCard(pet: pet);
                    },
                    childCount: state.pets.length,
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

class _PremiumPetCard extends StatelessWidget {
  const _PremiumPetCard({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(PetDetailPage.path, extra: pet.id);
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
                    child: pet.imageUrl != null &&
                            pet.imageUrl!.startsWith('http')
                        ? Image.network(
                            pet.imageUrl!,
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
                        final isFav = pet.isFavorite ||
                            favoriteState.favorites.any(
                                (f) => f.type == 'pet' && f.itemId == pet.id);
                        return GestureDetector(
                          onTap: () {
                            context.read<FavoriteCubit>().toggleFavorite(
                                  id: pet.id,
                                  itemType: 'pet',
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pet.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pet.category?.name ?? pet.breed ?? pet.species ?? 'Unknown breed',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        if (pet.price != null && pet.price!.isNotEmpty)
                          Text(
                            '\$${pet.price}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
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
        color: const Color(0xFF10B981).withOpacity(0.1),
        child: const Center(
          child: Icon(Icons.pets_rounded, size: 42, color: Color(0xFF10B981)),
        ),
      );
}
