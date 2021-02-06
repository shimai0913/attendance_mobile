import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widget/header.dart';
import '../widget/footer.dart';
import './home_page.dart';
import './calendar_page.dart';
import './attendanceSubmit_page.dart';
import './setting_page.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final int count = useProvider(counterProvider).state;
    useEffect(() {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      // 「xxxはあなたにプッシュ通知を送信します。よろしいですか？」を表示させるやつ
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true,)
      );

      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings setting) {
        print('Settings registered: $setting');
      });

      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print("token: $token");
      });

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
      );
      return () {};
    }, []);

    return Scaffold(
      appBar: Header(),
      body: _buildTemplate(count),
      bottomNavigationBar: Footer(),
    );
  }
}

Widget _buildTemplate(int index) {
  switch (index) {
    case 0:
      return HomePage();
    case 1:
      return CalendarPage();
    case 2:
      return AttendanceSubmitPage();
    case 3:
      return SettingPage();
    default:
      return null;
  }
}
