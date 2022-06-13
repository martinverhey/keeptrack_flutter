import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd-MM').format(date);
}

String formatDateFull(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

double makeDouble(dynamic value) {
  return double.parse(value.toString().replaceAll(',', '.'));
}

DateTime makeDate(dynamic value) {
  return DateTime.parse(value.toString());
}
