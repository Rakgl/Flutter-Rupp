import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/bottom_action_button.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/date_input_field_widget.dart';
import 'package:flutter_super_aslan_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:intl/intl.dart';

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
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final GlobalKey _pickerAnchorKey = GlobalKey();
  final GlobalKey _startDateInputKey = GlobalKey();
  final GlobalKey _endDateInputKey = GlobalKey();

  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _draftStartDate;
  DateTime? _draftEndDate;
  bool _showStartPicker = false;
  bool _showEndPicker = false;

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

  void _togglePicker({required bool isStartDate}) {
    FocusScope.of(context).unfocus();
    setState(() {
      if (isStartDate) {
        _showStartPicker = !_showStartPicker;
        _showEndPicker = false;
        if (_showStartPicker) {
          _draftStartDate = _startDate ?? DateTime.now();
        }
      } else {
        _showEndPicker = !_showEndPicker;
        _showStartPicker = false;
        if (_showEndPicker) {
          _draftEndDate = _endDate ?? _startDate ?? DateTime.now();
        }
      }
    });

    if (_showStartPicker || _showEndPicker) {
      _scrollToPicker();
    }
  }

  void _applyDate(DateTime picked, {required bool isStartDate}) {
    setState(() {
      if (isStartDate) {
        _startDate = picked;
        _startDateController.text = _dateFormat.format(picked);
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
          _endDateController.clear();
        }
        _draftStartDate = picked;
      } else {
        _endDate = picked;
        _endDateController.text = _dateFormat.format(picked);
        _draftEndDate = picked;
      }
      _showStartPicker = false;
      _showEndPicker = false;
    });
  }

  void _cancelPicker() {
    setState(() {
      _showStartPicker = false;
      _showEndPicker = false;
    });
  }

  void _hidePickersIfVisible() {
    if (!_showStartPicker && !_showEndPicker) {
      return;
    }
    setState(() {
      _showStartPicker = false;
      _showEndPicker = false;
    });
  }

  void _handleTapOutside(Offset position) {
    if (!_showStartPicker && !_showEndPicker) {
      return;
    }

    final pickerContext = _pickerAnchorKey.currentContext;
    final startInputContext = _startDateInputKey.currentContext;
    final endInputContext = _endDateInputKey.currentContext;
    if (_isPointInsideContext(position, pickerContext) ||
        _isPointInsideContext(position, startInputContext) ||
        _isPointInsideContext(position, endInputContext)) {
      return;
    }

    _hidePickersIfVisible();
  }

  bool _isPointInsideContext(Offset position, BuildContext? context) {
    if (context == null) {
      return false;
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) {
      return false;
    }

    final box = renderObject;
    final topLeft = box.localToGlobal(Offset.zero);
    final rect = topLeft & box.size;
    return rect.contains(position);
  }

  void _scrollToPicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _ensurePickerVisible();
      Future.delayed(const Duration(milliseconds: 220), _ensurePickerVisible);
    });
  }

  Future<void> _ensurePickerVisible() async {
    final context = _pickerAnchorKey.currentContext;
    if (context == null || !_scrollController.hasClients) {
      return;
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) {
      return;
    }

    final box = renderObject;
    final boxTop = box.localToGlobal(Offset.zero).dy;
    final boxBottom = box.localToGlobal(Offset(0, box.size.height)).dy;
    final mediaQuery = MediaQuery.of(context);
    final minVisibleY = mediaQuery.padding.top + 8;
    const extraBottomPadding = 35.0;
    final maxVisibleY =
        mediaQuery.size.height -
        mediaQuery.padding.bottom -
        8 -
        extraBottomPadding;

    var targetOffset = _scrollController.offset;
    if (boxBottom > maxVisibleY) {
      targetOffset += boxBottom - maxVisibleY;
    } else if (boxTop < minVisibleY) {
      targetOffset -= minVisibleY - boxTop;
    }

    if ((targetOffset - _scrollController.offset).abs() < 1) {
      return;
    }

    final position = _scrollController.position;
    final clampedOffset = targetOffset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    await _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _companyController.dispose();
    _policyController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
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
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => _handleTapOutside(details.globalPosition),
              child: SingleChildScrollView(
                controller: _scrollController,
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
                          'Insurance Information',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
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
                        onTap: _hidePickersIfVisible,
                      ),
                      const _FieldLabel(text: 'Policy Number *'),
                      TextFormFieldWidget(
                        controller: _policyController,
                        labelText: 'Enter your policy number',
                        fillColor: AppColors.white,
                        showBorder: true,
                        enabledBorderColor: AppColors.inputFocused,
                        onTap: _hidePickersIfVisible,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FieldLabel(text: 'Start Date *'),
                                DateInputFieldWidget(
                                  key: _startDateInputKey,
                                  controller: _startDateController,
                                  labelText: 'mm/dd/yyyy',
                                  isActive: _showStartPicker,
                                  inactiveBorderColor: AppColors.inputFocused,
                                  onTap: () => _togglePicker(isStartDate: true),
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
                                DateInputFieldWidget(
                                  key: _endDateInputKey,
                                  controller: _endDateController,
                                  labelText: 'mm/dd/yyyy',
                                  isActive: _showEndPicker,
                                  inactiveBorderColor: AppColors.inputFocused,
                                  onTap: () => _togglePicker(isStartDate: false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _InlineDatePicker(
                        key: _pickerAnchorKey,
                        isVisible: _showStartPicker || _showEndPicker,
                        selectedDate: _showStartPicker
                            ? (_draftStartDate ?? _startDate ?? DateTime.now())
                            : (_draftEndDate ??
                                  _endDate ??
                                  _startDate ??
                                  DateTime.now()),
                        firstDate: _showStartPicker
                            ? DateTime(2000)
                            : (_startDate ?? DateTime(2000)),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) => setState(() {
                          if (_showStartPicker) {
                            _draftStartDate = date;
                          } else {
                            _draftEndDate = date;
                          }
                        }),
                        onCancel: _cancelPicker,
                        onApply: () => _applyDate(
                          _showStartPicker
                              ? (_draftStartDate ??
                                    _startDate ??
                                    DateTime.now())
                              : (_draftEndDate ??
                                    _endDate ??
                                    _startDate ??
                                    DateTime.now()),
                          isStartDate: _showStartPicker,
                        ),
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
                        onPressed: () {},
                        horizontalPadding: 0,
                      ),
                    ],
                  ),
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

class _InlineDatePicker extends StatelessWidget {
  const _InlineDatePicker({
    super.key,
    required this.isVisible,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    required this.onCancel,
    required this.onApply,
  });

  final bool isVisible;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onCancel;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
      child: isVisible
          ? Container(
              key: const ValueKey('inline-date-picker'),
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputFocused),
              ),
              child: Column(
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.92,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: AppColors.primaryColor,
                          ),
                          datePickerTheme: DatePickerThemeData(
                            todayForegroundColor:
                                WidgetStateProperty.resolveWith(
                                  (states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColors.white;
                                    }
                                    return AppColors.primaryColor;
                                  },
                                ),
                            todayBorder: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                            dayForegroundColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.white;
                                }
                                return null;
                              },
                            ),
                            dayBackgroundColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.primaryColor;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          onDateChanged: onDateChanged,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.eerieBlack,
                            side: const BorderSide(
                              color: AppColors.brightGrey,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onApply,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.confirmedColor,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(
              key: ValueKey('inline-date-picker-hidden'),
            ),
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
