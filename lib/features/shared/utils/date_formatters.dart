import 'package:intl/intl.dart';

/// Formats a DateTime object into 'yyyy-MM-dd' format for API calls.
String toApiDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

/// Formats a date string like '2025-08-06 16:33:34.418407' to '2025-08-06'.
String formatDateString(String dateString) {
  // A simple way if the format is always consistent.
  if (dateString.contains(' ')) {
    return dateString.split(' ')[0];
  }

  // A more robust way using DateTime parsing.
  try {
    final dateTime = DateTime.parse(dateString);
    return toApiDate(dateTime);
  } catch (e) {
    // Handle parsing error, maybe return the original string or a default.
    return dateString;
  }
}

/// Formats a DateTime object into a
