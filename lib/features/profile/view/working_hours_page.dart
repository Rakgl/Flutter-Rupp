import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_methgo_app/app/view/main_view.dart';
import 'package:flutter_methgo_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_methgo_app/navigation/view/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class WorkingHoursPage extends StatelessWidget {
  const WorkingHoursPage({super.key});

  static const String path = '/working-hours';

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
          "Working Hours",
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(title: "WEEKLY SCHEDULE"),
            _ScheduleTile(day: "Monday", time: "9:00 AM - 5:00 PM"),
            _ScheduleTile(day: "Tuesday", time: "9:00 AM - 5:00 PM"),
            _ScheduleTile(day: "Wednesday", time: "9:00 AM - 5:00 PM"),
            _ScheduleTile(day: "Thursday", time: "9:00 AM - 5:00 PM"),
            _ScheduleTile(day: "Friday", time: "9:00 AM - 5:00 PM"),
            _ScheduleTile(day: "Saturday", time: "Closed", isClosed: true),
            _ScheduleTile(day: "Sunday", time: "Closed", isClosed: true),

            SizedBox(height: AppSpacing.lg),
            AppSectionTitle(title: "BOOKING PREFERENCE"),
            _PreferenceCard(),

            SizedBox(height: AppSpacing.lg),
            AppSectionTitle(title: "BLOCKED DATES"),
            _BlockedDateTile(
              dateRange: "Dec 24 - Dec 26, 2025",
              reason: "Holiday break",
            ),
            SizedBox(height: AppSpacing.xxlg),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  final String day;
  final String time;
  final bool isClosed;

  const _ScheduleTile({
    required this.day,
    required this.time,
    this.isClosed = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              color: isClosed ? AppColors.grey : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Request Approval Required",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "You review and approve each booking request",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockedDateTile extends StatelessWidget {
  final String dateRange;
  final String reason;

  const _BlockedDateTile({required this.dateRange, required this.reason});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Icon(IconlyLight.calendar, color: AppColors.black, size: 24),
          const SizedBox(width: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateRange,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                reason,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
