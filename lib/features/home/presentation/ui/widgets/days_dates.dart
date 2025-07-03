import 'package:intl/intl.dart';

class DaysDates {
  List days =[
    DateFormat('EEE').format( DateTime.now()),
    DateFormat('EEE').format( DateTime.now().add(Duration(days: 1))),
    DateFormat('EEE').format( DateTime.now().add(Duration(days: 2))),
  ];
  List dateDays =[
    DateFormat('dd').format( DateTime.now()),
    DateFormat('dd').format( DateTime.now().add(Duration(days: 1))),
    DateFormat('dd').format( DateTime.now().add(Duration(days: 2))),
  ];
}