import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/categories/view/categories_page.dart';
import 'package:flutter_methgo_app/features/about/view/about_view.dart';
import 'package:flutter_methgo_app/features/card/view/card_page.dart';
import 'package:flutter_methgo_app/features/favorite/view/favorite_page.dart';
import 'package:flutter_methgo_app/features/home/view/home_page.dart';
import 'package:flutter_methgo_app/features/profile/view/profile_page.dart';
import 'package:flutter_methgo_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_methgo_app/navigation/view/bottom_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';


class MainView extends StatelessWidget {
  const MainView({super.key});

  static const String path = '/main';

  @override
  Widget build(BuildContext context) {
    return const _BodyView();
  }
}

class _BodyView extends StatefulWidget {
  const _BodyView();

  @override
  State<_BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<_BodyView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (NavigationCubit cubit) => cubit.state.tabIndex,
    );
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: selectedTab,
        alignment: Alignment.center,
        children: const [
          HomePage(),
          CategoriesPage(),
          AboutPage(),
          FavoritePage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: BlocBuilder<CardCubit, CardState>(
        builder: (context, state) {
          final itemCount = state.cartData?.items.length ?? 0;
          return badges.Badge(
            showBadge: itemCount > 0,
            badgeContent: Text(
              itemCount.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const CardPage()),
                );
              },
              backgroundColor: const Color(0xFF3B82F6), // Methgo blue
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedTab,
        onTap: (value) {
          BlocProvider.of<NavigationCubit>(context).setTab(value);
        },
      ),
    );
  }
}
