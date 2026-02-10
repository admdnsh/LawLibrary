import 'package:flutter/material.dart';
import 'package:law_library/l10n/app_localizations.dart';

class Validators {
  // Username validation
  static String? validateUsername(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.loginUsernameRequired;
    if (value.length < 3) return l10n.loginUsernameMinLength;
    return null;
  }

  // Password validation
  static String? validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.loginPasswordRequired;
    if (value.length < 6) return l10n.loginPasswordMinLength;
    return null;
  }

  // Law chapter validation
  static String? validateChapter(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.lawChapterRequired;
    return null;
  }

  // Law title validation
  static String? validateTitle(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.lawTitleRequired;
    return null;
  }

  // Law category validation
  static String? validateCategory(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.lawCategoryRequired;
    return null;
  }
}
