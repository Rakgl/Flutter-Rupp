import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/date_input_picker_field_widget.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:flutter_super_aslan_app/features/auth/signup/view/phone_verification_page.dart';
import 'package:go_router/go_router.dart';

class InsuranceInformationPage extends StatelessWidget {
  const InsuranceInformationPage({super.key});

  static const String path = '/insurance-information';

  @override
  Widget build(BuildContext context) {
    return const _InsuranceInformationBody();
  }
}

class _InsuranceInformationBody extends StatefulWidget {
  const _InsuranceInformationBody();

  @override
  State<_InsuranceInformationBody> createState() =>
      _InsuranceInformationBodyState();
}

class _InsuranceInformationBodyState extends State<_InsuranceInformationBody> {
  final _scrollController = ScrollController();
  final _companyController = TextEditingController();
  final _policyController = TextEditingController();
  final _dobController = TextEditingController();
  final _marriedDateController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final ValueNotifier<DateTime?> _startDateNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime?> _endDateNotifier = ValueNotifier(null);

  String? _certificateFileName;
  String? _coverageFileName;

  final _checklist = [false, false, false, false];

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
  void dispose() {
    _scrollController.dispose();
    _companyController.dispose();
    _policyController.dispose();
    _dobController.dispose();
    _marriedDateController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startDateNotifier.dispose();
    _endDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final fullHeight = view.physicalSize.height / view.devicePixelRatio;
    final whiteBgHeight = fullHeight * 0.5;
    final today = DateUtils.dateOnly(DateTime.now());

    return Stack(
      fit: StackFit.expand,
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
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
                        'Insurance Information',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.eerieBlack,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Professional liability insurance protects both you '
                      "and your clients. It's mandatory for all service "
                      'providers on SuperAslan to ensure quality and safety '
                      'standards.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.paleSky,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _AcceptedInsuranceCard(),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'Insurance Details'),
                    const SizedBox(height: 10),
                    const _FieldLabel(text: 'Insurance Company Name *'),
                    TextFormFieldWidget(
                      controller: _companyController,
                      labelText: 'e.g., State Farm, Allstate',
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                    ),
                    const _FieldLabel(text: 'Policy Number *'),
                    TextFormFieldWidget(
                      controller: _policyController,
                      labelText: 'Enter your policy number',
                      fillColor: AppColors.white,
                      showBorder: true,
                      enabledBorderColor: AppColors.inputFocused,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'Date of Birth *'),
                              DateInputPickerFieldWidget(
                                controller: _dobController,
                                selectedDate: null,
                                firstDate: DateTime(1900),
                                lastDate: today,
                                onDateSelected: (_) {},
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'Married Date'),
                              DateInputPickerFieldWidget(
                                controller: _marriedDateController,
                                selectedDate: null,
                                firstDate: DateTime(1900),
                                lastDate: today,
                                onDateSelected: (_) {},
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'Start Date *'),
                              DateInputPickerFieldWidget(
                                controller: _startDateController,
                                selectedDateNotifier: _startDateNotifier,
                                firstDate: DateTime(2000),
                                lastDate:
                                    today.add(const Duration(days: 3650)),
                                linkedController: _endDateController,
                                linkedDateNotifier: _endDateNotifier,
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'End Date *'),
                              DateInputPickerFieldWidget(
                                controller: _endDateController,
                                selectedDateNotifier: _endDateNotifier,
                                firstDate: DateTime(2000),
                                minDateListenable: _startDateNotifier,
                                lastDate:
                                    today.add(const Duration(days: 3650)),
                                scrollController: _scrollController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _SectionTitle(title: 'Upload Documents'),
                    const SizedBox(height: 10),
                    const _FieldLabel(text: 'Insurance Certificate *'),
                    _UploadTile(
                      title: 'Tap to upload certificate',
                      subtitle: 'PDF, JPG, PNG (Max 5MB)',
                      icon: Icons.cloud_upload_outlined,
                      fileName: _certificateFileName,
                      onTap: () => _pickDocument(
                        onSelected: (fileName) => setState(() {
                          _certificateFileName = fileName;
                        }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel(text: 'Proof of Coverage'),
                    _UploadTile(
                      title: 'Additional coverage documents',
                      subtitle: 'Optional - PDF, JPG, PNG',
                      icon: Icons.description_outlined,
                      fileName: _coverageFileName,
                      onTap: () => _pickDocument(
                        onSelected: (fileName) => setState(() {
                          _coverageFileName = fileName;
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _StatusBanner(),
                    const SizedBox(height: 14),
                    const _RecommendationCard(),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'Policy Validation Checklist'),
                    const SizedBox(height: 8),
                    _ChecklistItem(
                      label: 'Policy is currently active',
                      value: _checklist[0],
                      onChanged: (value) => setState(() {
                        _checklist[0] = value;
                      }),
                    ),
                    _ChecklistItem(
                      label: 'Minimum coverage amount met',
                      value: _checklist[1],
                      onChanged: (value) => setState(() {
                        _checklist[1] = value;
                      }),
                    ),
                    _ChecklistItem(
                      label: 'Certificate matches policy details',
                      value: _checklist[2],
                      onChanged: (value) => setState(() {
                        _checklist[2] = value;
                      }),
                    ),
                    _ChecklistItem(
                      label: 'Documents are legible and complete',
                      value: _checklist[3],
                      onChanged: (value) => setState(() {
                        _checklist[3] = value;
                      }),
                    ),
                    const SizedBox(height: 8),
                    const _SecurityNote(),
                    const SizedBox(height: 14),
                    BottomActionButton(
                      title: 'Verify Payment Account',
                      onPressed: () => context.go(PhoneVerificationPage.path),
                      horizontalPadding: 0,
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

class _AcceptedInsuranceCard extends StatelessWidget {
  const _AcceptedInsuranceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.blueLight.withAlpha(36),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Accepted Insurance Types:'),
          SizedBox(height: 8),
          _AcceptedInsuranceRow(text: 'General Liability Insurance'),
          SizedBox(height: 6),
          _AcceptedInsuranceRow(text: 'Professional Liability Coverage'),
          SizedBox(height: 6),
          _AcceptedInsuranceRow(text: 'Trade-Specific Insurance'),
        ],
      ),
    );
  }
}

class _AcceptedInsuranceRow extends StatelessWidget {
  const _AcceptedInsuranceRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.growthSuccess,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.eerieBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningAccent.withAlpha(31),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.warningAccent.withAlpha(64),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time,
              color: AppColors.warningAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Verification',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.eerieBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Documents will be reviewed within 24 hours',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
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

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.red.shade50.withAlpha(179),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 18,
                color: AppColors.trendNegative,
              ),
              SizedBox(width: 8),
              Text(
                "Don't have insurance?",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.eerieBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We recommend these trusted agencies where you can purchase '
            'professional liability insurance quickly and affordably.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.liver,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.eerieBlack,
              side: const BorderSide(color: AppColors.brightGrey),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('View Recommended Agencies'),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (checked) => onChanged(checked ?? false),
          activeColor: AppColors.confirmedColor,
          checkColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: AppColors.inputFocused),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.liver,
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.lock_outline,
          size: 16,
          color: AppColors.paleSky,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Security & Privacy: Your insurance information is encrypted and '
            'stored securely. We only use this data for verification purposes '
            'and never share it with third parties.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.paleSky,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.fileName,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _DashedBorder(
        radius: 14,
        color: AppColors.inputFocused,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.paleSky,
                size: 34,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.liver,
                  fontWeight: FontWeight.w600,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.liver,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputEnabled,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Choose File',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.liver,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.eerieBlack,
        ),
      ),
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
          next > metric.length ? metric.length : next,
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
