import 'package:flutter/material.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();
    final uiDensity = themeProvider.uiDensity;
    final fontSize = themeProvider.fontSize;

    double spacing(double base) => AppTheme.getSpacing(base, uiDensity);
    final textStyle = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing(AppTheme.baseSpacing16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l10n.aboutLawLibrary,
            style: textStyle.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing(AppTheme.baseSpacing16)),
          Text(
            l10n.appVersionNumber,
            style: textStyle.titleMedium?.copyWith(color: Colors.grey),
          ),
          SizedBox(height: spacing(AppTheme.baseSpacing24)),

          // Description
          _buildSectionCard(
            context,
            title: l10n.aboutDescriptionTitle,
            spacing: spacing,
            child: Text(
              l10n.aboutDescriptionBody,
              style: textStyle.bodyMedium,
            ),
          ),

          // Features
          _buildSectionCard(
            context,
            title: l10n.aboutFeaturesTitle,
            spacing: spacing,
            child: Column(
              children: [
                _buildFeatureItem(context, Icons.search, l10n.featureSearch, spacing, fontSize),
                _buildFeatureItem(context, Icons.category, l10n.featureCategories, spacing, fontSize),
                _buildFeatureItem(context, Icons.favorite, l10n.featureFavorites, spacing, fontSize),
                _buildFeatureItem(context, Icons.settings, l10n.featureSettings, spacing, fontSize),
              ],
            ),
          ),

          // Capstone Project
          _buildSectionCard(
            context,
            title: l10n.aboutCapstoneTitle,
            spacing: spacing,
            child: Text(
              l10n.aboutCapstoneBody,
              style: textStyle.bodyMedium,
            ),
          ),

          // Credits
          _buildSectionCard(
            context,
            title: l10n.aboutCreditsTitle,
            spacing: spacing,
            child: Text(
              l10n.aboutCreditsBody,
              style: textStyle.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, {
        required String title,
        required Widget child,
        required double Function(double) spacing,
      }) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing(AppTheme.borderRadiusMedium)),
      ),
      margin: EdgeInsets.only(bottom: spacing(AppTheme.baseSpacing24)),
      child: Padding(
        padding: EdgeInsets.all(spacing(AppTheme.baseSpacing16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: spacing(AppTheme.baseSpacing8)),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context,
      IconData icon,
      String text,
      double Function(double) spacing,
      AppFontSize fontSize,
      ) {
    final iconSize = AppTheme.getFontSize(20, fontSize);

    return Padding(
      padding: EdgeInsets.only(bottom: spacing(AppTheme.baseSpacing8)),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: spacing(AppTheme.baseSpacing8)),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
