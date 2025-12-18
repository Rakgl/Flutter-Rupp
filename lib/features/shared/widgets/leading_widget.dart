import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeadingWidget extends StatelessWidget {
  const LeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
