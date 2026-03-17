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
import 'package:repository/repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_methgo_app/features/auth/login/view/login_page.dart';


class MainView extends StatelessWidget {
  const MainView({super.key});

  static const String path = '/main';

  @override
  Widget build(BuildContext context) {
    return _BodyView(
      userRepository: context.read<UserRepository>(),
    );
  }
}

class _BodyView extends StatefulWidget {
  const _BodyView({required this.userRepository});

  final UserRepository userRepository;

  @override
  State<_BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<_BodyView> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await widget.userRepository.readToken();
    if (mounted) {
      setState(() {
        _isLoggedIn =
            token.isNotEmpty && token[0] != null && token[0]!.isNotEmpty;
      });
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to log in or register to access this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(LoginPage.path);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (NavigationCubit cubit) => cubit.state.tabIndex,
    );

    final List<Widget> authenticatedPages = [
      const HomePage(),
      const CategoriesPage(),
      const AboutPage(),
      const FavoritePage(),
      const ProfilePage(),
    ];

    final List<Widget> guestPages = [
      const HomePage(),
      const CategoriesPage(),
      const AboutPage(),
      const HomePage(), // Placeholder
      const HomePage(), // Placeholder
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: selectedTab,
        alignment: Alignment.center,
        children: _isLoggedIn ? authenticatedPages : guestPages,
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
                if (_isLoggedIn) {
                   Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const CardPage()),
                  );
                } else {
                  _showLoginRequiredDialog(context);
                }
              },
              backgroundColor: const Color(0xFF3B82F6), // Pet Shop blue
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
          if (!_isLoggedIn && (value == 3 || value == 4)) {
            _showLoginRequiredDialog(context);
          } else {
            BlocProvider.of<NavigationCubit>(context).setTab(value);
          }
        },
      ),
    );
  }
}