import 'package:intl/intl.dart';

String formatToIndonesiaCurrency(int value) {
  return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
      .format(value);
}
