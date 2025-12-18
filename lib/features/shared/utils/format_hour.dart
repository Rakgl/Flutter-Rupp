import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatBusinessHours(String opening, String closing) {
  final openTime = TimeOfDay(
    hour: int.parse(opening.split(":")[0]),
    minute: int.parse(opening.split(":")[1]),
  );
  final closeTime = TimeOfDay(
    hour: int.parse(closing.split(":")[0]),
    minute: int.parse(closing.split(":")[1]),
  );

  String format(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  return '${format(openTime)} - ${format(closeTime)}';
}

String formatHourMinute(String timeString) {
  final timeParts = timeString.split(':');
  if (timeParts.length < 2) return timeString;
  final hour = int.parse(timeParts[0]);
  final minute = timeParts[1];
  final period = hour >= 12 ? 'PM' : 'AM';

  final formattedHour = hour % 12;
  if (formattedHour == 0) {
    return '12:$minute $period';
  }
  return '${formattedHour.toString().padLeft(2, '0')}:$minute $period';
}

String formatDate(String inputDate) {
  final dateTime = DateTime.parse(inputDate);
  final formattedDate = DateFormat('EEE, dd MMMM yyyy').format(dateTime);
  return formattedDate;
}

String formatDateTime(DateTime inputDate) {
  // Convert to local time if necessary
  final localDateTime = inputDate.toLocal();
  final formattedDate = DateFormat('EEE, dd MMMM yyyy').format(localDateTime);
  return formattedDate;
}

// convert from "2025-08-13T05:30:00.000000Z to 12:30 AM 
String formatTime(DateTime inputTime) {

  // to local time
  final dateTime = inputTime.toLocal();

  final formattedTime = DateFormat('hh:mm a').format(dateTime);
  return formattedTime;
}


String formatDateTimeString(String inputDateTime) {
  // FIX: Use a pattern that matches the full input string.
  final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  // Parse the input string into a DateTime object.
  final parsedDateTime = inputFormat.parse(inputDateTime);

  // The output formatting remains the same.
  final outputFormat = DateFormat('hh:mm a');

  // Format the DateTime object into the final string.
  final formattedTime = outputFormat.format(parsedDateTime);

  return formattedTime;
}
