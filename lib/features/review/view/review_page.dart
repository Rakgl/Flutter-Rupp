import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/export_shared.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  static const String path = '/reviews';

  @override
  Widget build(BuildContext context) {
    return const ReviewView();
  }
}

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        title: const Text(
          'Reviews & Ratings',
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
                _OverallRatingCard(),
                SizedBox(height: 24),
                _ReviewItem(
                  name: 'Tony Stark',
                  date: '2 days ago',
                  jobTitle: 'Electrical Panel Upgrade',
                  comment: 'Excellent work! Very professional and completed the '
                      'electrical panel upgrade ahead of schedule. Highly recommend!',
                  rating: 5,
                ),
                _ReviewItem(
                  name: 'Peter Parker',
                  date: '1 week ago',
                  jobTitle: 'Lighting Installation',
                  comment: 'Great service from start to finish. The lighting '
                      'installation looks amazing and Michael was very knowledgeable.',
                  rating: 5,
                ),
                _ReviewItem(
                  name: 'Gamora Zen',
                  date: '2 weeks ago',
                  jobTitle: 'Circuit Breaker Repair',
                  comment: 'Good work overall. There was a minor delay but Michael '
                      'communicated well and the final result is solid.',
                  rating: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallRatingCard extends StatelessWidget {
  const _OverallRatingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20
                      );
                    }),
                  ),
                  const Text(
                    '18 reviews',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const StatusBarRow(label: '5★', percent: 0.85, count: '13'),
          const StatusBarRow(label: '4★', percent: 0.30, count: '4'),
          const StatusBarRow(label: '3★', percent: 0.10, count: '1'),
          const StatusBarRow(label: '2★', percent: 0.10, count: '1'),
          const StatusBarRow(label: '1★', percent: 0.10, count: '1'),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {

  const _ReviewItem({
    required this.name,
    required this.date,
    required this.jobTitle,
    required this.comment,
    required this.rating,
  });
  final String name;
  final String date;
  final String jobTitle;
  final String comment;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15, 
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 14,
                color: index < rating ? Colors.amber : const Color(0xFFE2E8F0),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            jobTitle,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 14,
              height: 1.5
            ),
          ),
        ],
      ),
    );
  }
}
