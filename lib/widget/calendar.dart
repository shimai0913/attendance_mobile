import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../provider/login_provider.dart';


final calendarControllerProvider = StateProvider((ref) => CalendarController());
final workTypeProvider = StateProvider((ref) => '');
final openingTimeProvider = StateProvider((ref) => '');
final closingTimeProvider = StateProvider((ref) => '');
final calendarProvider = ChangeNotifierProvider.autoDispose((ref) => CalendarNotifier());
// final attendancesInfoProvider = ChangeNotifierProvider.autoDispose((ref) => AttendancesInfoNotifier());

// class AttendancesInfoNotifier with ChangeNotifier {
//   String _openingTime;
//   String get openingTime => _openingTime;
//   void updateOpeningTime(openingTime) {
//     print('openingTime アップデート => $openingTime');
//     _openingTime = openingTime;
//     notifyListeners();
//   }
//   String _closingTime;
//   String get closingTime => _closingTime;
//   void updateClosingTime(closingTime) {
//     print('closingTime アップデート => $closingTime');
//     _closingTime = closingTime;
//     notifyListeners();
//   }

//   String _worktype;
//   String get worktype => _worktype;
//   void updateWorktype(worktype) {
//     print('worktype アップデート => $worktype');
//     _worktype = worktype;
//     notifyListeners();
//   }
// }

final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
};

class CalendarNotifier with ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  Map<DateTime, List> _events = {};
  Map<DateTime, List> get events => _events;
  List<dynamic> _selectedEvents = [];
  List<dynamic> get selectedEvents => _selectedEvents;
  void init(events, selectedDay) {
    _events = events;
    _selectedDay = DateTime.now();
    _selectedEvents = events[selectedDay];
    notifyListeners();
  }
  void onDaySelected(DateTime day, List events, List holidays) {
    _selectedDay = day;
    _selectedEvents = events;
    notifyListeners();
  }
}

class Calendar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final CalendarController _calendarController = useProvider(calendarControllerProvider).state;
    Map<DateTime, List> _events = useProvider(calendarProvider).events;
    final DateTime _selectedDay = useProvider(calendarProvider).selectedDay;
    void _onDaySelected(DateTime day, List events, List holidays) {
      context.read(calendarProvider).onDaySelected(day, events, holidays);
    };
    useEffect((){
      print('カレンダー init');
      _events = {
        _selectedDay.add(Duration(days: 0)): [
          {'worktype': 'SES', 'start': '09:00', 'end': '18:00'},
        ],
        _selectedDay.add(Duration(days: 1)): [
          {'worktype': 'SES', 'start': '09:00', 'end': '18:00'},
          {'worktype': 'SES', 'start': '09:00', 'end': '18:00'},
        ],
      };
      context.read(calendarProvider).init(_events, _selectedDay);
      return;
    },[]);
    final List<dynamic> _selectedEvents = useProvider(calendarProvider).selectedEvents;

    return Scaffold(
      body: Column(
        children: [
          Container(
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
            child: TableCalendar(
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
            ),
          ),
          SizedBox(height: 15),
          _buildEventList(_selectedEvents),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          _openWorkTypeModal(context);
        },
        child: Icon(Icons.create, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEventList(_selectedEvents) {
    if (_selectedEvents.length > 0) {
      return Flexible(
        child: ListView.builder(
          itemCount: _selectedEvents.length,
          itemBuilder: (BuildContext context, int index) {
            String worktype = _selectedEvents[index]['worktype'];
            String start = _selectedEvents[index]['start'];
            String end = _selectedEvents[index]['end'];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigoAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo,
                    blurRadius: 6,
                    offset: Offset(0,6),
                  )
                ]
              ),
              margin:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: ListTile(
                leading: Icon(Icons.label, color: Colors.white),
                title: Text(
                  '$worktype',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  '$start ~ $end',
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize:20
                  ),
                ),
                // trailing: Icon(Icons.tras),
              ),
            );
          }
        ),
      );
    } else {
      return Container(child: Text('No Event'));
    }
  }

  void _openWorkTypeModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF737373),
          child: Container(
            // child: _buildWorkTypeMenu(),
            child: WorkTypeMenu(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              )
            ),
          )
        );
      }
    );
  }
}

