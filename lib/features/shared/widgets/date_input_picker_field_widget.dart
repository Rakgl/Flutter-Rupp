import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_methgo_app/features/shared/widgets/text_form_field_widget.dart';
import 'package:intl/intl.dart';

class DateInputPickerFieldWidget extends StatefulWidget {
  DateInputPickerFieldWidget({
    required this.controller,
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.selectedDate,
    this.selectedDateNotifier,
    this.onDateSelected,
    this.scrollController,
    this.calendarTopInset = 380,
    this.calendarHorizontalInset = 23.5,
    this.calendarVerticalGap = -4,
    this.hintText = 'MM/DD/YYYY',
    this.linkedDate,
    this.linkedController,
    this.linkedDateNotifier,
    this.onLinkedDateChanged,
    this.clearLinkedIfBeforeSelected = true,
    this.minDateListenable,
    DateFormat? dateFormatter,
  }) : dateFormatter = dateFormatter ?? DateFormat('MM/dd/yyyy');

  final TextEditingController controller;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  final ValueNotifier<DateTime?>? selectedDateNotifier;
  final ValueChanged<DateTime?>? onDateSelected;
  final DateFormat dateFormatter;
  final ScrollController? scrollController;
  final double calendarTopInset;
  final double calendarHorizontalInset;
  final double calendarVerticalGap;
  final String hintText;
  final DateTime? linkedDate;
  final TextEditingController? linkedController;
  final ValueNotifier<DateTime?>? linkedDateNotifier;
  final ValueChanged<DateTime?>? onLinkedDateChanged;
  final bool clearLinkedIfBeforeSelected;
  final ValueListenable<DateTime?>? minDateListenable;

  @override
  State<DateInputPickerFieldWidget> createState() =>
      _DateInputPickerFieldWidgetState();
}

