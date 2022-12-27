import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'route.dart';
import 'service/login_service.dart';

import 'component/l5/main_page.dart';

Future main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  await dotenv.load(fileName: 'assets/env.$flavor');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenFirebaseAuth(ref);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MainPage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: generateRoute,
    );
  }
}
