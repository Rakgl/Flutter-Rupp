import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/welcome/view/welcome_page.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/user_repository.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String path = '/';

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final String splashImg = "assets/images/splash_img.png";

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final userRepository = context.read<UserRepository>();
      final token = await userRepository.readToken();

      if (!mounted) return;

      if (token.isNotEmpty && token[0] != null && token[0]!.isNotEmpty) {
        context.go(MainView.path);
      } else {
        context.go(WelcomePage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8BA5F8),
                  Color(0xFF1E32C4),
                ],
              ),
            ),
          ),

          Positioned(
            left: -50,
            right: 0,
            bottom: -40,
            height: MediaQuery.of(context).size.height * 0.55,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.white],
                  stops: [0.0, 0.3],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                splashImg,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Methgo',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
