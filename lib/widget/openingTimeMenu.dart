import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart'; // DateFormat用
import './closingTimeMenu.dart';
import './calendar.dart'; // calendarStateProvider用

final openingTimeProvider = StateProvider((ref) => '');

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
            mode: CupertinoDatePickerMode.time,
            initialDateTime: context.read(calendarStateProvider).selectedDay,
            use24hFormat: true, // 24h表示(AM,PMの表示消す)
            onDateTimeChanged: (dateTime) {
              var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
              var formatted = formatter.format(dateTime); // DateからString
              context.read(openingTimeProvider).state = formatted;
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
