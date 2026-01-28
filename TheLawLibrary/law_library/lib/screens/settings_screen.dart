import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final uiDensity = themeProvider.uiDensity;
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: EdgeInsets.all(
        AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
      ),
      children: [
        // ---------- Appearance ----------
        _section(
          context: context,
          title: l10n.appearance,
          children: [
            SwitchListTile(
              title: Text(l10n.darkMode),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
            _divider(),
            _dropdownTile<UiDensity>(
              context: context,
              title: l10n.uiDensity,
              subtitle: l10n.adjustSpacing,
              value: themeProvider.uiDensity,
              items: UiDensity.values,
              labelBuilder: (v) => v.name.capitalize(),
              onChanged: themeProvider.setUiDensity,
            ),
            _divider(),
            _dropdownTile<AppFontSize>(
              context: context,
              title: l10n.fontSize,
              subtitle: l10n.adjustFontSize,
              value: themeProvider.fontSize,
              items: AppFontSize.values,
              labelBuilder: (v) => v.name.capitalize(),
              onChanged: themeProvider.setFontSize,
            ),
          ],
        ),

        _gap(uiDensity),

        // ---------- Language ----------
        _section(
          context: context,
          title: l10n.language,
          children: [
            _dropdownTile<AppLanguage>(
              context: context,
              title: l10n.language,
              value: themeProvider.language,
              items: AppLanguage.values,
              labelBuilder: (lang) =>
              lang == AppLanguage.english ? 'English' : 'Bahasa Melayu',
              onChanged: themeProvider.setLanguage,
            ),
          ],
        ),

        _gap(uiDensity),

        // ---------- Data ----------
        _section(
          context: context,
          title: l10n.favorites,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(l10n.clearFavorites),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.clearFavorites),
                    content: Text(l10n.confirmRemoveFavorites),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(l10n.confirm),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await context.read<LawProvider>().clearFavorites();
                  _snack(context, l10n.confirm);
                }
              },
            ),
          ],
        ),

        _gap(uiDensity),

        // ---------- About ----------
        _section(
          context: context,
          title: l10n.about,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.appVersion),
              subtitle: const Text('2.0'),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- UI Helpers ----------

  Widget _section({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _dropdownTile<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null || subtitle.isEmpty ? null : Text(subtitle),
      trailing: DropdownButton<T>(
        value: value,
        underline: const SizedBox(),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(labelBuilder(item)),
          ),
        )
            .toList(),
        onChanged: (v) => v != null ? onChanged(v) : null,
      ),
    );
  }

  Widget _divider() => const Divider(height: 1);

  Widget _gap(UiDensity density) => SizedBox(
    height: AppTheme.getSpacing(AppTheme.baseSpacing16, density),
  );

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Simple String extension to capitalize enum names
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
