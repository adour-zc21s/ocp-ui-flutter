import 'package:intl/intl.dart';

class DateFormatter {
  static String formatShort(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(rawDate);
      return DateFormat('yyMMdd HH:mm').format(dt);
    } catch (_) {
      return rawDate;
    }
  }
}
