import 'package:intl/intl.dart';

String timeAgo(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day); // Midnight today
  DateTime yesterday = today.subtract(const Duration(days: 1)); // Midnight yesterday

  if (dateTime.isAfter(today)) {
    // ✅ Today: Show time (e.g., "1:09 PM")
    return DateFormat.jm().format(dateTime);
  } else if (dateTime.isAfter(yesterday)) {
    // ✅ Yesterday: Show "Yesterday"
    return "Yesterday";
  } else {
    // ✅ Older: Show date (e.g., "10/03/24")
    return DateFormat('dd/MM/yy').format(dateTime);
  }
}

