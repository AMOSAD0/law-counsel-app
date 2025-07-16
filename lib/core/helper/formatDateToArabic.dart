import 'package:intl/intl.dart';

String formatDateToArabic(String isoDateString) {

  final dateTime = DateTime.parse(isoDateString);


  final formatter = DateFormat('d MMMM y - h:mm a', 'ar');
  
  return formatter.format(dateTime);
}