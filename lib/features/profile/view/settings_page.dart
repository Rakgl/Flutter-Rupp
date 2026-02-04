import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String path = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          "Account Settings",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle(title: "LANGUAGE & REGION"),
            AppListTile(
              title: "Language",
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("English", style: TextStyle(color: AppColors.grey)),
                  SizedBox(width: 4),
                  Icon(
                    IconlyLight.arrowRight2,
                    color: AppColors.grey,
                    size: 18,
                  ),
                ],
              ),
              onTap: () {},
            ),

            const SizedBox(height: AppSpacing.xlg),
            const AppSectionTitle(title: "NOTIFICATIONS"),
            AppSwitchTile(
              title: "New Request Alerts",
              subtitle: "Get notified when new job requests arrive",
              value: true,
              onChanged: (val) {},
              activeColor: const Color(0xFF1A2138),
            ),
            AppSwitchTile(
              title: "Message Notifications",
              subtitle: "Get notified for new messages",
              value: true,
              onChanged: (val) {},
              activeColor: const Color(0xFF1A2138),
            ),
            AppSwitchTile(
              title: "Appointment Reminders",
              subtitle: "Reminder before scheduled appointments",
              value: false,
              onChanged: (val) {},
              activeColor: const Color(0xFF1A2138),
            ),

            const SizedBox(height: AppSpacing.xlg),
            const AppSectionTitle(title: "PRIVACY & SECURITY"),
            AppListTile(
              title: "Change Password",
              trailing: const Icon(
                IconlyLight.arrowRight2,
                color: AppColors.grey,
                size: 18,
              ),
              onTap: () {},
            ),
            AppListTile(
              title: "Two-Factor Authentication",
              trailing: const Icon(
                IconlyLight.arrowRight2,
                color: AppColors.grey,
                size: 18,
              ),
              onTap: () {},
            ),
            AppListTile(
              title: "Privacy Policy",
              trailing: const Icon(
                IconlyLight.arrowRight2,
                color: AppColors.grey,
                size: 18,
              ),
              onTap: () {},
            ),

            const SizedBox(height: AppSpacing.xlg),
            const AppSectionTitle(title: "ABOUT"),
            AppListTile(
              title: "Terms of Service",
              trailing: const Icon(
                IconlyLight.arrowRight2,
                color: AppColors.grey,
                size: 18,
              ),
              onTap: () {},
            ),
            AppListTile(
              title: "Help & Support",
              trailing: const Icon(
                IconlyLight.arrowRight2,
                color: AppColors.grey,
                size: 18,
              ),
              onTap: () {},
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildVersionInfo("SuperAslan Professional v1.2.0"),
            const SizedBox(height: AppSpacing.xxlg),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo(String version) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          version,
          style: const TextStyle(color: AppColors.grey, fontSize: 13),
        ),
      ),
    );
  }
}
