import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:law_library/l10n/app_localizations.dart';

import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/screens/splash_screen.dart';
import 'package:law_library/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------
  // Desktop database FFI setup
  // -----------------------------
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // -----------------------------
  // Lock device orientation
  // -----------------------------
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // -----------------------------
  // Run app with MultiProvider
  // -----------------------------
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LawProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Law Library',

      // -----------------------------
      // Localization
      // -----------------------------
      locale: themeProvider.locale, // current locale from provider
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // -----------------------------
      // Theme
      // -----------------------------
      theme: AppTheme.lightTheme(themeProvider),
      darkTheme: AppTheme.darkTheme(themeProvider),
      themeMode: themeProvider.themeMode,

      // -----------------------------
      // Entry point
      // -----------------------------
      home: const SplashScreen(),
    );
  }
}
