import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/shared/widgets/app_header_bar.dart';
import 'package:flutter_methgo_app/features/shared/widgets/category_list.dart';
import 'package:flutter_methgo_app/features/shared/widgets/grid_cart.dart';
import 'package:flutter_methgo_app/features/shared/widgets/search_bar.dart';

class AccessoryPage extends StatefulWidget {
  const AccessoryPage({super.key});

  @override
  State<AccessoryPage> createState() => _AccessoryPageState();
}

class _AccessoryPageState extends State<AccessoryPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            AppHeaderBar(subtitle: "Order your pet accessories!"),
            Text(
              "Accessories",
              style: TextStyle(fontSize: 30, color: Color(0xFF3B82F6)),
            ),
            SearchButton(),
            SizedBox(
              height: 20,
            ),
            CategoryList(
              categories: ['All', 'Collar', 'Toy', 'Food', 'Water Bowl'],
            ),
            SizedBox(height: 20),
            GridCart(isAdd: true),
          ],
        ),
      ),
    );
  }
}
