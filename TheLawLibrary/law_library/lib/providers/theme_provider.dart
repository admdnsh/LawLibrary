import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UiDensity {
  compact,
  standard,
}

enum AppFontSize {
  small,
  medium,
  large,
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  UiDensity _uiDensity = UiDensity.standard;
  AppFontSize _fontSize = AppFontSize.medium;
  bool _isLoading = false;

  ThemeMode get themeMode => _themeMode;
  UiDensity get uiDensity => _uiDensity;
  AppFontSize get fontSize => _fontSize;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt('theme_mode') ?? 0;
      _themeMode = ThemeMode.values[themeIndex];

      final uiDensityIndex =
          prefs.getInt('ui_density') ?? 1; // Default to standard
      _uiDensity = UiDensity.values[uiDensityIndex];

      final fontSizeIndex = prefs.getInt('font_size') ?? 1; // Default to medium
      _fontSize = AppFontSize.values[fontSizeIndex];
    } catch (e) {
      // If there's an error, use system defaults
      _themeMode = ThemeMode.system;
      _uiDensity = UiDensity.standard;
      _fontSize = AppFontSize.medium;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _isLoading = true;
    notifyListeners();

    try {
      _themeMode = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', mode.index);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setUiDensity(UiDensity density) async {
    _isLoading = true;
    notifyListeners();

    try {
      _uiDensity = density;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ui_density', density.index);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setFontSize(AppFontSize fontSize) async {
    _isLoading = true;
    notifyListeners();

    try {
      _fontSize = fontSize;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('font_size', fontSize.index);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
