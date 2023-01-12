import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../provider/login_provider.dart';

void listenFirebaseAuth(WidgetRef ref) {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    ref.read(loginProvider.notifier).set(user?.uid, ref);
  });
}
