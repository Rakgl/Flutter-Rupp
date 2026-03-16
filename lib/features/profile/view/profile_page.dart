import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_methgo_app/features/auth/login/view/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pets_cubit.dart';
import 'package:flutter_methgo_app/features/appointments/view/appointments_page.dart';
import 'package:repository/repository.dart';
import 'edit_profile_page.dart';

import 'package:flutter_methgo_app/features/pets/view/add_pet_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String path = '/profile'; // Updated path

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetsCubit(
        petRepository: context.read<PetRepository>(),
      )..fetchPets(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.logoutSuccess) {
            context.go(LoginPage.path);
          } else if (state.status == ProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logout failed. Please try again.')),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: AppColors.scaffoldBackground,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Profile Settings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF254EDB),
                              width: 1.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xFFD6E4FF),
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Edit Profile Button
                      Center(
                        child: OutlinedButton(
                          onPressed: () {
                            context.push(EditProfilePage.path);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF254EDB)),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Color(0xFF254EDB),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Phone Number Section
                      const Text(
                        "Registered phone number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "phone number",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              state.phone,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // My Bookings Section
                      const Text(
                        "Appointments",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          context.push(AppointmentsPage.path);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Color(0xFF254EDB),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "My Bookings",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Personal Information Section
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              icon: Icons.person_outline,
                              label: "Full name",
                              value: state.name,
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow(
                              icon: Icons.location_on_outlined,
                              label: "Delivery address",
                              value: state.location,
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: "Email",
                              value: state.email.isEmpty ? "N/A" : state.email,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // My Pets Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "My Pets",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<PetsCubit>(),
                                    child: const AddPetPage(),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text(
                              "Add Pet",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<PetsCubit, PetsState>(
                        builder: (context, state) {
                          if (state.pets.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  "No pets registered yet.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.pets.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final pet = state.pets[index];
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage:
                                          pet.imageUrl != null &&
                                              pet.imageUrl!.isNotEmpty
                                          ? NetworkImage(pet.imageUrl!)
                                          : null,
                                      child:
                                          pet.imageUrl == null ||
                                              pet.imageUrl!.isEmpty
                                          ? const Icon(
                                              Icons.pets,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pet.name,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // Log out Button
                      Center(
                        child: OutlinedButton(
                          onPressed: state.status == ProfileStatus.loading
                              ? null
                              : () {
                                  context.read<ProfileCubit>().logout();
                                },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD6E4FF)),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.status == ProfileStatus.loading
                                    ? "Logging out..."
                                    : "Log out",
                                style: const TextStyle(
                                  color: Color(0xFF254EDB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (state.status == ProfileStatus.loading)
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF254EDB),
                                    ),
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.logout_rounded,
                                  size: 18,
                                  color: Color(0xFF254EDB),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