class _DateInputPickerFieldWidgetState
    extends State<DateInputPickerFieldWidget> {
  final GlobalKey _fieldKey = GlobalKey();
  final GlobalKey _calendarKey = GlobalKey();
  DateTime? _selectedDate;
  DateTime? _pendingDate;
  DateTime? _minDateOverride;
  bool _isOpen = false;
  bool _suppressScrollClose = false;
  OverlayEntry? _overlayEntry;
  ScrollController? _observedScrollController;
  ValueNotifier<DateTime?>? _observedSelectedDateNotifier;
  ValueListenable<DateTime?>? _observedMinDateListenable;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDateNotifier?.value ?? widget.selectedDate;
    _minDateOverride = widget.minDateListenable?.value;
    _attachScrollController(widget.scrollController);
    _attachSelectedDateNotifier(widget.selectedDateNotifier);
    _attachMinDateListenable(widget.minDateListenable);
  }

  @override
  void didUpdateWidget(covariant DateInputPickerFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDateNotifier != oldWidget.selectedDateNotifier) {
      _detachSelectedDateNotifier(oldWidget.selectedDateNotifier);
      _attachSelectedDateNotifier(widget.selectedDateNotifier);
    }
    if (widget.minDateListenable != oldWidget.minDateListenable) {
      _detachMinDateListenable(oldWidget.minDateListenable);
      _attachMinDateListenable(widget.minDateListenable);
    }
    if (widget.selectedDate != oldWidget.selectedDate &&
        widget.selectedDateNotifier == null) {
      _selectedDate = widget.selectedDate;
    }
    if (widget.scrollController != oldWidget.scrollController) {
      _detachScrollController(oldWidget.scrollController);
      _attachScrollController(widget.scrollController);
    }
  }

  Future<void> _scrollToField() async {
    final scrollController = widget.scrollController;
    if (scrollController == null) {
      return;
    }
    final context = _fieldKey.currentContext;
    if (context == null) {
      return;
    }
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }
    final position = renderBox.localToGlobal(Offset.zero);
    final topPadding = MediaQuery.of(context).padding.top;
    final targetOffset =
        scrollController.offset +
        position.dy -
        topPadding -
        widget.calendarTopInset;
    _suppressScrollClose = true;
    await scrollController.animateTo(
      targetOffset.clamp(0, scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
    _suppressScrollClose = false;
  }

  void _ensurePendingDate() {
    final baseDate = _selectedDate ?? DateTime.now();
    _pendingDate ??= DateUtils.dateOnly(baseDate);
  }

  void _commitPendingDate() {
    final date = DateUtils.dateOnly(
      _pendingDate ?? _selectedDate ?? DateTime.now(),
    );
    widget.controller.text = widget.dateFormatter.format(date);
    _selectedDate = date;
    widget.selectedDateNotifier?.value = date;
    widget.onDateSelected?.call(date);
    _maybeClearLinkedDate(date);
    _pendingDate = null;
    _closeCalendar();
  }

  void _discardPendingDate() {
    _pendingDate = null;
    _closeCalendar();
  }

  void _handleSelectedDateChanged() {
    setState(() {
      _selectedDate = _observedSelectedDateNotifier?.value;
    });
  }

  void _handleMinDateChanged() {
    setState(() {
      _minDateOverride = _observedMinDateListenable?.value;
    });
  }

  void _maybeClearLinkedDate(DateTime? date) {
    if (!widget.clearLinkedIfBeforeSelected) {
      return;
    }
    final linkedDate = widget.linkedDateNotifier?.value ?? widget.linkedDate;
    if (date == null || linkedDate == null) {
      return;
    }
    if (!linkedDate.isBefore(date)) {
      return;
    }
    widget.linkedController?.clear();
    widget.linkedDateNotifier?.value = null;
    widget.onLinkedDateChanged?.call(null);
  }

  Widget _buildCalendarCard() {
    _ensurePendingDate();
    final today = DateUtils.dateOnly(DateTime.now());
    final effectiveFirstDate = _effectiveFirstDate();
    final effectiveLastDate = widget.lastDate;
    final rawDisplayDate = _pendingDate ?? _selectedDate ?? today;
    final displayDate = _clampDate(
      DateUtils.dateOnly(rawDisplayDate),
      effectiveFirstDate,
      effectiveLastDate,
    );
    final isTodaySelected = DateUtils.isSameDay(
      _pendingDate ?? _selectedDate,
      today,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputFocused),
      ),
      child: Theme(
        data: _datePickerTheme(
          Theme.of(context),
          isTodaySelected: isTodaySelected,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalendarDatePicker(
              key: ValueKey(
                '${widget.controller.hashCode}_${_pendingDate?.millisecondsSinceEpoch ?? _selectedDate?.millisecondsSinceEpoch ?? 0}',
              ),
              initialDate: DateUtils.dateOnly(displayDate),
              currentDate: today,
              firstDate: effectiveFirstDate,
              lastDate: effectiveLastDate,
              onDateChanged: (date) {
                setState(() {
                  _pendingDate = DateUtils.dateOnly(date);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _discardPendingDate,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.liver,
                        side: const BorderSide(
                          color: AppColors.inputFocused,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _commitPendingDate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ThemeData _datePickerTheme(
    ThemeData baseTheme, {
    required bool isTodaySelected,
  }) {
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.primaryColor,
        onPrimary: AppColors.white,
        onSurface: AppColors.eerieBlack,
        surface: AppColors.white,
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        headerBackgroundColor: AppColors.white,
        headerForegroundColor: AppColors.eerieBlack,
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.liver.withAlpha(120);
            }
            return states.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.eerieBlack;
          },
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.transparent;
            }
            return states.contains(WidgetState.selected)
                ? AppColors.primaryColor
                : AppColors.transparent;
          },
        ),
        todayForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            }
            return AppColors.primaryColor;
          },
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }
            return AppColors.transparent;
          },
        ),
        todayBorder: const BorderSide(
          color: AppColors.primaryColor,
        ),
        dayOverlayColor: WidgetStateProperty.all(
          AppColors.primaryColor.withAlpha(24),
        ),
        confirmButtonStyle: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.liver,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.inputFocused),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: baseTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _fieldKey,
      child: TextFormFieldWidget(
        controller: widget.controller,
        labelText: widget.hintText,
        fillColor: AppColors.white,
        showBorder: true,
        enabledBorderColor: AppColors.inputFocused,
        readOnly: true,
        suffixIcon: Icons.calendar_month_outlined,
        onTap: _isOpen ? _closeCalendar : _openCalendar,
      ),
    );
  }

  void _closeCalendar() {
    if (!_isOpen) {
      return;
    }
    _removeOverlay();
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  Future<void> _openCalendar() async {
    if (_isOpen) {
      return;
    }
    setState(() {
      _pendingDate = null;
      _isOpen = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      await _scrollToField();
      if (!mounted || !_isOpen) {
        return;
      }
      _insertOverlay();
    });
  }

  void _insertOverlay() {
    if (_overlayEntry != null) {
      return;
    }
    final fieldContext = _fieldKey.currentContext;
    if (fieldContext == null) {
      return;
    }
    final renderBox = fieldContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return;
    }
    final overlay = Overlay.of(context, rootOverlay: true);
    final position = renderBox.localToGlobal(Offset.zero);
    final mediaQuery = MediaQuery.of(context);
    final width =
        (mediaQuery.size.width -
                mediaQuery.padding.horizontal -
                (widget.calendarHorizontalInset * 2))
            .clamp(0.0, mediaQuery.size.width);
    final left = mediaQuery.padding.left + widget.calendarHorizontalInset;
    final top =
        position.dy + renderBox.size.height + widget.calendarVerticalGap;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  if (_isPointerInsideCalendar(event.position)) {
                    return;
                  }
                  _closeCalendar();
                },
                child: const SizedBox.shrink(),
              ),
            ),
            Positioned(
              top: top,
              left: left,
              width: width,
              child: Material(
                color: Colors.transparent,
                child: KeyedSubtree(
                  key: _calendarKey,
                  child: _buildCalendarCard(),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
  }

  bool _isPointerInsideCalendar(Offset position) {
    final calendarContext = _calendarKey.currentContext;
    if (calendarContext == null) {
      return false;
    }
    final renderBox = calendarContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return false;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final rect = topLeft & renderBox.size;
    return rect.contains(position);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleScroll() {
    if (_isOpen && !_suppressScrollClose) {
      _closeCalendar();
    }
  }

  void _attachScrollController(ScrollController? controller) {
    _observedScrollController = controller;
    controller?.addListener(_handleScroll);
  }

  void _detachScrollController(ScrollController? controller) {
    controller?.removeListener(_handleScroll);
    if (_observedScrollController == controller) {
      _observedScrollController = null;
    }
  }

  void _attachSelectedDateNotifier(ValueNotifier<DateTime?>? notifier) {
    _observedSelectedDateNotifier = notifier;
    notifier?.addListener(_handleSelectedDateChanged);
  }

  void _detachSelectedDateNotifier(ValueNotifier<DateTime?>? notifier) {
    notifier?.removeListener(_handleSelectedDateChanged);
    if (_observedSelectedDateNotifier == notifier) {
      _observedSelectedDateNotifier = null;
    }
  }

  void _attachMinDateListenable(ValueListenable<DateTime?>? listenable) {
    _observedMinDateListenable = listenable;
    listenable?.addListener(_handleMinDateChanged);
  }

  void _detachMinDateListenable(ValueListenable<DateTime?>? listenable) {
    listenable?.removeListener(_handleMinDateChanged);
    if (_observedMinDateListenable == listenable) {
      _observedMinDateListenable = null;
    }
  }

  DateTime _effectiveFirstDate() {
    final minDate = _minDateOverride ?? widget.firstDate;
    if (minDate.isAfter(widget.lastDate)) {
      return widget.lastDate;
    }
    return minDate;
  }

  DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
    if (value.isBefore(min)) {
      return min;
    }
    if (value.isAfter(max)) {
      return max;
    }
    return value;
  }

  @override
  void dispose() {
    _removeOverlay();
    _detachScrollController(_observedScrollController);
    _detachSelectedDateNotifier(_observedSelectedDateNotifier);
    _detachMinDateListenable(_observedMinDateListenable);
    super.dispose();
  }
}
