import 'package:hooks_riverpod/all.dart';
import '../entity/home.dart';
import 'package:state_notifier/state_notifier.dart';

final homeStateProvider = StateNotifierProvider((_) => HomeStateProvider());

class HomeStateProvider extends StateNotifier<HomeState> {
  HomeStateProvider() : super(const HomeState());
}
