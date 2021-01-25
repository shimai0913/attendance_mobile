import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widget/dialog.dart';
import '../provider/login_provider.dart';
import '../root.dart';

final phoneNumberProvider = StateProvider((ref) => '');
final pinProvider = StateProvider((ref) => '');
final verificationIdProvider = StateProvider((ref) => '');

class PhoneNumAuthModal extends HookWidget {
  final dialog = MyDialog();
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final user = lsp.getCurrentUser();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String phoneNumber = useProvider(phoneNumberProvider).state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('電話番号認証',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
      ),
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
                    labelText: '電話番号 (09012345678)',
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
                      // await dialog.show(context, '$phoneNumber宛に認証コードを送信します');
                      // firebase 認証
                      try {
                        String number = "+81" + phoneNumber;
                        // await lsp.linkWithPhoneNumber(number);
                        await _auth.verifyPhoneNumber(
                          phoneNumber: number,
                          timeout: Duration(seconds: 60),
                          verificationCompleted: (PhoneAuthCredential credential) async {
                            await user.linkWithCredential(credential);
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            }
                          },
                          codeSent: (String verificationId, int resendToken) async {
                            context.read(verificationIdProvider).state = verificationId;
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            context.read(verificationIdProvider).state = verificationId;
                          },
                        );
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return VerifyModal();
                            },
                            fullscreenDialog: true
                          ),
                        );
                      } catch (e) {
                        print('!!! ========== Exception ========== !!!');
                        print('error: $e');
                        // await dialog.show(context, e.toString());
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.indigo,
                      shadowColor: Colors.indigoAccent,
                      elevation: 7.0,
                        child: Center(
                          child: Text(
                            '送信',
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
  final dialog = MyDialog();
  @override
  Widget build(BuildContext context) {
    final lsp = useProvider(loginStateProvider);
    final user = lsp.getCurrentUser();
    final String phoneNumber = useProvider(phoneNumberProvider).state;
    final String pin = useProvider(pinProvider).state;
    final String verId = useProvider(verificationIdProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: Text('認証コード確認', style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                  PinCodeTextField(
                    appContext: context,
                    autoFocus: true,
                    pastedTextStyle: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: true, // 入力値を隠す
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.indigo,
                    ),
                    cursorColor: Colors.indigo,
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.white,
                    keyboardType: TextInputType.number,
                    // boxShadows: [
                    //   BoxShadow(
                    //     offset: Offset(0, 1),
                    //     color: Colors.black12,
                    //     blurRadius: 10,
                    //   )
                    // ],
                    onChanged: (value) {
                      try{
                      // int phone_num = int.parse(text);
                      context.read(pinProvider).state = value;
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
                      // await dialog.show(context, '$pinで認証します。');
                      try {
                        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);
                        await user.linkWithCredential(phoneAuthCredential);
                        await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
                          {
                            'photoNumber': phoneNumber,
                          }
                        );
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return RootPage();
                            },
                          ),
                        );
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
              ],
            ),
          ),
        ],
      ),

    );
  }
}
