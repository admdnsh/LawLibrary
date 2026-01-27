import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UiDensity { compact, standard }
enum AppFontSize { small, medium, large }
enum AppLanguage { english, malay }

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  UiDensity _uiDensity = UiDensity.standard;
  AppFontSize _fontSize = AppFontSize.medium;
  AppLanguage _language = AppLanguage.english;

  ThemeMode get themeMode => _themeMode;
  UiDensity get uiDensity => _uiDensity;
  AppFontSize get fontSize => _fontSize;
  AppLanguage get language => _language;

  Locale get locale {
    switch (_language) {
      case AppLanguage.malay:
        return const Locale('ms');
      case AppLanguage.english:
      default:
        return const Locale('en');
    }
  }

  ThemeProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = ThemeMode.values[prefs.getInt('theme') ?? 0];
    _uiDensity = UiDensity.values[prefs.getInt('density') ?? 1];
    _fontSize = AppFontSize.values[prefs.getInt('font') ?? 1];
    _language = AppLanguage.values[prefs.getInt('language') ?? 0];

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', mode.index);
    notifyListeners();
  }

  Future<void> setUiDensity(UiDensity density) async {
    _uiDensity = density;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('density', density.index);
    notifyListeners();
  }

  Future<void> setFontSize(AppFontSize size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('font', size.index);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', lang.index);
    notifyListeners();
  }
}
