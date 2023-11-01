import 'package:intl/intl.dart';


String formatDateTime(DateTime dateTime) {
    String formattedDateTime = DateFormat('E, MMM d • h:mm a').format(dateTime);
    return formattedDateTime;
  }