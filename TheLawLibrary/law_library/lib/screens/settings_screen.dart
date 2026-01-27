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
          context,
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
              title: 'UI Density',
              subtitle: 'Adjust spacing',
              value: themeProvider.uiDensity,
              items: UiDensity.values,
              labelBuilder: (v) => v.name,
              onChanged: themeProvider.setUiDensity,
            ),
            _divider(),
            _dropdownTile<AppFontSize>(
              title: 'Font Size',
              subtitle: 'Adjust text size',
              value: themeProvider.fontSize,
              items: AppFontSize.values,
              labelBuilder: (v) => v.name,
              onChanged: themeProvider.setFontSize,
            ),
          ],
        ),

        _gap(uiDensity),

        // ---------- Language ----------
        _section(
          context,
          title: l10n.language,
          children: [
            _dropdownTile<AppLanguage>(
              title: l10n.language,
              subtitle: '',
              value: themeProvider.language,
              items: AppLanguage.values,
              labelBuilder: (lang) =>
              lang == AppLanguage.english
                  ? 'English'
                  : 'Bahasa Melayu',
              onChanged: themeProvider.setLanguage,
            ),
          ],
        ),

        _gap(uiDensity),

        // ---------- Data ----------
        _section(
          context,
          title: l10n.favorites,
          children: [
            ListTile(
              title: Text(l10n.favorites),
              leading: const Icon(Icons.favorite_outline),
              onTap: () async {
                await context.read<LawProvider>().clearFavorites();
                _snack(context, l10n.confirm);
              },
            ),
          ],
        ),

        _gap(uiDensity),

        // ---------- About ----------
        _section(
          context,
          title: l10n.about,
          children: const [
            ListTile(
              title: Text('App Version'),
              subtitle: Text('1.0.0'),
              leading: Icon(Icons.info_outline),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- UI Helpers ----------

  Widget _section(
      BuildContext context, {
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
            borderRadius: BorderRadius.circular(
              AppTheme.borderRadiusMedium,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _dropdownTile<T>({
    required String title,
    required String subtitle,
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: DropdownButton<T>(
        value: value,
        underline: const SizedBox(),
        items: items
            .map(
              (item) => DropdownMenuItem(
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
    height: AppTheme.getSpacing(
      AppTheme.baseSpacing16,
      density,
    ),
  );

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
