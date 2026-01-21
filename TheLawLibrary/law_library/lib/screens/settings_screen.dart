import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/providers/law_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final uiDensity = themeProvider.uiDensity;
        return ListView(
          padding: EdgeInsets.all(
              AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
          children: [
            _buildSection(
              context,
              'Appearance',
              [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle dark/light theme'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.setThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('UI Density'),
                  subtitle: Text(
                      'Current: ${themeProvider.uiDensity.toString().split('.').last}'),
                  trailing: DropdownButton<UiDensity>(
                    value: themeProvider.uiDensity,
                    items: UiDensity.values.map((density) {
                      return DropdownMenuItem<UiDensity>(
                        value: density,
                        child: Text(density.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setUiDensity(value);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Font Size'),
                  subtitle: Text(
                      'Current: ${themeProvider.fontSize.toString().split('.').last}'),
                  trailing: DropdownButton<AppFontSize>(
                    value: themeProvider.fontSize,
                    items: AppFontSize.values.map((fontSize) {
                      return DropdownMenuItem<AppFontSize>(
                        value: fontSize,
                        child: Text(fontSize.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setFontSize(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
            _buildSection(
              context,
              'Data',
              [
                ListTile(
                  title: const Text('Clear Cache'),
                  subtitle: const Text('Remove temporary data'),
                  trailing: const Icon(Icons.delete_outline),
                  onTap: () {
                    _showConfirmationDialog(
                      context,
                      'Clear Cache',
                      'This will remove all your favorites and temporary data. This action cannot be undone.',
                      () async {
                        final lawProvider = Provider.of<LawProvider>(
                          context,
                          listen: false,
                        );
                        await lawProvider.clearFavorites();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Cache and favorites cleared successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('System Default'),
            subtitle: const Text('Use device theme settings'),
            leading: Icon(
              Icons.settings_system_daydream,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                );
              },
            ),
            onTap: () {
              final themeProvider = Provider.of<ThemeProvider>(
                context,
                listen: false,
              );
              themeProvider.setThemeMode(ThemeMode.system);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSettings(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Clear Search History'),
            subtitle: const Text('Delete your recent searches'),
            leading: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              _showConfirmationDialog(
                context,
                'Clear Search History',
                'Are you sure you want to clear your search history?',
                () {
                  // Clear search history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Search history cleared'),
                    ),
                  );
                },
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Clear Favorites'),
            subtitle: const Text('Remove all saved favorites'),
            leading: Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              _showConfirmationDialog(
                context,
                'Clear Favorites',
                'Are you sure you want to remove all your favorites?',
                () async {
                  // Clear favorites
                  final lawProvider = Provider.of<LawProvider>(
                    context,
                    listen: false,
                  );
                  await lawProvider.loadFavorites();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favorites cleared'),
                    ),
                  );
                },
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Clear App Data'),
            subtitle: const Text('Reset all app data and preferences'),
            leading: Icon(
              Icons.delete_forever,
              color: Theme.of(context).colorScheme.error,
            ),
            onTap: () {
              _showConfirmationDialog(
                context,
                'Clear App Data',
                'Are you sure you want to clear all app data? This action cannot be undone.',
                () {
                  // Clear app data
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('App data cleared'),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            leading: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Terms of Service'),
            leading: Icon(
              Icons.description,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              // Navigate to Terms of Service
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: Icon(
              Icons.privacy_tip,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              // Navigate to Privacy Policy
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Open Source Licenses'),
            leading: Icon(
              Icons.code,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              // Navigate to Licenses page
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            child: Text(
              'Confirm',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
