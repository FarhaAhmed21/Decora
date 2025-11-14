import 'package:intl/intl.dart';

String addDays(String dateString, int n) {
  final DateFormat format = DateFormat('dd MMM, yyyy');
  final DateTime parsedDate = format.parse(dateString);
  final DateTime newDate = parsedDate.add(Duration(days: n));
  return format.format(newDate);
}
