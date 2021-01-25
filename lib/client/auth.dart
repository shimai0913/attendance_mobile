import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = Provider.autoDispose((ref) => AuthController(ref.read));

class AuthController {
  AuthController(this.read);
  final Reader read;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final User currentUser = FirebaseAuth.instance.currentUser;
  String verificationId;
  String smsCode;

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

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'email': email,
        'lastSignInTime': user.metadata.lastSignInTime,
        'created': user.metadata.creationTime,
      },
    );
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

    await FirebaseFirestore.instance.collection('users').doc(uid).update(
      {
        'lastSignInTime': result.user.metadata.lastSignInTime,
      }
    );
  }

  // signout
  Future signOut() async {
    await _auth.signOut();
  }

  // login with google
  Future loginWithGoogle() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    if (googleCurrentUser == null){
      googleCurrentUser = await _googleSignIn.signInSilently();
    }
    if (googleCurrentUser == null){
      googleCurrentUser = await _googleSignIn.signIn();
    }
    if (googleCurrentUser == null) {
      return null;
    }
    GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
    GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(googleAuthCredential);
    User currentUser =_auth.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update(
      {
        'username': googleCurrentUser.displayName,
        'gmail': googleCurrentUser.email,
        'photoURL': googleCurrentUser.photoUrl,
        'lastSignInTime': currentUser.metadata.lastSignInTime,
        'created': currentUser.metadata.creationTime,
      }
    );
  }

  // link with google
  Future linkWithGoogle() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    // if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signInSilently();
    if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signIn();
    if (googleCurrentUser == null) return null;
    GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
    GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    currentUser.linkWithCredential(googleAuthCredential);
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update(
      {
        'username': googleCurrentUser.displayName,
        'gmail': googleCurrentUser.email,
        'photoURL': googleCurrentUser.photoUrl,
      }
    );
  }
}
