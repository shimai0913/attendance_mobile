import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/login_provider.dart'; // loginStateProvider用

final calendarControllerProvider = StateProvider((ref) => CalendarController());
final calendarStateProvider = ChangeNotifierProvider.autoDispose((ref) => CalendarNotifier());

class CalendarNotifier with ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  // Map<DateTime, List> _events = {};
  // Map<DateTime, List> get events => _events;
  List<dynamic> _selectedEvents = [];
  List<dynamic> get selectedEvents => _selectedEvents;

  void onDaySelected(DateTime day, List events, List holidays) {
    _selectedDay = day;
    _selectedEvents = events;
    notifyListeners();
  }
}
// 休日リスト
final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
};

class Calendar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final CalendarController _calendarController = useProvider(calendarControllerProvider).state;
    // Map<DateTime, List> _events = useProvider(calendarStateProvider).events;
    void _onDaySelected(DateTime day, List events, List holidays) {
      context.read(calendarStateProvider).onDaySelected(day, events, holidays);
    }
    final lsp = useProvider(loginStateProvider);
    final user = lsp.getCurrentUser();
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
      child:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('attendances') .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Map<DateTime, List> _events = {};
          if (snapshot.hasData) {
            var mappedData = snapshot.data.docs.map((doc) => doc.data()).toList();
            for (var data in mappedData) {
              // 開始時間から日付特定
              var day = data['day'];
              day = DateTime.parse(day);
              String start = data['_openingTime'].substring(11, 16);
              String end = data['_closingTime'].substring(11, 16);
              // key作成
              final key = day.add(Duration(days: 0));
              // param作成
              final param = {'worktype': data['worktype'], 'start': start, 'end': end};
              // key: param を_eventsに追加していく
              if (!_events.containsKey(key)) {
                _events[key] = [];
                _events[key].add(param);
              } else if (_events.containsKey(key)) {
                _events[key].add(param);
              }
            }
            return TableCalendar(
              calendarController: _calendarController,
              events: _events,
              holidays: _holidays,
              onDaySelected: _onDaySelected,
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
            );
          } else {
            return TableCalendar(
              calendarController: _calendarController,
              holidays: _holidays,
              onDaySelected: _onDaySelected,
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
            );
          }
        }
      ),
    );
  }
}
