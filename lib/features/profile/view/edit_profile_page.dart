import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:flutter_super_aslan_app/features/earning/view/earning_page.dart';
import 'package:flutter_super_aslan_app/features/auth/login/view/login_page.dart';
import 'package:go_router/go_router.dart';
import '../profile.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static const String path = '/edit-profile';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              "Profile Setup Flow",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            leading: IconButton(
              icon: const Icon(IconlyLight.arrowLeft, color: AppColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(state: state),
                const SizedBox(height: AppSpacing.xlg),

                const AppSectionTitle(title: "BUSINESS PROFILE"),
                _buildProfileTile(
                  label: "Business Information",
                  onTap: () => context.push(BusinessInfoPage.path),
                ),
                _buildProfileTile(
                  label: "Services & Pricing",
                  onTap: () => context.push(ServicesPricingPage.path),
                ),
                _buildProfileTile(
                  label: "Working Hours",
                  onTap: () => context.push(WorkingHoursPage.path),
                ),
                _buildProfileTile(
                  label: "Portfolio",
                  onTap: () => context.push(PortfolioPage.path),
                ),
                const SizedBox(height: AppSpacing.lg),
                const AppSectionTitle(title: "VERIFICATION STATUS"),
                _buildStatusTile(
                  label: "Business License",
                  subLabel: "Verified",
                  icon: IconlyLight.shieldDone,
                  iconColor: AppColors.growthSuccess,
                ),
                _buildStatusTile(
                  label: "Payment Method",
                  subLabel: "Connected",
                  icon: IconlyLight.tickSquare,
                  iconColor: AppColors.growthSuccess,
                ),
                _buildStatusTile(
                  label: "Insurance",
                  subLabel: "Upload required",
                  icon: IconlyLight.infoSquare,
                  iconColor: Colors.orange,
                  showArrow: true,
                  borderColor: Colors.orange.withValues(alpha: 0.3),
                ),

                const SizedBox(height: AppSpacing.lg),
                const AppSectionTitle(title: "FINANCIAL"),
                _buildProfileTile(
                  label: "Payouts & Earnings",
                  subLabel: "\$${state.walletBalance}",
                  caption: "Available balance",
                  leadingIcon: IconlyLight.wallet,
                  onTap: () => context.push(EarningPage.path),
                ),
                _buildProfileTile(
                  label: "Transaction History",
                  onTap: () => context.push(TransactionHistoryPage.path),
                ),

                const SizedBox(height: AppSpacing.lg),
                const AppSectionTitle(title: "ACCOUNT SETTINGS"),
                _buildProfileTile(
                  label: "Language",
                  trailingText: "English",
                  onTap: () {},
                ),
                AppSwitchTile(
                  title: "Dark Mode",
                  value: state.isDarkMode,
                  onChanged: (val) =>
                      context.read<ProfileCubit>().toggleDarkMode(val),
                ),
                _buildProfileTile(label: "Notifications", onTap: () {}),
                _buildProfileTile(label: "Privacy & Security", onTap: () {}),

                const SizedBox(height: AppSpacing.xlg),
                AppLogoutButton(onPressed: () => context.go(LoginPage.path)),
                const SizedBox(height: AppSpacing.xxlg),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTile({
    required String label,
    required VoidCallback onTap,
    String? subLabel,
    String? caption,
    String? trailingText,
    IconData? leadingIcon,
  }) {
    return AppListTile(
      title: label,
      subtitle: subLabel,
      caption: caption,
      leading: leadingIcon != null
          ? CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.grey.shade100,
              child: Icon(leadingIcon, size: 20, color: AppColors.grey),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: AppColors.grey)),
          const SizedBox(width: 4),
          const Icon(IconlyLight.arrowRight2, color: AppColors.grey, size: 18),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatusTile({
    required String label,
    required String subLabel,
    required IconData icon,
    required Color iconColor,
    bool showArrow = false,
    Color? borderColor,
  }) {
    final listTile = ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subLabel, style: const TextStyle(color: AppColors.grey)),
      trailing: showArrow
          ? const Icon(IconlyLight.arrowRight2, color: AppColors.grey, size: 18)
          : null,
    );

    if (borderColor != null) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: listTile,
      );
    }
    return AppCard(child: listTile);
  }
}

class _HeaderSection extends StatelessWidget {
  final ProfileState state;
  const _HeaderSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.grey.shade200,
          child: Text(
            state.name.split(' ').map((e) => e[0]).take(2).join(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("Scientist", style: TextStyle(color: AppColors.grey)),
            Text(state.location, style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: AppSpacing.sm),
            const Row(
              children: [
                Icon(Icons.circle, color: AppColors.growthSuccess, size: 8),
                SizedBox(width: 4),
                Text("Profile Active", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
