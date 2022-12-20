import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/entity/user_entity.dart';
import 'package:vc_space/model/user_model.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifer, String?>(
    (ref) => LoginNotifer());

class LoginNotifer extends StateNotifier<String?> {
  LoginNotifer() : super(null);

  void set(String? id) => state = id;
}

final AutoDisposeStreamProvider<UserEntity?> loginUserStreamProvider =
    StreamProvider.autoDispose<UserEntity?>((ref) {
  final id = ref.watch(loginProvider);

  if (id == null) {
    return Stream.value(null);
  }
  return getUserSnapshots(id);
});
