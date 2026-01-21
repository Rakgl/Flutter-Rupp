import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  static const String path = '/profile/transaction-history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Match scaffold color from image
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.black,
            size: 28,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Payouts & Earnings",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance Card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.xlg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Balance",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    r"$3,240",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xlg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1A2138,
                        ), // Dark color from image
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Request Payout",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xlg),

            // This Month Section
            Text(
              "THIS MONTH",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Earned",
                          style: TextStyle(color: AppColors.grey),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          r"$6,840",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Jobs Completed",
                          style: TextStyle(color: AppColors.grey),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "12",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xlg),

            // Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RECENT TRANSACTIONS",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    IconlyLight.download,
                    size: 16,
                    color: AppColors.black,
                  ),
                  label: const Text(
                    "Export",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Transaction List
            const _TransactionItem(
              title: "Panel Upgrade - Tony Stark",
              date: "Dec 15, 2025",
              amount: r"+$1,200",
              status: "completed",
            ),
            const _TransactionItem(
              title: "Lighting Installation - Peter Parker",
              date: "Dec 12, 2025",
              amount: r"+$450",
              status: "completed",
            ),
            const _TransactionItem(
              title: "Circuit Repair - Natasha Romanoff",
              date: "Dec 10, 2025",
              amount: r"+$280",
              status: "completed",
            ),
            const _TransactionItem(
              title: "Payout to Bank ****1234",
              date: "Dec 8, 2025",
              amount: r"-$1,850",
              amountColor: AppColors.black,
              status: "transferred",
              statusBgColor: Color(0xFFE0E0E0), // Light grey for payout
            ),
            const _TransactionItem(
              title: "Wiring Work - Bruce Banner",
              date: "Dec 5, 2025",
              amount: r"+$920",
              status: "completed",
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final Color amountColor;
  final String status;
  final Color statusBgColor;

  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.amountColor = AppColors.growthSuccess,
    this.statusBgColor = const Color(0xFFD4F7DC), // Light green default
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusBgColor == const Color(0xFFD4F7DC)
                          ? AppColors.growthSuccess
                          : AppColors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
