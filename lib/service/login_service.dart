import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:vc_space/provider/login_provider.dart';

void listenFirebaseAuth(WidgetRef ref) {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      ref.read(loginProvider.notifier).set(user.uid);
    }
  });
}
