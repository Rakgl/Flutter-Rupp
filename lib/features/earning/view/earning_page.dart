import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/export_shared.dart';
import 'package:go_router/go_router.dart';

class EarningPage extends StatelessWidget {
  const EarningPage({super.key});

  static const String path = '/earning';

  @override
  Widget build(BuildContext context) {
    return const EarningView();
  }
}

class EarningView extends StatelessWidget {
  const EarningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extends the background behind the status bar and AppBar
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        title: const Text(
          'Earnings & Performance',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          const ProfessionalBackground(),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + kToolbarHeight + 10,
              20,
              40,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSummary(),
                SizedBox(height: 12),
                _StatsGrid(),
                SizedBox(height: 24),
                _RatingBreakdown(),
                SizedBox(height: 24),
                _EarningsHistory(),
                SizedBox(height: 24),
                _PerformanceInsights(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSummary extends StatelessWidget {
  const _HeaderSummary();

  @override
  Widget build(BuildContext context) {
    return const HeaderSummaryCard(
      title: 'This Month',
      value: r'$3,240',
      footerIcon: Icons.trending_up,
      footerText: '12.1% from last month',
      footerColor: Colors.green,
      trailingText: '8 jobs',
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: const [
        SmallStatCard(
          label: 'Average Per Job',
          value: r'$404',
          icon: Icons.attach_money,
          iconColor: Colors.blue,
        ),
        SmallStatCard(
          label: 'Overall Rating',
          value: '4.8 ★',
          icon: Icons.star_outline,
          iconColor: Colors.orange,
        ),
        SmallStatCard(
          label: 'Total Jobs (6 months)',
          value: '48',
          icon: Icons.calendar_today_outlined,
          iconColor: Colors.purple,
        ),
        SmallStatCard(
          label: 'Completion Rate',
          value: '96%',
          icon: Icons.verified,
          iconColor: Colors.green,
        ),
      ],
    );
  }
}

class _RatingBreakdown extends StatelessWidget {
  const _RatingBreakdown();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RATING BREAKDOWN',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '4.8',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                      const Text(
                        '18 reviews',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const StatusBarRow(label: '5★', percent: 0.75, count: '13'),
              const StatusBarRow(label: '4★', percent: 0.25, count: '4'),
              const StatusBarRow(label: '3★', percent: 0.08, count: '1'),
              const StatusBarRow(label: '2★', percent: 0.08, count: '1'),
              const StatusBarRow(label: '1★', percent: 0.08, count: '1'),
            ],
          ),
        ),
      ],
    );
  }
}

class _EarningsHistory extends StatelessWidget {
  const _EarningsHistory();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EARNINGS HISTORY',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _historyItem(
          'Dec 2025',
          r'$3,240',
          '8 jobs completed',
          '+12.1%',
          Colors.green,
        ),
        _historyItem(
          'Nov 2025',
          r'$2,890',
          '7 jobs completed',
          '-19.3%',
          Colors.red,
        ),
        _historyItem(
          'Oct 2025',
          r'$3,580',
          '9 jobs completed',
          '+35.1%',
          Colors.green,
        ),
        _historyItem(
          'Sep 2025',
          r'$2,890',
          '7 jobs completed',
          '-19.3%',
          Colors.red,
        ),
        _historyItem(
          'Nov 2025',
          r'$2,890',
          '7 jobs completed',
          '-19.3%',
          Colors.red,
        ),
      ],
    );
  }

  Widget _historyItem(
    String month,
    String amount,
    String jobs,
    String trend,
    Color trendColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    jobs,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    trend,
                    style: TextStyle(
                      color: trendColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: const Color(0xFFF1F5F9),
            color: trendColor.withValues(alpha: 1),
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class _PerformanceInsights extends StatelessWidget {
  const _PerformanceInsights();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERFORMANCE INSIGHTS',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 12),
        InsightCard(
          title: '🎉 Great Month!',
          desc: 'Your earnings are up 12% compared to last month. '
              'Keep up the excellent work!',
          backgroundColor: Color(0xFFF0FDF4),
          accentColor: Colors.green,
        ),
        SizedBox(height: 12),
        InsightCard(
          title: '⭐ High Rating',
          desc: 'Your 4.8 rating is above the platform average. '
                'Customers appreciate your service.',
          backgroundColor: Color(0xFFEFF6FF),
          accentColor: Colors.blue,
        ),
        SizedBox(height: 12),
        InsightCard(
          title: '📈 Growth Trend',
          desc: "You've completed 48 jobs in the last 6 months "
                'with a 96% completion rate.',
          backgroundColor: Color(0xFFF5F3FF),
          accentColor: Colors.purple,
        ),
      ],
    );
  }
}
