import 'package:intl/intl.dart';

class DateConverter {
  static String convertDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String convertTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String dateToDay(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String dateToMonth(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  static String fullReadableDate(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }
}
