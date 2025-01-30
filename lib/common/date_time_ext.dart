import 'package:intl/intl.dart';

final _dateFormatJson = DateFormat('yyyy-MM-ddTHH:mm:ss');

extension DateTimeExt on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth => DateTime(year, month + 1).add(const Duration(seconds: -1));

  DateTime get startOfYear => DateTime(year);
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59);

  String formatDate() {
    final dateFormat = DateFormat('dd.MM.yyyy');
    return dateFormat.format(this);
  }

  String formatDateTime() {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
    return dateFormat.format(this);
  }

  String formatDateTimeMin() {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    return dateFormat.format(this);
  }

  bool get isEmpty => this == emptyDate;
  bool get isNotEmpty => this != emptyDate;
}

String formatPeriod(DateTime? dateStart, DateTime? dateEnd) {
  return 'Period Repr';
}

String encodeDate(DateTime date) {
  return _dateFormatJson.format(date);
}

DateTime decodeDate(String  dateString) {
    return _dateFormatJson.parse(dateString);
}

DateTime emptyDate = decodeDate('0001-01-01T00:00:00');
