import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import './calendar.dart'; // calendarStateProvider用

class EventList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> _selectedEvents = useProvider(calendarStateProvider).selectedEvents;
    if (_selectedEvents.length > 0) {
      return Flexible(
        child: ListView.builder(
          itemCount: _selectedEvents.length,
          itemBuilder: (BuildContext context, int index) {
            String worktype = _selectedEvents[index]['worktype'];
            String start = _selectedEvents[index]['start'];
            String end = _selectedEvents[index]['end'];
            List<Color> color;
            Color shadowColor;
            switch (worktype) {
              case 'SES':
                color = [Colors.indigo, Colors.indigoAccent];
                shadowColor = Colors.indigo;
                break;
              case '出勤予定':
                color = [Colors.grey, Colors.blueGrey];
                shadowColor = Colors.grey;
                break;
              case '受託':
                color = [Colors.pink, Colors.pinkAccent];
                shadowColor = Colors.pink;
                break;
              case '派遣':
                color = [Colors.orange, Colors.orangeAccent];
                shadowColor = Colors.orange;
                break;
              case '内勤':
                color = [Colors.lightGreen, Colors.lightGreenAccent];
                shadowColor = Colors.lightGreen;
                break;
              case '社内業務':
                color = [Colors.green, Colors.greenAccent];
                shadowColor = Colors.green;
                break;
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: color,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
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
