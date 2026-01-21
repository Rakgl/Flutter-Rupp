import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_super_aslan_app/navigation/view/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class BusinessInfoPage extends StatelessWidget {
  const BusinessInfoPage({super.key});

  static const String path = '/business-info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(
            IconlyLight.arrowLeft,
            color: AppColors.black,
            size: 20,
          ),
          label: const Text("Back", style: TextStyle(color: AppColors.black)),
        ),
        title: Text(
          "Business Information",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.edit, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            return;
          }
          context.read<NavigationCubit>().setTab(index);
          context.go(MainView.path);
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                child: Image.network(
                  'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=2071&auto=format&fit=crop',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=tony',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stark Electrical Services",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "New York, NY",
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xlg),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionTitle(title: "ABOUT"),
                  Text(
                    "Professional electrical services with years of experience. Licensed and insured. Specializing in residential and commercial electrical work including panel upgrades, rewiring, lighting installation, and emergency repairs.",
                    style: TextStyle(height: 1.5, color: AppColors.black),
                  ),

                  SizedBox(height: AppSpacing.xlg),
                  AppSectionTitle(title: "CONTACT"),
                  _InfoRow(label: "Phone", value: "+1 (212) 555-0123"),
                  _InfoRow(label: "Email", value: "tony@starkelectrical.com"),
                  _InfoRow(
                    label: "Website",
                    value: "starkelectrical.com",
                    valueColor: AppColors.primaryColor,
                  ),

                  SizedBox(height: AppSpacing.xlg),
                  AppSectionTitle(title: "SERVICE AREA"),
                  _InfoRow(label: "Location", value: "New York, NY"),
                  _InfoRow(label: "Service Radius", value: "25 km"),
                  SizedBox(height: AppSpacing.xxlg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
