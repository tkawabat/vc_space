import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';
import 'route.dart';

Future main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  await dotenv.load(fileName: 'assets/env.$flavor');

  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();

  List<Future> list = [];

  // メンテナンス中は呼び出さない
  if (dotenv.get('MAINTENANCE', fallback: '').isEmpty) {
    final option = flavor == 'production'
        ? ProdFirebaseOptions.currentPlatform
        : DevFirebaseOptions.currentPlatform;

    list.add(Firebase.initializeApp(options: option).then((_) async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }));

    list.add(Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    ));

    list.add(initializeDateFormatting('ja'));
  }

  await Future.wait(list);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: dotenv.get('TITLE'),
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
          fontFamily: GoogleFonts.zenKakuGothicAntique().fontFamily,
          // fontFamily: GoogleFonts.bizUDGothic().fontFamily,
          scheme: FlexScheme.mango),
      // darkTheme: FlexThemeData.dark(
      //     fontFamily: 'NotoSansJP', scheme: FlexScheme.mango),
      themeMode: ThemeMode.system,
      onGenerateRoute: generateRoute,
    );
  }
}
