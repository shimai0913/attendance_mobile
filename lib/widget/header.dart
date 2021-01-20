import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../provider/login_provider.dart';
import '../root.dart';
import './footer.dart';

class Header extends HookWidget with PreferredSizeWidget{
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final int count = useProvider(counterProvider).state;
    return AppBar(
      // leading: IconButton(
      //   icon: Icon(Icons.logout, size: 25,),
      // ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.account_circle, color: Colors.indigo, size: 35,),
          onPressed: () => {
            print('to MyPage')
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, size: 25, color: Colors.grey[900],),
          onPressed: () async {
            await lsp.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RootPage()
              )
            );
          }
        ),
      ],
      title: _buildTitle(count),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 2.0,
    );
  }
}

Widget _buildTitle(int index) {
  switch (index) {
    case 0:
      return Text(
        'ホーム',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat'
        ),
      );
    case 1:
      return Text(
        'カレンダー',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat'
        ),
      );
    case 2:
      return Text(
        '勤怠提出',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat'
        ),
      );
    case 3:
      return Text(
        '設定',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat'
        ),
      );
  }
}
