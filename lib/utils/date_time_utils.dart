import 'package:intl/intl.dart';

class DateTimeUtils {
  static String removeTimeZone(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      DateTime localDateTime = dateTime.toLocal();
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.format(localDateTime);
    } catch (e) {
      return "";
    }
  }
}
