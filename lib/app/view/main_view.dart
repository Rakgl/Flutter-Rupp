import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/features/accessory/view/accessory_page.dart';
import 'package:flutter_super_aslan_app/features/about/view/about_view.dart';
import 'package:flutter_super_aslan_app/features/card/view/card_page.dart';
import 'package:flutter_super_aslan_app/features/favorite/view/favorite_page.dart';
import 'package:flutter_super_aslan_app/features/home/view/home_page.dart';
import 'package:flutter_super_aslan_app/features/profile/view/profile_page.dart';
import 'package:flutter_super_aslan_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_super_aslan_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_super_aslan_app/navigation/view/bottom_nav_bar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  static const String path = '/main';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _BodyView(),
    );
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
          AccessoryPage(),
          AboutPage(),
          FavoritePage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CardPage()),
          );
        },
        backgroundColor: const Color(0xFF3B82F6), // Methgo blue
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
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
