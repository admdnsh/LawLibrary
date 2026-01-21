import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/screens/splash_screen.dart';
import 'package:law_library/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Law Library',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeProvider),
      darkTheme: AppTheme.darkTheme(themeProvider),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
