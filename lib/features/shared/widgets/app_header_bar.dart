import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/profile/view/profile_page.dart';
import 'package:flutter_methgo_app/features/card/view/card_page.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:badges/badges.dart' as badges;
import 'package:repository/repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_methgo_app/features/auth/login/view/login_page.dart';

class AppHeaderBar extends StatelessWidget {
  const AppHeaderBar({super.key, required this.subtitle});

  final String subtitle;

  Future<void> _checkLoginAndNavigate(BuildContext context, Widget page) async {
    final userRepository = context.read<UserRepository>();
    final token = await userRepository.readToken();
    final isLoggedIn = token.isNotEmpty && token[0] != null && token[0]!.isNotEmpty;

    if (context.mounted) {
      if (isLoggedIn) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => page),
        );
      } else {
        _showLoginRequiredDialog(context);
      }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pet Shop',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            BlocBuilder<CardCubit, CardState>(
              builder: (context, state) {
                final itemCount = state.cartData?.items.length ?? 0;
                return badges.Badge(
                  showBadge: itemCount > 0,
                  badgeContent: Text(
                    itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -5),
                  child: IconButton(
                    onPressed: () => _checkLoginAndNavigate(context, const CardPage()),
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF3B82F6),
                      size: 28,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://static.wikia.nocookie.net/spiderman-films/images/b/be/Tom_Holland_Spidey_Suit.webp/revision/latest?cb=20230914135801',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
