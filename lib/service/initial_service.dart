import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_service.dart';

class InitialService {
  static final InitialService _instance = InitialService._internal();
  bool initialized = false;

  factory InitialService() {
    return _instance;
  }

  InitialService._internal();

  void init(WidgetRef ref) {
    if (initialized) return;

    listenFirebaseAuth(ref);

    initialized = true;
  }
}
