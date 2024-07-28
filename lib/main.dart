import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtdapp/reel_config/reel_config_page.dart';
import 'package:wtdapp/reel/reel_page.dart';
import 'package:wtdapp/settings/settings_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wtdapp/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage =
      Helper(sharedPreferences: await SharedPreferences.getInstance());
  storage.loadSettings();
  // ThemeData th = ThemeData(
  //   useMaterial3: true,
  //   colorScheme: ColorScheme.fromSeed(
  //     seedColor: storage.initialColor,
  //     brightness: storage.initialColorMode ? Brightness.dark : Brightness.light,
  //   ),
  // );
  storage.addListener(() async {
    storage.loadSettings();
  });
  runApp(MyApp(
    storage: storage,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.storage});
  final Helper storage;
  // This widget is the root of your application.

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.storage.addListener(() async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale.fromSubtags(languageCode: widget.storage.initialLanguage),
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: widget.storage.initialColor,
          brightness: widget.storage.initialColorMode
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
      home: ReelPage(
        storage: widget.storage,
      ),
      routes: {
        '/reelconfig': (context) => ReelConfigPage(
              storage: widget.storage,
            ),
        '/settings': (context) => SettingsPage(
              storage: widget.storage,
            ),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Russian
      ],
    );
  }
}
