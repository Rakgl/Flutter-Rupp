import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/login/view/login_page.dart';
import 'package:go_router/go_router.dart';
import '../profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              stretch: true,
              toolbarHeight: 150,
              backgroundColor: AppColors.eerieBlack,
              title: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xlg,
                    vertical: AppSpacing.md,
                  ),
                  child: _StickyHeader(state: state),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Image.asset(
                  Assets.img.spaceBg1.path,
                  package: 'app_ui',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    _ContactInfoCard(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    _CompletionCard(progress: state.completionProgress),
                    const SizedBox(height: AppSpacing.lg),
                    _QuickAccessGrid(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    _PreferencesSection(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    AppLogoutButton(
                      onPressed: () => context.go(LoginPage.path),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      "Version 1.0.0",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxlg),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StickyHeader extends StatelessWidget {
  final ProfileState state;
  const _StickyHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Profile",
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.24),
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.grey,
                backgroundImage: NetworkImage(
                  'https://static.wikia.nocookie.net/spiderman-films/images/b/be/Tom_Holland_Spidey_Suit.webp',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    state.email,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final ProfileState state;
  const _ContactInfoCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        side: BorderSide(color: AppColors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          children: [
            _infoTile(context, Icons.location_on_outlined, state.location),
            _infoTile(
              context,
              Icons.phone_outlined,
              state.phone,
              trailing: _verifiedBadge(context),
            ),
            _infoTile(context, Icons.email_outlined, state.email),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context,
    IconData icon,
    String text, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey.shade600),
          const SizedBox(width: AppSpacing.md),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.black.withValues(alpha: 0.87),
            ),
          ),
          const Spacer(),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _verifiedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.growthSuccess.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: AppColors.growthSuccess.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shield_outlined,
            size: 14,
            color: AppColors.growthSuccess,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            "Verified",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.growthSuccess,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final double progress;
  const _CompletionCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primaryColor,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "Profile Completion",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "${(progress * 100).toInt()}%",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.grey.shade300,
              color: AppColors.growthSuccess,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Complete your profile to unlock better recommendations and faster bookings",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.black.withValues(alpha: 0.54),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  final ProfileState state;
  const _QuickAccessGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Access",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.count(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.35,
          children: [
            _gridItem(
              context,
              Icons.edit_outlined,
              "Edit Profile",
              "Update your information",
              AppColors.primaryColor,
              onTap: () => context.push(
                EditProfilePage.path,
                extra: context.read<ProfileCubit>(),
              ),
            ),
            _gridItem(
              context,
              Icons.account_balance_wallet_outlined,
              "Wallet",
              "\$${state.walletBalance} available",
              AppColors.growthSuccess,
            ),
            _gridItem(
              context,
              Icons.notifications_none_outlined,
              "Notifications",
              "Edit your notification",
              AppColors.secondary,
            ),
            _gridItem(
              context,
              Icons.settings_outlined,
              "Settings",
              "Preferences & security",
              AppColors.paleSky,
              onTap: () => context.push(SettingsPage.path),
            ),
          ],
        ),
      ],
    );
  }

  Widget _gridItem(
    BuildContext context,
    IconData icon,
    String title,
    String sub,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.lg),
          border: Border.all(color: AppColors.grey.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  final ProfileState state;
  const _PreferencesSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: AppColors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              "Preferences",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            activeTrackColor: AppColors.primaryColor,
            title: Text(
              "Push Notifications",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              "Receive booking updates",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: state.isPushEnabled,
            onChanged: (val) {
              context.read<ProfileCubit>().togglePush(val);
            },
          ),
          SwitchListTile(
            activeTrackColor: AppColors.primaryColor,
            title: Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              "Switch to dark theme",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: state.isDarkMode,
            onChanged: (val) {
              context.read<ProfileCubit>().toggleDarkMode(val);
            },
          ),
        ],
      ),
    );
  }
}
