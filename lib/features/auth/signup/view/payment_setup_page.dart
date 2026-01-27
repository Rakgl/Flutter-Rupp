import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';

class PaymentSetupPage extends StatefulWidget {
  const PaymentSetupPage({super.key});

  static const String path = '/payment-setup';

  @override
  State<PaymentSetupPage> createState() => _PaymentSetupPageState();
}

class _PaymentSetupPageState extends State<PaymentSetupPage> {
  final _fullNameController = TextEditingController();
  final _ibanController = TextEditingController();
  final _routingController = TextEditingController();
  final _billingAddressController = TextEditingController();
  String? _governmentIdFileName;

  final _providers = const [
    _PaymentProvider(
      name: 'Stripe',
      subtitle: 'Express payouts',
      shortLabel: 'S',
      color: AppColors.secondary,
    ),
    _PaymentProvider(
      name: 'Alma',
      subtitle: 'European transfers',
      shortLabel: 'A',
      color: AppColors.growthSuccess,
    ),
  ];

  int _selectedProviderIndex = -1;

  bool get _isFormComplete =>
      _selectedProviderIndex >= 0 &&
      _governmentIdFileName != null &&
      _fullNameController.text.trim().isNotEmpty &&
      _ibanController.text.trim().isNotEmpty &&
      _routingController.text.trim().isNotEmpty &&
      _billingAddressController.text.trim().isNotEmpty;

  Future<void> _pickGovernmentId() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    final fileName = result?.files.single.name;
    if (fileName == null) {
      return;
    }

    setState(() {
      _governmentIdFileName = fileName;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ibanController.dispose();
    _routingController.dispose();
    _billingAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.5;

    return Stack(
      fit: StackFit.expand,
      children: [
        Assets.img.spaceBg.image(fit: BoxFit.cover),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: whiteBgHeight,
          child: Container(color: AppColors.white),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Payment Setup',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.eerieBlack,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To receive payouts securely, we need to verify your '
                      'identity and link a trusted payment method. This '
                      'ensures compliance with financial regulations and '
                      'protects your earnings.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.paleSky,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(),
                    const SizedBox(height: 16),
                    Text(
                      'Choose Payment Provider',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.eerieBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(_providers.length, (index) {
                        final provider = _providers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ProviderTile(
                            provider: provider,
                            isSelected: _selectedProviderIndex == index,
                            onTap: () => setState(() {
                              _selectedProviderIndex = index;
                            }),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    _FieldLabel(text: 'Full Legal Name'),
                    TextFormFieldWidget(
                      controller: _fullNameController,
                      labelText: 'Enter your full name as shown on ID',
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                      onChanged: (_) => setState(() {}),
                    ),
                    _FieldLabel(text: 'IBAN / Account Number'),
                    TextFormFieldWidget(
                      controller: _ibanController,
                      labelText: 'Enter your bank account number',
                      keyboardType: TextInputType.number,
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                      onChanged: (_) => setState(() {}),
                    ),
                    _FieldLabel(text: 'Routing Number'),
                    TextFormFieldWidget(
                      controller: _routingController,
                      labelText: 'Bank routing number (if applicable)',
                      keyboardType: TextInputType.number,
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                      onChanged: (_) => setState(() {}),
                    ),
                    _FieldLabel(text: 'Billing Address'),
                    TextFormField(
                      controller: _billingAddressController,
                      minLines: 2,
                      maxLines: 3,
                      onChanged: (_) => setState(() {}),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: AppFontWeight.medium,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your complete billing address',
                        hintStyle: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(
                              color: AppColors.grey,
                              fontSize: 14,
                              fontWeight: AppFontWeight.medium,
                            ),
                        fillColor: AppColors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputFocused,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputFocused,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(text: 'Identity Verification'),
                    _UploadCard(
                      title: 'Upload Government ID',
                      subtitle: "Passport, driver's license, or national ID",
                      fileName: _governmentIdFileName,
                      onTap: _pickGovernmentId,
                    ),
                    const SizedBox(height: 16),
                    _SecurityNote(),
                    const SizedBox(height: 12),
                    BottomActionButton(
                      title: 'Verify Payment Account',
                      onPressed: _isFormComplete ? () {} : null,
                      horizontalPadding: 0,
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'By continuing, you agree to our payment terms and '
                        'authorize account verification',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.paleSky,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.blueLight.withOpacity(0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Assets.svg.infoCircle.svg(
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'What You Will Need',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.oceanBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const _InfoRow(text: 'Full legal name (as on ID)'),
          const _InfoRow(text: 'Bank account or payment details'),
          const _InfoRow(text: 'Government-issued ID photo'),
          const _InfoRow(text: 'Billing address information'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, bottom: 1),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check,
              size: 14,
              color: AppColors.oceanBlue,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.oceanBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  final _PaymentProvider provider;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.confirmedColor
        : AppColors.brightGrey;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: provider.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  provider.shortLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.eerieBlack,
                    ),
                  ),
                  Text(
                    provider.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.paleSky,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.confirmedColor
                      : AppColors.inputFocused,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: AppColors.confirmedColor,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.eerieBlack,
        ),
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.title,
    required this.subtitle,
    this.fileName,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _DashedBorder(
        radius: 14,
        color: AppColors.inputFocused,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.paleSky,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.liver,
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
              const SizedBox(height: 10),
              if (fileName != null) ...[
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
                const SizedBox(height: 10),
              ],
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Choose File',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
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

class _SecurityNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.green.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Secure & Compliant',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.growthSuccess,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your information is protected with PCI-DSS compliance and '
            'bank-level encryption. We never store sensitive payment details '
            'on our servers.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.liver,
              height: 1.4,
            ),
          ),
        ],
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

class _PaymentProvider {
  const _PaymentProvider({
    required this.name,
    required this.subtitle,
    required this.shortLabel,
    required this.color,
  });

  final String name;
  final String subtitle;
  final String shortLabel;
  final Color color;
}
