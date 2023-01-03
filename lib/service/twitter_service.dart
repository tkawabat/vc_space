@JS()
library twitter;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:js/js.dart';

import '../provider/login_provider.dart';

@JS('twitterLogin')
external Future<void> twitterLogin();

@JS('twitterLogout')
external Future<void> _twitterLogout();

Future<void> twitterLogout(WidgetRef ref) async {
  _twitterLogout();
  var loginUser = ref.read(loginProvider.notifier);
  loginUser.set(null, ref);
}
