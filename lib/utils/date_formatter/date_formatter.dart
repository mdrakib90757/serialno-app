import 'package:intl/intl.dart';

class DateFormatter {


  static String formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM, yyyy').format(date);
  }


  // today dateTime
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM, yyyy').format(date);
  }


  static String formatApiTimeToDisplayTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "N/A";
    }
    try {
      final utcTime = DateTime.parse(dateString);
      final localTime = utcTime.toLocal();
      return DateFormat('hh:mm a').format(localTime); // 12-hour format with AM/PM
    } catch (e) {
      print("Date format error: $e");
      return "Time Error";
    }
  }
  static String formatForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

}