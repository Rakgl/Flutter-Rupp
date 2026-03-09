import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/home/home.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/app_header_bar.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/category_list.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/grid_cart.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/search_bar.dart';

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
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeaderBar(subtitle: "Order your favorite Pet!"),
                  SizedBox(height: 30),
                  SearchButton(),
                  SizedBox(height: 30),
                  CategoryList(categories: ['All', 'Dog', 'Cat', 'Fish']),
                  SizedBox(
                    height: 20,
                  ),
                  GridCart(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
