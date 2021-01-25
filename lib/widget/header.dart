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
    final user =  lsp.getCurrentUser();
    String photoUrl;
    if (user.photoURL != null) photoUrl =  user.photoURL;
    if (user.providerData.length > 0) {
      for (var date in user.providerData) {
        if (date.providerId == 'google.com') {
          photoUrl = date.photoURL;
        }
      }
    }
    final int count = useProvider(counterProvider).state;
    return AppBar(
      // leading: IconButton(
      //   icon: Icon(Icons.logout, size: 25,),
      //   onPressed: (){
      //     print('ユーザ：$user');
      //     print(user.providerData);
      //   },
      // ),
      actions: <Widget>[
        _buildProfileIconButton(photoUrl, user),
      ],
      title: _buildTitle(count),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 2.0,
    );
  }
}
Widget _buildProfileIconButton(photoUrl, user) {
  const iconSize = 35.0;
  return IconButton(
    icon: photoUrl == null || photoUrl == ''
        ? Icon(
            Icons.account_circle,
            size: iconSize,
            color: Colors.indigo,
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Colors.transparent,
            radius: iconSize / 2,
          ),
    onPressed: (){
      print('ユーザー: $user');
    },
  );
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
