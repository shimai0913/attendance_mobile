import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/error.dart';
import './root.dart';


void main() {
  runApp(ProviderScope(child: MyApp()));
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, snapshot) {
        // 取得が完了していないときに表示するWidget
        if (snapshot.connectionState != ConnectionState.done) {
          // インジケーターを回しておきます
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'xxx',
            home: ErrorPage(),
          );
        }
        // データが取得できなかったときに表示するWidget
        if (!snapshot.hasData) {
          return Text('データが見つかりません');
        }
        // Once complete, show your application
        return MaterialApp(
          title: 'xxx',
          home: RootPage(),
        );
      },
    );
  }
}
