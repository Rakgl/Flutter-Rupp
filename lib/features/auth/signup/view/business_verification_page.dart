import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/auth/signup/view/payment_setup_page.dart';
import 'package:flutter_methgo_app/features/shared/widgets/bottom_action_button.dart';
import 'package:go_router/go_router.dart';

class BusinessVerificationPage extends StatelessWidget {
  const BusinessVerificationPage({super.key});

  static const String path = '/business-verification';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.transparent,
      body: _BusinessVerificationBody(),
    );
  }
}

class _BusinessVerificationBody extends StatefulWidget {
  const _BusinessVerificationBody();

  @override
  State<_BusinessVerificationBody> createState() =>
      _BusinessVerificationBodyState();
}

class _BusinessVerificationBodyState extends State<_BusinessVerificationBody> {
  final _businessNumberController = TextEditingController();
  String? _businessLicenseFileName;
  String? _registrationProofFileName;

  bool get _isFormComplete =>
      _businessNumberController.text.trim().isNotEmpty &&
      _businessLicenseFileName != null &&
      _registrationProofFileName != null;

  @override
  void dispose() {
    _businessNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.5;

    return Stack(
      children: [
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(0, -115),
            child: Assets.img.backgroundImage.image(
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: whiteBgHeight,
          child: Container(color: AppColors.white),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _HeroCard(),
                  const SizedBox(height: 16),
                  const _StatusBanner(),
                  const SizedBox(height: 16),
                  _BusinessNumberCard(
                    controller: _businessNumberController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  _UploadCard(
                    businessLicenseFileName: _businessLicenseFileName,
                    registrationProofFileName: _registrationProofFileName,
                    onBusinessLicenseSelected: (fileName) => setState(() {
                      _businessLicenseFileName = fileName;
                    }),
                    onRegistrationProofSelected: (fileName) => setState(() {
                      _registrationProofFileName = fileName;
                    }),
                  ),
                  const SizedBox(height: 16),
                  const _SecurityCard(),
                  const SizedBox(height: 12),
                  BottomActionButton(
                    title: 'Continue Verification',
                    onPressed: _isFormComplete
                        ? () => context.go(PaymentSetupPage.path)
                        : null,
                    horizontalPadding: 0,
                  ),
                  const SizedBox(height: 12),
                  const _FooterHelp(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 2),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Business License Verification',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.eerieBlack,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              'To ensure legitimacy, safety, and regulatory compliance on the '
              'SuperAslan platform, all service providers must verify their '
              'business registration before becoming active.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.paleSky,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_bottom,
              color: AppColors.trendNegative,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Pending',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.redWine,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Complete all fields to proceed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.trendNegative,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BusinessNumberCard extends StatelessWidget {
  const _BusinessNumberCard({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Registration Number',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.eerieBlack,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your 9-digit SIREN number',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.paleSky,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputFocused),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: '123 456 789',
                      hintStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(
                            color: AppColors.pastelGrey,
                          ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.eerieBlack,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Verify',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.businessLicenseFileName,
    required this.registrationProofFileName,
    required this.onBusinessLicenseSelected,
    required this.onRegistrationProofSelected,
  });

  final String? businessLicenseFileName;
  final String? registrationProofFileName;
  final ValueChanged<String> onBusinessLicenseSelected;
  final ValueChanged<String> onRegistrationProofSelected;

  Future<void> _pickDocument({
    required void Function(String fileName) onSelected,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    final fileName = result?.files.single.name;
    if (fileName == null) {
      return;
    }

    onSelected(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(title: 'Upload Required Documents'),
          const SizedBox(height: 12),
          _UploadTile(
            icon: Assets.svg.businessLicense.svg(
              width: 26,
              height: 26,
              color: AppColors.confirmedColor,
            ),
            title: 'Business License Certificate',
            subtitle: 'PDF, JPG or PNG (Max 5MB)',
            fileName: businessLicenseFileName,
            onTap: () async {
              await _pickDocument(
                onSelected: onBusinessLicenseSelected,
              );
            },
          ),
          const SizedBox(height: 12),
          _UploadTile(
            icon: Assets.svg.registrationProof.svg(
              width: 26,
              height: 26,
              color: AppColors.confirmedColor,
            ),
            title: 'Registration Proof',
            subtitle: 'Supporting documents (Max 5MB)',
            fileName: registrationProofFileName,
            onTap: () async {
              await _pickDocument(
                onSelected: onRegistrationProofSelected,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.blueLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.blueLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Assets.svg.lock.svg(
                width: 18,
                height: 18,
                color: AppColors.confirmedColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Document Handling',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.eerieBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All documents are encrypted using 256-bit SSL encryption and '
                  'stored securely in compliance with GDPR regulations. Your '
                  'information is never shared with third parties.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterHelp extends StatelessWidget {
  const _FooterHelp();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.help_outline,
            size: 16,
            color: AppColors.redWine,
          ),
          const SizedBox(width: 6),
          Text(
            'Need help verifying your license?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.redWine,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brightGrey),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.eerieBlack,
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.fileName,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _DashedBorder(
        radius: 18,
        color: AppColors.inputFocused,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.surface2,
                  shape: BoxShape.circle,
                ),
                child: Center(child: icon),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.eerieBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.paleSky,
                ),
              ),
              if (fileName != null) ...[
                const SizedBox(height: 8),
                Text(
                  fileName!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputEnabled,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 16,
                        color: AppColors.liver,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Choose File',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.liver,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        radius: radius,
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: AppColors.white,
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.radius,
    required this.color,
  });

  static const double _strokeWidth = 1;
  static const double _dashLength = 4;
  static const double _dashGap = 4;

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashLength;
        final segment = metric.extractPath(
          distance,
          next.clamp(0.0, metric.length),
        );
        canvas.drawPath(segment, paint);
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
