import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/app_header_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String dogImg = "assets/images/rakrak.png";
  static const String ferryImg = "assets/images/ferry.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeaderBar(subtitle: "Read our information"),
                const SizedBox(height: 8),

                const Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A7BD6),
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  height: 1.3,
                  color: const Color(0xFF6FA0FF),
                ),

                const SizedBox(height: 28),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        "Methgo is a pet shop and animal shelter that have been dedicated for years into taking care of animals and turn then into a good lovely pet, For animal lover who interested and in need of a compainion.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      // flex: 1,
                      child: Image.asset(
                        dogImg,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 1.3,
                  color: const Color(0xFF6FA0FF),
                ),

                const SizedBox(height: 2),

                const Center(
                  child: Text(
                    "Our location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A7BD6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // location
                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Have a great day\nfrom Ferry",
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4A7BD6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Image.asset(
                      ferryImg,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
