import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginProvider =
    StateNotifierProvider<LoginNotifer, String?>((ref) => LoginNotifer());

class LoginNotifer extends StateNotifier<String?> {
  LoginNotifer() : super(null);

  void set(String? id) => state = id;
}
