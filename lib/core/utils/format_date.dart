import 'package:intl/intl.dart';

 String formatDateByddMMYYYY(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }