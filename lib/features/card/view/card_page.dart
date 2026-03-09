import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/shared/widgets/app_header_bar.dart';
import 'package:flutter_methgo_app/features/shared/widgets/main_title.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              AppHeaderBar(subtitle: "Order your favorite Pet!"),
              MainTitle(
                title: "Cart",
                isBack: true,
              ),
              // _purchaseButton(),
            ],
          ),
        ),
      ),
    );
  }
}
