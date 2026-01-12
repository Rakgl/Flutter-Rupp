import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_super_aslan_app/features/home/home.dart';

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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const _HomeAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const _NextAppointmentCard(),
                      const SizedBox(height: AppSpacing.lg),
                      const _ProposalsGrid(),
                      const SizedBox(height: AppSpacing.lg),
                      const _EarningsPerformanceSection(),
                      const SizedBox(height: AppSpacing.lg),
                      const _ReputationSection(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 240,
      toolbarHeight: 90,
      backgroundColor: AppColors.darkBackground,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://static.wikia.nocookie.net/spiderman-films/images/b/be/Tom_Holland_Spidey_Suit.webp/revision/latest?cb=20230914135801',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peter Parker',
                  style: UITextStyle.headline6.copyWith(color: AppColors.white),
                ),
                Text(
                  'Plumbing',
                  style: UITextStyle.bodyText2.copyWith(
                    color: AppColors.paleSky,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF61AFFE),
                  Color(0xFFC36BFC),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: AppColors.white,
                ),
                SizedBox(width: 4),
                Text(
                  'Active',
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: AppColors.white),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.img.spaceBg.image().image,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _statusTile(
                        '24',
                        'Completed',
                        Icons.check_circle_outline,
                        AppColors.trendPositive,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statusTile(
                        '3',
                        'Ongoing',
                        Icons.access_time,
                        AppColors.confirmedColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statusTile(
                        '5',
                        'Upcoming',
                        Icons.calendar_today,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statusTile(
                        '2',
                        'Canceled',
                        Icons.cancel_outlined,
                        AppColors.trendNegative,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusTile(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.paleSky),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _NextAppointmentCard extends StatelessWidget {
  const _NextAppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2E2865),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Next Appointment',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF61AFFE),
                      Color(0xFFC36BFC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: AppColors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Confirm',
                      style: TextStyle(color: AppColors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    CircleAvatar(radius: 12, child: Text('T')),
                    SizedBox(width: 8),
                    Text(
                      "T'Challa",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Kitchen Sink Repair',
                    style: TextStyle(color: AppColors.paleSky),
                  ),
                ),
                const Divider(),
                _iconLabel(Icons.calendar_today, 'Today'),
                _iconLabel(Icons.access_time, '2:00 PM'),
                _iconLabel(Icons.location_on_outlined, '742 Evergreen Terrace'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  '5 total upcoming appointments',
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View Full Schedule →',
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.paleSky),
          const SizedBox(width: 8),
          Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

class _ProposalsGrid extends StatelessWidget {
  const _ProposalsGrid();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Proposals & Requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  'Manage All Proposals ›',
                  style: TextStyle(fontSize: 10, color: AppColors.white),
                ),
              ),
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _proposalTile(
                'New Service\nRequests',
                '3',
                'Requests →',
                AppColors.surface2,
                AppColors.confirmedColor,
                Icons.error_outline,
              ),
              _proposalTile(
                'Pending\nProposals',
                '4',
                'More details →',
                const Color(0xFFFFFDE7),
                AppColors.ratingPrimary,
                Icons.description_outlined,
              ),
              _proposalTile(
                'Accepted',
                '2',
                'Begin Work →',
                const Color(0xFFE8F5E9),
                AppColors.trendPositive,
                Icons.check_circle_outline,
              ),
              _proposalTile(
                'Expired',
                '1',
                'More →',
                const Color(0xFFFFEBEE),
                AppColors.trendNegative,
                Icons.cancel_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _proposalTile(
    String title,
    String count,
    String action,
    Color bg,
    Color accent,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accent.withOpacity(0.6)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 10, color: AppColors.paleSky),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              action,
              style: TextStyle(fontSize: 10, color: AppColors.trendNegative),
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsPerformanceSection extends StatelessWidget {
  const _EarningsPerformanceSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Earnings & Performance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: const [
                  Icon(
                    Icons.trending_up,
                    color: AppColors.trendPositive,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Trending up',
                    style: TextStyle(
                      color: AppColors.trendPositive,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _earningsTile(
                'Total Earnings',
                '\$48,750.50',
                'Lifetime',
                AppColors.surface2,
                AppColors.confirmedColor,
              ),
              _earningsTile(
                'This Month',
                '\$3,250.00',
                'December 2025',
                const Color(0xFFE8F5E9),
                AppColors.trendPositive,
              ),
              _earningsTile(
                'This Week',
                '\$875.00',
                'Last 7 days',
                const Color(0xFFF3E5F5),
                Colors.purple,
              ),
              _earningsTile(
                'Pending Payout',
                '\$450.00',
                'Processing',
                const Color(0xFFFFF3E0),
                AppColors.warningAccent,
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Payout',
                    style: TextStyle(color: AppColors.paleSky, fontSize: 12),
                  ),
                  Text(
                    '\$2,100.00 • Dec 6, 2025',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  'View Payout Details ›',
                  style: TextStyle(fontSize: 10, color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _earningsTile(
    String label,
    String val,
    String sub,
    Color bg,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, size: 14, color: iconColor),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.paleSky,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            val,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            sub,
            style: const TextStyle(fontSize: 10, color: AppColors.paleSky),
          ),
        ],
      ),
    );
  }
}

class _ReputationSection extends StatelessWidget {
  const _ReputationSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Reputation & Reviews',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            '4.8',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Icon(
                i < 4 ? Icons.star : Icons.star_half,
                color: AppColors.ratingPrimary,
              ),
            ),
          ),
          const Text(
            'Based on 156 customer reviews',
            style: TextStyle(color: AppColors.paleSky, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Tom Wilson',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          color: AppColors.ratingPrimary,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '"Excellent service! Fixed the issue quickly and professionally."',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                  ),
                ),
                const Text(
                  'Dec 10',
                  style: TextStyle(color: AppColors.paleSky, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text(
              'View All Reviews ›',
              style: TextStyle(fontSize: 12, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
