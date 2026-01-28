import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UI Density options
enum UiDensity { compact, standard }

/// Font size options
enum AppFontSize { small, medium, large }

/// Language options
enum AppLanguage { english, malay }

class ThemeProvider extends ChangeNotifier {
  // -----------------------
  // PRIVATE STATE
  // -----------------------
  ThemeMode _themeMode = ThemeMode.system;
  UiDensity _uiDensity = UiDensity.standard;
  AppFontSize _fontSize = AppFontSize.medium;
  AppLanguage _language = AppLanguage.english;

  // -----------------------
  // GETTERS
  // -----------------------
  ThemeMode get themeMode => _themeMode;
  UiDensity get uiDensity => _uiDensity;
  AppFontSize get fontSize => _fontSize;
  AppLanguage get language => _language;

  /// Returns true if dark mode is active
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Returns current locale
  Locale get locale {
    switch (_language) {
      case AppLanguage.malay:
        return const Locale('ms');
      case AppLanguage.english:
      default:
        return const Locale('en');
    }
  }

  // -----------------------
  // CONSTRUCTOR
  // -----------------------
  ThemeProvider() {
    _loadPrefs();
  }

  // -----------------------
  // PUBLIC METHODS
  // -----------------------

  /// Toggle dark/light mode
  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _savePref('theme', mode.index);
    notifyListeners();
  }

  /// Set UI density
  Future<void> setUiDensity(UiDensity density) async {
    _uiDensity = density;
    await _savePref('density', density.index);
    notifyListeners();
  }

  /// Set font size
  Future<void> setFontSize(AppFontSize size) async {
    _fontSize = size;
    await _savePref('font', size.index);
    notifyListeners();
  }

  /// Set language
  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    await _savePref('language', lang.index);
    notifyListeners();
  }

  // -----------------------
  // PRIVATE HELPERS
  // -----------------------

  /// Load saved preferences
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode =
    ThemeMode.values[prefs.getInt('theme') ?? ThemeMode.system.index];
    _uiDensity =
    UiDensity.values[prefs.getInt('density') ?? UiDensity.standard.index];
    _fontSize =
    AppFontSize.values[prefs.getInt('font') ?? AppFontSize.medium.index];
    _language =
    AppLanguage.values[prefs.getInt('language') ?? AppLanguage.english.index];

    // Notify listeners after loading
    notifyListeners();
  }

  /// Save a single preference
  Future<void> _savePref(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}
