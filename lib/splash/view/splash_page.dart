import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/app/view/main_view.dart';
import 'package:go_router/go_router.dart';

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
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      context.go(MainView.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,

      children: [
        Assets.img.backgroundImage.image(
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          
          body: SafeArea(
            child: Center(
              child: Assets.img.appLogo.image(
                width: 280,
                height: 280,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
