import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widget/dialog.dart';
import '../provider/login_provider.dart';

final phoneNumberProvider = StateProvider((ref) => '');

class PhoneNumAuthModal extends HookWidget {
  final dialog = MyDialog();
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final String phoneNumber = useProvider(phoneNumberProvider).state;

    void _verifyPhoneNumber() async {
      print('_verifyPhoneNumber function start.');
      String phone = "+81" + phoneNumber;
      await lsp.verifyPhoneNumber();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return VerifyModal();
          },
          fullscreenDialog: true
        ),
      );
      print('あああああああああ');
      await lsp.signInWithPhoneNumber();
    }

    return Scaffold(
      appBar: AppBar(title: Text('電話番号認証'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '電話番号',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (text) {
                    try{
                      // int phone_num = int.parse(text);
                      context.read(phoneNumberProvider).state = text;
                    }catch (e) {
                      print(e);
                    }
                  },
                ),
                SizedBox(height: 30.0),
                Container(
                  height: 40.0,
                  child: GestureDetector(
                    onTap: () async {
                      await dialog.show(context, '$phoneNumberで認証します');
                      // firebase 認証
                      try {
                        _verifyPhoneNumber();
                      } catch (e) {
                        await dialog.show(context, e.toString());
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.indigo,
                      shadowColor: Colors.indigoAccent,
                      elevation: 7.0,
                        child: Center(
                          child: Text(
                            '認証',
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
                Container(
                  child:Text(phoneNumber),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class VerifyModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('認証コード確認'),),
      body: Text('あ'),
    );
  }
}
