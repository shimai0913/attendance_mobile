import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';

final authProvider = Provider.autoDispose((ref) => AuthController(ref.read));

class AuthController {
  AuthController(this.read);
  final Reader read;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser = FirebaseAuth.instance.currentUser;
  String _verificationId;

// 登録
  Future signUp(password, mail) async {
    if (password.isEmpty) {
      throw ('パスワードを入力して下さい');
    }

    if (mail.isEmpty) {
      throw ('メールアドレスを入力して下さい');
    }

    // todo:
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    )).user;

    final email = user.email;
  }

// login
  Future login(mail, password) async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力して下さい');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力して下さい');
    }

    final result = await _auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    final uid = result.user.uid;

    if (uid == null) throw ('メールアドレス又はパスワードが違います');
  }

  // signout
  Future signOut() async {
    await _auth.signOut();
  }

  Future verifyPhoneNumber() async {
    print('verifyPhoneNumber()まで来た');
    String _message = '';
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      print('あ');
      _auth.signInWithCredential(phoneAuthCredential);
    };
    final PhoneVerificationFailed verificationFailed = (authException) {
      print('い');
      _message = 'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
    };
    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      print('う: $verificationId');
      _verificationId = verificationId;
      print('う: $_verificationId');
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print('え: $verificationId');
      _verificationId = verificationId;
      print('え: $_verificationId');
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: '+1'+'650-555-3434',
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
    // String _verifycode = '333333';
    // Navigator.pushNamed(context, "/verify");
  }
  Future signInWithPhoneNumber() async {
    print('signInWithPhoneNumber()まで来た');
    String _message;
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: '333333',
    );
    try {
      final User user = (await _auth.signInWithCredential(credential)).user;
      print(user);
      assert(user.uid == currentUser.uid);
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
      } else {
        _message = 'Sign in failed';
      }
    } catch (e) {
      print("debug error");
      print(e);
      print(e.code);
    }
  }
}
