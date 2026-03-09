import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_methgo_app/app/view/main_view.dart';
import 'package:flutter_methgo_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_methgo_app/navigation/view/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  static const String path = '/portfolio';

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
          "Portfolio",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              IconlyLight.edit,
              color: AppColors.black,
              size: 22,
            ),
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "3 portfolio items",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _PortfolioItem(
              imageUrl:
                  'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=2071&auto=format&fit=crop',
              title: 'Commercial Lighting Installation',
              description: 'LED lighting installation for office building',
              imageCount: 6,
            ),
            const _PortfolioItem(
              imageUrl:
                  'https://images.unsplash.com/photo-1513828583688-c52646db42da?q=80&w=2070&auto=format&fit=crop',
              title: 'Commercial Lighting Installation',
              description: 'LED lighting installation for office building',
              imageCount: 6,
            ),
            const _PortfolioItem(
              imageUrl:
                  'https://images.unsplash.com/photo-1581092160562-40aa08e78837?q=80&w=2070&auto=format&fit=crop',
              title: 'Emergency Panel Repair',
              description: 'Urgent electrical panel repair and safety upgrade',
              imageCount: 3,
            ),
            const SizedBox(height: AppSpacing.xxlg),
          ],
        ),
      ),
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final int imageCount;

  const _PortfolioItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.imageCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$imageCount images",
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            IconlyLight.show,
                            size: 16,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "View",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
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
}
