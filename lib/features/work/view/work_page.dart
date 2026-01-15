import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/export_shared.dart';
import 'package:go_router/go_router.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  static const String path = '/work';

  @override
  Widget build(BuildContext context) {
    return const WorkView();
  }
}

class WorkView extends StatelessWidget {
  const WorkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        title: const Text(
          'Work Summary',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _WorkStatsGrid(),
                const SizedBox(height: 10),
                
                _sectionHeader('ONGOING JOBS (3)', Icons.access_time, Colors.blue),
                const _JobCard(
                  title: 'Panel Upgrade',
                  name: 'Peter Parker',
                  date: 'Dec 17, 2025',
                  price: r'$1,200',
                  status: 'ongoing',
                  statusColor: Colors.blue,
                  statusBg: Color(0xFFE3F2FD),
                ),
                const _JobCard(
                  title: 'Electrical Inspection',
                  name: 'Peter Parker',
                  date: 'Dec 17, 2025',
                  price: r'$200',
                  status: 'ongoing',
                  statusColor: Colors.blue,
                  statusBg: Color(0xFFE3F2FD),
                ),
                const _JobCard(
                  title: 'Rewiring Project',
                  name: 'Peter Parker',
                  date: 'Dec 16, 2025',
                  price: r'$1,500',
                  status: 'ongoing',
                  statusColor: Colors.blue,
                  statusBg: Color(0xFFE3F2FD),
                ),

                _sectionHeader('UPCOMING JOBS (3)', Icons.calendar_today_outlined, Colors.purple),
                const _JobCard(
                  title: 'Electrical Panel Upgrade',
                  name: 'Sarah Johnson',
                  date: 'Dec 18, 2025',
                  price: r'$1,200',
                  status: 'upcoming',
                  statusColor: Colors.purple,
                  statusBg: Color(0xFFF3E5F5),
                ),
                const _JobCard(
                  title: 'Lighting Installation',
                  name: 'Peter Parker',
                  date: 'Dec 19, 2025',
                  price: r'$400',
                  status: 'upcoming',
                  statusColor: Colors.purple,
                  statusBg: Color(0xFFF3E5F5),
                ),

                _sectionHeader('COMPLETED JOBS (4)', Icons.check_circle_outline, Colors.green),
                const _JobCard(
                  title: 'Lighting Installation',
                  name: 'Peter Parker',
                  date: 'Dec 15, 2025',
                  price: r'$400',
                  status: 'completed',
                  statusColor: Colors.green,
                  statusBg: Color(0xFFE8F5E9),
                ),
                const _JobCard(
                  title: 'Circuit Breaker Repair',
                  name: 'Peter Parker',
                  date: 'Dec 15, 2025',
                  price: r'$400',
                  status: 'completed',
                  statusColor: Colors.green,
                  statusBg: Color(0xFFE8F5E9),
                ),
                const _JobCard(
                  title: 'Wiring & Rewiring',
                  name: 'Peter Parker',
                  date: 'Dec 15, 2025',
                  price: r'$400',
                  status: 'completed',
                  statusColor: Colors.green,
                  statusBg: Color(0xFFE8F5E9),
                ),
                const _JobCard(
                  title: 'Outlet Installation',
                  name: 'Peter Parker',
                  date: 'Dec 15, 2025',
                  price: r'$400',
                  status: 'completed',
                  statusColor: Colors.green,
                  statusBg: Color(0xFFE8F5E9),
                ),

                _sectionHeader('COMPLETED JOBS (4)', Icons.cancel_outlined, Colors.red),
                const _JobCard(
                  title: 'Panel Upgrade',
                  name: 'Peter Parker',
                  date: 'Dec 15, 2025',
                  price: r'$400',
                  status: 'cancelled',
                  statusColor: Colors.red,
                  statusBg: Color.fromARGB(255, 248, 211, 211),
                ),
                 const _JobCard(
                  title: 'Outlet Installation',
                  name: 'Peter Parker',
                  date: 'Dec 15, 2025',
                  price: r'$400',
                  status: 'cancelled',
                  statusColor: Colors.red,
                  statusBg: Color.fromARGB(255, 248, 211, 211),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {

  const _JobCard({
    required this.title,
    required this.name,
    required this.date,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.statusBg,
  });
  final String title;
  final String name;
  final String date;
  final String price;
  final String status;
  final Color statusColor;
  final Color statusBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkStatsGrid extends StatelessWidget {
  const _WorkStatsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: const [
        SmallStatCard(
          label: 'Completed Jobs',
          value: '142',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
        ),
        SmallStatCard(
          label: 'Ongoing Jobs',
          value: '3',
          icon: Icons.timeline,
          iconColor: Colors.blue,
        ),
        SmallStatCard(
          label: 'Upcoming Jobs',
          value: '12',
          icon: Icons.calendar_today_outlined,
          iconColor: Colors.purple,
        ),
        SmallStatCard(
          label: 'Cancelled Jobs',
          value: '98%',
          icon: Icons.cancel_outlined,
          iconColor: Colors.red,
        ),
      ],
    );
  }
}
