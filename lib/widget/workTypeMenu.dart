import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import './openingTimeMenu.dart';

final workTypeProvider = StateProvider((ref) => '');

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
