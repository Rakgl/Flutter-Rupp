import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_methgo_app/app/view/main_view.dart';
import 'package:flutter_methgo_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_methgo_app/navigation/view/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class ServicesPricingPage extends StatelessWidget {
  const ServicesPricingPage({super.key});

  static const String path = '/services-pricing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
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
          "Services & Pricing",
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
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: const [
          // Services Available Summary Card
          _SummaryCard(count: 6),

          SizedBox(height: AppSpacing.lg),

          _ServicePriceCard(
            title: "Circuit Breaker Repair",
            priceRange: r"$150 - $300",
          ),
          _ServicePriceCard(
            title: "Electrical Panel Upgrade",
            priceRange: r"$1,200 - $1,800",
          ),
          _ServicePriceCard(
            title: "Lighting Installation",
            priceRange: r"$200 - $500",
          ),
          _ServicePriceCard(
            title: "Wiring & Rewiring",
            priceRange: r"$800 - $1,500",
          ),
          _ServicePriceCard(
            title: "Outlet Installation",
            priceRange: r"$100 - $250",
          ),
          _ServicePriceCard(
            title: "Electrical Inspection",
            priceRange: r"$150 - $300",
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int count;
  const _SummaryCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF), // Light blue tint
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0E4FF)),
      ),
      child: Text(
        "$count services available",
        style: const TextStyle(
          color: Color(0xFF0056D2),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ServicePriceCard extends StatelessWidget {
  final String title;
  final String priceRange;

  const _ServicePriceCard({required this.title, required this.priceRange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            priceRange,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
