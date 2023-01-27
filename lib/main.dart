import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'firebase_options.dart';
import 'route.dart';

import 'component/page/main_page.dart';

Future main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  await dotenv.load(fileName: 'assets/env.$flavor');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('ja');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: dotenv.get('TITLE'),
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.amber),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
      themeMode: ThemeMode.system,
      home: const MainPage(),
      onGenerateRoute: generateRoute,
    );
  }
}
