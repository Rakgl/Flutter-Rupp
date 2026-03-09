import 'package:flutter/widgets.dart';
import 'package:flutter_methgo_app/features/shared/widgets/app_header_bar.dart';
import 'package:flutter_methgo_app/features/shared/widgets/main_title.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            AppHeaderBar(subtitle: "Order your favorite Pet!"),
            MainTitle(title: "Favorite Pets", isBack: false,),
          ],
        ),
      ),
    );
  }
}
