import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


final counterProvider = StateProvider((ref) => 0);

class Footer extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final int count = useProvider(counterProvider).state;
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) => context.read(counterProvider).state = index,
        currentIndex: count,
        elevation: 2.0,
        items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('ホーム'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('カレンダー'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.unarchive),
              title: Text('勤怠提出'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('設定'),
            ),
        ]
    );
  }
}