class WorkTypeMenu extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(150.0, 10.0, 150.0, 10.0),
          child: Container(
            height: 8.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(const Radius.circular(8.0))
            ),
          )
        ),
        Text(
          '1. 勤務種別を選択してください',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 20,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0,),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('SES', style: TextStyle(color: Colors.grey[600],),),
          onTap: () {
            context.read(workTypeProvider).state = 'SES';
            _openOpeningTimeModal(context);
          }
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('出勤予定', style: TextStyle(color: Colors.grey[600],),),
          onTap: () {
            context.read(workTypeProvider).state = '出勤予定';
            _openOpeningTimeModal(context);
          }
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('受託', style: TextStyle(color: Colors.grey[600],),),
          onTap: () {
            context.read(workTypeProvider).state = '受託';
            _openOpeningTimeModal(context);
          }
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('派遣', style: TextStyle(color: Colors.grey[600],),),
          onTap: () {
            context.read(workTypeProvider).state = '派遣';
            _openOpeningTimeModal(context);
          }
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('内勤', style: TextStyle(color: Colors.grey[600],),),
          onTap: () {
            context.read(workTypeProvider).state = '内勤';
            _openOpeningTimeModal(context);
          }
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('社内業務', style: TextStyle(color: Colors.grey[600],),),
          onTap: () {
            context.read(workTypeProvider).state = '社内業務';
            _openOpeningTimeModal(context);
          }
        ),
      ],
    );
  }
  void _openOpeningTimeModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF737373), //透明
          child: Container(
            child: OpeningTimeMenu(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              )
            ),
          )
        );
      }
    );
  }
}

class OpeningTimeMenu extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(150.0, 10.0, 150.0, 10.0),
          child: Container(
            height: 8.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(const Radius.circular(8.0))
            ),
          )
        ),
        Text(
          '2. 勤務開始時間を選択してください',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 20,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0,),
        SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            use24hFormat: true, // 24h表示(AM,PMの表示消す)
            mode: CupertinoDatePickerMode.dateAndTime,
            onDateTimeChanged: (dateTime) {
              var formatter = new DateFormat('yyyy/MM/dd HH:mm:ss');
              var formatted = formatter.format(dateTime); // DateからString
              context.read(openingTimeProvider).state = formatted;
              // context.read(attendancesInfoProvider).updateOpeningTime(formatted);
              // print('dateTime: $dateTime');
              // print('formatted: $dateTime');
              // if(dateTime is String) {
              //   print('dateTime は String です');
              // } else {
              //   print('dateTime は String じゃないです');
              // }
              // if(formatted is String) {
              //   print('formatted は String です');
              // } else {
              //   print('formatted は String じゃないです');
              // }
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: FlatButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.indigo[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  _openClosingTimeModal(context);
                },
              )
            ),
            Container(
              child: FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.indigo[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ),
          ],
        ),
      ],
    );
  }
  void _openClosingTimeModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF737373), //透明
          child: Container(
            child: ClosingTimeMenu(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              )
            ),
          )
        );
      }
    );
  }
}

class ClosingTimeMenu extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(150.0, 10.0, 150.0, 10.0),
          child: Container(
            height: 8.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(const Radius.circular(8.0))
            ),
          )
        ),
        Text(
          '3. 勤務終了時間を選択してください',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 20,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0,),
        SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            use24hFormat: true, // 24h表示(AM,PMの表示消す)
            mode: CupertinoDatePickerMode.dateAndTime,
            onDateTimeChanged: (dateTime) {
              var formatter = new DateFormat('yyyy/MM/dd HH:mm:ss');
              var formatted = formatter.format(dateTime); // DateからString
              context.read(closingTimeProvider).state = formatted;
              // context.read(attendancesInfoProvider).updateClosingTime(formatted);
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: FlatButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.indigo[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  _openconfirmationModal(context);
                },
              )
            ),
            Container(
              child: FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.indigo[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ),
          ],
        ),
      ],
    );
  }
  void _openconfirmationModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF737373), //透明
          child: Container(
            child: Confirmation(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              )
            ),
          )
        );
      }
    );
  }
}

class Confirmation extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final String _worktype = useProvider(workTypeProvider).state;
    final String _openingTime = useProvider(openingTimeProvider).state;
    final String _closingTime = useProvider(closingTimeProvider).state;
    // final String _worktype = useProvider(attendancesInfoProvider).worktype;
    // final String _openingTime = useProvider(attendancesInfoProvider).openingTime;
    // final String _closingTime = useProvider(attendancesInfoProvider).closingTime;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(150.0, 10.0, 150.0, 10.0),
          child: Container(
            height: 8.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(const Radius.circular(8.0))
            ),
          )
        ),
        Text(
          '4. 入力した情報を確認してください',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 20,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0,),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('選択種別: $_worktype', style: TextStyle(color: Colors.grey[600],),),
        ),
        ListTile(
          leading: Icon(Icons.timer),
          title: Text('開始時間: $_openingTime', style: TextStyle(color: Colors.grey[600],),),
        ),
        ListTile(
          leading: Icon(Icons.timer),
          title: Text('終了時間: $_closingTime', style: TextStyle(color: Colors.grey[600],),),
        ),
        Container(
          padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SizedBox(height: 10,),
              Container(
                height: 50.0,
                child: GestureDetector(
                  onTap: () async {
                    final user = lsp.getCurrentUser();
                    print('ログインユーザー: $user');
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.indigo,
                    shadowColor: Colors.indigoAccent,
                    elevation: 7.0,
                      child: Center(
                        child: Text(
                          'RAKUDASUに登録する',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 50.0,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    shadowColor: Colors.indigoAccent,
                    elevation: 7.0,
                      child: Center(
                        child: Text(
                          '入力をやり直す',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
