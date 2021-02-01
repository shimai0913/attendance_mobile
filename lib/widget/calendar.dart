import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';


final calendarControllerProvider = StateProvider((ref) => CalendarController());

final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
};
class Calendar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final CalendarController _calendarController = useProvider(calendarControllerProvider).state;
    // Map<DateTime, List> _events = useProvider(calendarProvider).events;
    // final DateTime _selectedDay = useProvider(calendarProvider).selectedDay;
    // void _onDaySelected(DateTime day, List events, List holidays) {
    //   context.read(calendarProvider).onDaySelected(day, events, holidays);
    // }
    // final Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('attendances').snapshots();
    // useEffect((){
    //   print('カレンダー init');
    //   print('_selectedDay.add(Duration(days: 0))');
    //   print(_selectedDay.add(Duration(days: 0)));

    //   _events = {
    //     _selectedDay.add(Duration(days: 0)): [
    //       {'worktype': 'SES', 'start': '09:00', 'end': '18:00'},
    //     ],
    //     _selectedDay.add(Duration(days: 1)): [
    //       {'worktype': 'SES', 'start': '09:00', 'end': '18:00'},
    //       {'worktype': 'SES', 'start': '09:00', 'end': '18:00'},
    //     ],
    //   };
    //   context.read(calendarProvider).init(_events, _selectedDay);
    //   return;
    // },[]);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white] //とりあえず白一色
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ]
      ),
      // child: Expanded(
      child: TableCalendar(
        calendarController: _calendarController,
        // events: _events,
        holidays: _holidays,
        // onDaySelected: _onDaySelected,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          canEventMarkersOverflow: true,
          // weekdayStyle: TextStyle(color: Colors.black),
          // weekendStyle: TextStyle(color: Colors.red),
          selectedColor: Colors.indigo[800],
          todayColor: Colors.indigo[50],
          markersColor: Colors.brown[700],
          outsideDaysVisible: false, // 他の月の表示を消す
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            // fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 16,
          ),
          weekendStyle: TextStyle(
            color: Colors.red[400],
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 16,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 20,
          ),
          leftChevronIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          rightChevronIcon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
