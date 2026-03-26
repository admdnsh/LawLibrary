import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/l10n/app_localizations.dart';
import 'package:law_library/screens/about_screen.dart';
import 'package:law_library/services/recent_searches_service.dart';

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
            // Theme mode — Light / System / Dark segmented control
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: Text(l10n.darkMode),
              isThreeLine: true,
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: const Icon(Icons.light_mode_outlined, size: 16),
                      label: Text(l10n.themeModeLight),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: const Icon(Icons.brightness_auto_outlined, size: 16),
                      label: Text(l10n.themeModeSystem),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: const Icon(Icons.dark_mode_outlined, size: 16),
                      label: Text(l10n.themeModeDark),
                    ),
                  ],
                  selected: {themeProvider.themeMode},
                  onSelectionChanged: (selection) =>
                      themeProvider.setThemeMode(selection.first),
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),
            _divider(),
            _dropdownTile<UiDensity>(
              context: context,
              icon: Icons.density_medium_outlined,
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
              icon: Icons.text_fields_outlined,
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
              icon: Icons.language_outlined,
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

        // ---------- Data & Storage ----------
        _section(
          context: context,
          title: l10n.data,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(l10n.clearFavorites),
              subtitle: Text(l10n.removeSavedLaws),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.clearFavorites),
                    content: Text(l10n.confirmRemoveFavorites),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(l10n.confirm),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await context.read<LawProvider>().clearFavorites();
                  if (context.mounted) _snack(context, l10n.favoritesCleared);
                }
              },
            ),
            _divider(),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(l10n.clearRecentSearches),
              subtitle: Text(l10n.removeSearchHistory),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.clearRecentSearches),
                    content: Text(l10n.confirmClearSearches),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(l10n.confirm),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await RecentSearchesService().clear();
                  if (context.mounted) {
                    _snack(context, l10n.searchesCleared);
                  }
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
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen(showAppBar: true)),
              ),
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
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.75),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
          DropdownButton<T>(
            value: value,
            underline: const SizedBox(),
            isDense: true,
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
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1);

  Widget _gap(UiDensity density) => SizedBox(
        height: AppTheme.getSpacing(AppTheme.baseSpacing16, density),
      );

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Simple String extension to capitalize enum names
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
