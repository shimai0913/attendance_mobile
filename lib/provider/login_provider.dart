import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:state_notifier/state_notifier.dart';
import '../client/auth.dart';
import '../entity/auth.dart';

final loginStateProvider = StateNotifierProvider((_) => LoginStateProvider());

class LoginStateProvider extends StateNotifier<LoginState> {
  LoginStateProvider() : super(LoginState());
  Reader read;

  void initState(reader) {
    read = reader;
  }

  User getCurrentUser() {
    return read(authProvider).currentUser;
  }

  Future login(mail, password) async {
    await read(authProvider).login(mail, password);
  }

  Future signOut() async {
    await read(authProvider).signOut();
  }

  Future verifyPhoneNumber() async {
    await read(authProvider).verifyPhoneNumber();
  }
  Future signInWithPhoneNumber() async {
    await read(authProvider).signInWithPhoneNumber();
  }

  setMailText(text) {
    state = state.copyWith(email: text);
  }

  setPasswordText(text) {
    state = state.copyWith(password: text);
  }
}
