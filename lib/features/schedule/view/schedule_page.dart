import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_super_aslan_app/features/schedule/schedule.dart';
import 'package:flutter_super_aslan_app/features/schedule/view/appointment_details_page.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleCubit(),
      child: const ScheduleView(),
    );
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          final grouped = groupBy(state.appointments, (Appointment a) => a.dateLabel);

          return CustomScrollView(
            slivers: [
              AppSliverAppBar(
                title: Text(
                  'Schedule',
                  style: UITextStyle.headline3.copyWith(
                    color: AppColors.white,
                  ),
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(70),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: _ViewToggle(),
                  ),
                ),
                titlePadding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  bottom: 70 + 15,
                ),
              ),
              if (state.viewType == ScheduleViewType.list) ...[
                for (final entry in grouped.entries)
                  SliverMainAxisGroup(
                    slivers: [
                      SliverPersistentHeader(
                        delegate: _DateHeaderDelegate(entry.key),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _AppointmentCard(appointment: entry.value[index]),
                            childCount: entry.value.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxlg)),
              ] else ...[
                SliverToBoxAdapter(
                  child: _CalendarWidget(
                    focusedDay: state.focusedDay ?? DateTime.now(),
                    selectedDay: state.selectedDay,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _AppointmentCard(appointment: state.appointments[index]),
                      childCount: state.appointments.length,
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxlg)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  const _CalendarWidget({
    required this.focusedDay,
    this.selectedDay,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar<dynamic>(
        firstDay: DateTime.utc(2020),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (selected, focused) {
          context.read<ScheduleCubit>().selectDay(selected, focused);
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.deepPurpleAccent,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle();

  @override
  Widget build(BuildContext context) {
    final viewType = context.select((ScheduleCubit c) => c.state.viewType);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              label: 'List View',
              isSelected: viewType == ScheduleViewType.list,
              onTap: () =>
                  context.read<ScheduleCubit>().toggleView(ScheduleViewType.list),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              label: 'Calendar View',
              isSelected: viewType == ScheduleViewType.calendar,
              onTap: () =>
                  context.read<ScheduleCubit>().toggleView(ScheduleViewType.calendar),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepPurpleAccent
              : AppColors.grey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  _DateHeaderDelegate(this.date);
  final String date;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        date,
        style: const TextStyle(
          color: AppColors.paleSky,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant _DateHeaderDelegate oldDelegate) {
    return oldDelegate.date != date;
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (appointment.title == 'Electrical Panel Upgrade') {
          context.push(AppointmentDetailsPage.path);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  appointment.time,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              appointment.clientName,
              style: const TextStyle(color: AppColors.paleSky, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  IconlyLight.location,
                  size: 16,
                  color: AppColors.paleSky,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.address,
                    style: const TextStyle(
                      color: AppColors.paleSky,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
