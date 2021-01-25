import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widget/phoneNumAuth_modal.dart';
import '../provider/login_provider.dart';
import '../root.dart';
import '../widget/dialog.dart';



class SettingPage extends HookWidget {
  final dialog = MyDialog();
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final user =  lsp.getCurrentUser();
    final phoneNumberProvider =  user.phoneNumber == null || user.phoneNumber == '' ? '未認証' : '認証済み';
    final googleAccountData =  user.providerData[0].providerId == 'google.com' ? '認証済み' : '未認証' ;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                'アカウント',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200])
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: ListTile(
                        title: Text('電話番号認証'),
                        trailing: Text('$phoneNumberProvider'),
                        onTap: () {
                          print(user.phoneNumber);
                          if (phoneNumberProvider == '未認証'){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return PhoneNumAuthModal();
                                },
                                fullscreenDialog: true
                              ),
                            );
                          }
                          if (phoneNumberProvider == '認証済み'){print('認証済み');}
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: ListTile(
                        title: Text('Google認証'),
                        trailing: Text(googleAccountData),
                        onTap: () async {
                          if (googleAccountData == '未認証'){
                            await lsp.linkWithGoogle();
                            await dialog.show(context, 'Googleアカウントをひもづけました');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RootPage()
                              )
                            );
                          }
                          if (googleAccountData == '認証済み') {
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: ListTile(
                        title: Text('ログアウト'),
                        onTap: () async {
                          await lsp.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RootPage()
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
