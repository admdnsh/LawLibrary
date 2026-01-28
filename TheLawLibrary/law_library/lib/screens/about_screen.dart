import 'package:flutter/material.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            'About Law Library',
            style: textStyle.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacing(AppTheme.baseSpacing16)),
          Text(
            'Version 2.0',
            style: textStyle.titleMedium?.copyWith(color: Colors.grey),
          ),
          SizedBox(height: spacing(AppTheme.baseSpacing24)),

          // Description
          _buildSectionCard(
            context,
            title: 'Description',
            child: Text(
              'Law Library is a comprehensive application designed to help users access and manage legal information efficiently. The app provides features for searching, categorizing, and bookmarking laws for quick reference. All laws are imported from the Road Traffic Act (2022) and Road Traffic Regulation (2022).',
              style: textStyle.bodyMedium,
            ),
            spacing: spacing,
          ),

          // Features
          _buildSectionCard(
            context,
            title: 'Features',
            child: Column(
              children: [
                _buildFeatureItem(context, Icons.search, 'Search Laws', spacing, fontSize),
                _buildFeatureItem(context, Icons.category, 'Category Filtering', spacing, fontSize),
                _buildFeatureItem(context, Icons.favorite, 'Favorites Management', spacing, fontSize),
                _buildFeatureItem(context, Icons.settings, 'Customizable Settings', spacing, fontSize),
              ],
            ),
            spacing: spacing,
          ),

          // Capstone Project
          _buildSectionCard(
            context,
            title: 'Capstone Project',
            child: Text(
              'This project is a capstone project made to complete the requirement of the Bachelor of Science (Hons) in Computing (Major in Software Development). Conducted under Traffic Control and Investigation Department (JSKLL), it integrates theoretical knowledge and practical skills, addressing real-world challenges through applied research and innovation.',
              style: textStyle.bodyMedium,
            ),
            spacing: spacing,
          ),

          // Credits
          _buildSectionCard(
            context,
            title: 'Credits',
            child: RichText(
              text: TextSpan(
                style: textStyle.bodyMedium,
                children: const [
                  TextSpan(text: 'Project by: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Muhammad Adam Danish bin Shukri \n'),
                  TextSpan(text: 'UTB Supervisors: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Dr. Wida Susanty Haji Suhaili and Ak. Dr Mohd Salihin Pg Haji Abdul Rahim\n'),
                  TextSpan(text: 'Host Supervisor: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'ASP Dk Husmawati Pg Hussin and ASP Pg Hjh Nafiah Pg Hj Asli'),
                ],
              ),
            ),
            spacing: spacing,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required Widget child, required double Function(double) spacing}) {
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
            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: spacing(AppTheme.baseSpacing8)),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text,
      double Function(double) spacing, AppFontSize fontSize) {
    // Convert AppFontSize to double using AppTheme
    final iconSize = AppTheme.getFontSize(20, fontSize);

    return Padding(
      padding: EdgeInsets.only(bottom: spacing(AppTheme.baseSpacing8)),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: spacing(AppTheme.baseSpacing8)),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
