import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pet_detail_cubit.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pet_detail_state.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:repository/repository.dart';

class PetDetailPage extends StatelessWidget {
  const PetDetailPage({super.key, required this.petId});

  final String petId;

  static const path = '/pet-detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetDetailCubit(
        petRepository: context.read<PetRepository>(),
      )..fetchPet(petId),
      child: const PetDetailView(),
    );
  }
}

class PetDetailView extends StatelessWidget {
  const PetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetDetailCubit, PetDetailState>(
      builder: (context, state) {
        if (state.status == PetDetailStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == PetDetailStatus.failure) {
          return Scaffold(
            body: Center(
              child: Text(state.errorMessage ?? 'Error loading pet details'),
            ),
          );
        }
        final pet = state.pet;
        if (pet == null) {
          return const Scaffold(
            body: Center(child: Text('Pet not found')),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [
                  BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, favoriteState) {
                      final isFavorite = favoriteState.favorites.any((favorite) => favorite.id == pet.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            context.read<FavoriteCubit>().removeFavorite(pet.id);
                          } else {
                            context.read<FavoriteCubit>().addFavorite(pet.id);
                          }
                        },
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: pet.imageUrl != null && pet.imageUrl!.isNotEmpty
                      ? Image.network(
                          pet.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const ColoredBox(
                          color: Color(0xFFE5E7EB),
                          child:
                              Icon(Icons.pets, size: 100, color: Colors.grey),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  transform: Matrix4.translationValues(0, -32, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (pet.price != null && pet.price!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '\$${pet.price}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (pet.category?.name != null || pet.species != null)
                              _buildBadge(
                                  pet.category?.name ?? pet.species!, Colors.blue),
                            const SizedBox(width: 8),
                            if (pet.breed != null && pet.breed!.isNotEmpty)
                              _buildBadge(pet.breed!, Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Specs Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoColumn(
                                'Weight', pet.weight ?? 'N/A', Icons.scale_rounded),
                            _buildInfoColumn(
                                'DOB',
                                pet.dateOfBirth?.split(' ').first ?? 'Unknown',
                                Icons.cake_rounded),
                          ],
                        ),

                        const SizedBox(height: 32),
                        const Text(
                          'Medical Notes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pet.medicalNotes?.isNotEmpty ?? false
                              ? pet.medicalNotes!
                              : 'No medical notes provided for this pet. Everything seems healthy!',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 100), // Extra padding for the bottom button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: BlocConsumer<CardCubit, CardState>(
                listener: (context, cardState) {
                  if (cardState.status == CardStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              cardState.errorMessage ?? 'Failed to add to cart')),
                    );
                  }
                },
                builder: (context, cardState) {
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<CardCubit>()
                          .addToCart(pet.id, itemType: 'pet');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pet added to cart!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF3B82F6), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
