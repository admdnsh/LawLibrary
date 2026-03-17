import 'package:flutter/material.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/l10n/app_localizations.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor:
      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      showUnselectedLabels: true,
      elevation: AppTheme.elevationMedium,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: l10n.tabHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.star),
          label: l10n.tabFavorites,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bar_chart_outlined),
          activeIcon: const Icon(Icons.bar_chart),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.payment),
          label: l10n.tabPayment,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.info),
          label: l10n.tabAbout,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: l10n.tabSettings,
        ),
      ],
    );
  }
}