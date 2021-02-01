import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarProvider = ChangeNotifierProvider.autoDispose((ref) => CalendarNotifier());

class CalendarNotifier with ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  Map<DateTime, List> _events = {};
  Map<DateTime, List> get events => _events;
  List<dynamic> _selectedEvents = [];
  List<dynamic> get selectedEvents => _selectedEvents;

  void onDaySelected(DateTime day, List events, List holidays) {
    _selectedDay = day;
    _selectedEvents = events;
    notifyListeners();
  }
}

class EventList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> _selectedEvents = useProvider(calendarProvider).selectedEvents;
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
    }else {
      return Container(child: Text('No Event'));
    }
  }
}
