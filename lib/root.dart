import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import './provider/login_provider.dart'; // loginStateProvider
import './provider/root_provider.dart'; // rootStateProvider
import './provider/signup_provider.dart';

import './screens/home.dart';
import './screens/login_page.dart';

class RootPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final ssp = useProvider(signUpStateProvider);
    final rsp = useProvider(rootStateProvider);
    final rootState = useProvider(rootStateProvider.state);

    // ログインしているならホーム画面へ
    useEffect(() {
      // lspからauthProviderを呼ぶためにreadを引数に初期化
      lsp.initState(context.read);
      ssp.initState(context.read);
      Future.microtask(() => rsp.setPage(lsp.getCurrentUser()));
      return () {};
    }, []);

    return MaterialApp(
      home: rootState.page == 'login' ? LoginPage() : Home(),
    );
  }
}
