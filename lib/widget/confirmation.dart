import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // DateFormat用
import '../root.dart'; // RootPage()用
import '../provider/login_provider.dart'; // loginStateProvider用
import './workTypeMenu.dart'; // workTypeProvider用
import './openingTimeMenu.dart'; // openingTimeProvider用
import './closingTimeMenu.dart'; // closingTimeProvider用
import './calendar.dart'; // calendarStateProvider用

class Confirmation extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final user = lsp.getCurrentUser();
    final String _worktype = useProvider(workTypeProvider).state;
    final String _openingTime = useProvider(openingTimeProvider).state;
    final String _closingTime = useProvider(closingTimeProvider).state;
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
                    String now = DateTime.now().toString();
                    var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
                    var formatted = formatter.format(context.read(calendarStateProvider).selectedDay); // DateからString
                    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('attendances').doc(now).set(
                      {
                        'user': user.uid,
                        'day': formatted,
                        'worktype': _worktype,
                        '_openingTime': _openingTime,
                        '_closingTime': _closingTime,
                      }
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return RootPage();
                        },
                      ),
                    );
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
