import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import '../provider/signup_provider.dart';
import '../root.dart';
import './login_page.dart';
import '../widget/dialog.dart';
import '../widget/phoneNumAuth_modal.dart';


class SignUpPage extends HookWidget {
  final passwordController = TextEditingController();
  final mailController = TextEditingController();

  final dialog = MyDialog();

  @override
  Widget build(BuildContext context) {
    final ssp = useProvider(signUpStateProvider);
    final signUpState = useProvider(signUpStateProvider.state);


    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Image.asset('images/rakudasu_logo.png')
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(280.0, 180.0, 0.0, 0.0),
                  child: Text(
                    'もばいる',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'HachiMaruPop-Regular',
                    )
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (text) {
                    ssp.setMailText(text);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'パスワード',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    ssp.setPasswordText(text);
                  },
                ),
                SizedBox(height: 30.0,),
                Container(
                  height: 40.0,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        await ssp.signUp(
                            signUpState.password, signUpState.email);
                        await dialog.show(context, '登録完了しました');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RootPage()));
                      } catch (e) {
                        dialog.show(context, e.toString());
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.indigo,
                      shadowColor: Colors.indigoAccent,
                      elevation: 7.0,
                        child: Center(
                          child: Text(
                            '新規登録',
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
                SizedBox(height: 10.0,),
                Container(
                  child: Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )
                      ),
                    ),
                    Text("OR"),
                    Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )
                      ),
                    ),
                  ],)
                ),
                SizedBox(height: 10.0,),
                Container(
                  height: 40.0,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () async {
                      print('Googleで新規登録');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return PhoneNumAuthModal();
                          },
                          fullscreenDialog: true
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: ImageIcon(AssetImage('images/google_icon.png')),
                          ),
                          SizedBox(width: 10.0),
                          Center(
                            child: Text(
                              'Googleで新規登録',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  // alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top: 15.0,),
                  child: GestureDetector(
                    onTap: () {
                      print('SignInへ');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage())
                      );
                    },
                    child:Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
