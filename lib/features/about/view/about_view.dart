import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_methgo_app/features/shared/widgets/app_header_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const String dogImg = "assets/images/rakrak.png";
  static const String ferryImg = "assets/images/ferry.png";

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.url,
  });

  final String label;
  final Color color;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (!launched) {
            await launchUrl(uri, mode: LaunchMode.platformDefault);
          }
        } catch (e) {
          debugPrint('Could not launch $url: $e');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutPageState extends State<AboutPage> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SettingsCubit>();
    if (cubit.state.status != SettingsStatus.success && cubit.state.status != SettingsStatus.loading) {
      unawaited(cubit.fetchSettings());
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  void _initMap(String lat, String lng) {
    if (_webViewController != null) return;
    
    final mapHtml = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin: 0; padding: 0; background-color: #f3f3f3; }
            iframe { width: 100%; height: 100vh; border: 0; }
          </style>
        </head>
        <body>
          <iframe 
            src="https://maps.google.com/maps?q=$lat,$lng&z=15&output=embed" 
            allowfullscreen>
          </iframe>
        </body>
      </html>
    ''';

    final controller = WebViewController();
    unawaited(controller.setJavaScriptMode(JavaScriptMode.unrestricted));
    unawaited(controller.setBackgroundColor(const Color(0x00000000)));
    unawaited(controller.loadHtmlString(mapHtml));
    _webViewController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state.status == SettingsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final aboutUs = state.settingsData?.aboutUs;
            final description = aboutUs?.description ??
                "Pet Shop is a pet shop and animal shelter that have been dedicated for years into taking care of animals and turn then into a good lovely pet, For animal lover who interested and in need of a compainion.";
            final footerNote = aboutUs?.footerNote ?? "Have a great day\nfrom Ferry";
            final socialMedia = aboutUs?.socialMedia;

            if (aboutUs?.location != null && aboutUs!.location!.latitude != null && aboutUs.location!.longitude != null) {
              _initMap(aboutUs.location!.latitude!, aboutUs.location!.longitude!);
            }

            return SingleChildScrollView(
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
                        Expanded(
                          flex: 3,
                          child: Text(
                            description,
                            style: const TextStyle(
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
                            AboutPage.dogImg,
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

                    const SizedBox(height: 20),

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

                    // Map location webview
                    if (_webViewController != null)
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF6FA0FF), width: 1.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: WebViewWidget(controller: _webViewController!),
                        ),
                      ),

                    if (socialMedia != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1.3,
                        color: const Color(0xFF6FA0FF),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Follow Us",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A7BD6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (socialMedia.facebook != null)
                            _SocialButton(
                              label: "Facebook",
                              color: const Color(0xFF1877F2),
                              icon: Icons.facebook,
                              url: socialMedia.facebook!,
                            ),
                          if (socialMedia.instagram != null) ...[
                            const SizedBox(width: 12),
                            _SocialButton(
                              label: "Instagram",
                              color: const Color(0xFFE4405F),
                              icon: Icons.camera_alt_outlined,
                              url: socialMedia.instagram!,
                            ),
                          ],
                          if (socialMedia.telegram != null) ...[
                            const SizedBox(width: 12),
                            _SocialButton(
                              label: "Telegram",
                              color: const Color(0xFF229ED9),
                              icon: Icons.send_outlined,
                              url: socialMedia.telegram!,
                            ),
                          ],
                        ],
                      ),
                    ],

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            footerNote,
                            style: const TextStyle(
                              fontSize: 28,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4A7BD6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Image.asset(
                          AboutPage.ferryImg,
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
