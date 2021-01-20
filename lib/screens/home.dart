import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../provider/login_provider.dart';
// import '../root.dart';
import '../widget/header.dart';
import '../widget/footer.dart';
import './home_page.dart';
import './calendar_page.dart';
import './attendanceSubmit_page.dart';
import './setting_page.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // final lsp = useProvider(loginStateProvider);
    // final loginState = useProvider(loginStateProvider.state);
    final int count = useProvider(counterProvider).state;

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
  }
}
