import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/request/request.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/widgets.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestCubit(),
      child: const RequestView(),
    );
  }
}

class RequestView extends StatelessWidget {
  const RequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<RequestCubit, RequestState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              AppSliverAppBar(
                title: Text(
                  'Requests',
                  style: UITextStyle.headline3.copyWith(
                    color: AppColors.white,
                  ),
                ),
                titlePadding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  bottom: 16,
                ),
                // Using defaults for height (200/200) unless adjusted
                expandedHeight: 170, // Match default adjustment if I made it
                collapsedHeight: 170,
              ),
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No requests found',
                    style: TextStyle(color: AppColors.grey),
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