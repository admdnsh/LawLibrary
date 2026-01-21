import 'package:flutter/material.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/utils/constants.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;
    final fontSize = themeProvider.fontSize;

    return SingleChildScrollView(
      padding: EdgeInsets.all(
          AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Law Library',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),
          Text(
            'Description',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
          Text(
            'Law Library is a comprehensive application designed to help users access and manage legal information efficiently. The app provides features for searching, categorizing, and bookmarking laws for quick reference. All laws are imported from the Road Traffic Act (2022) and Road Traffic Regulation (2022) ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),
          Text(
            'Features',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
          _buildFeatureItem(context, Icons.search, 'Search Laws'),
          _buildFeatureItem(context, Icons.category, 'Category Filtering'),
          _buildFeatureItem(context, Icons.favorite, 'Favorites Management'),
          _buildFeatureItem(context, Icons.settings, 'Customizable Settings'),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),
          Text(
            'Capstone Project',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
          Text(
            'This project is a capstone project made to complete the requirement of the degree course of Bachelor of Science (Hons) in Computer Networking within University of Technology Brunei. The project is done within the grounds of Traffic Control and Investigation Department(JSKLL). It serves as the culmination of the academic journey undertaken by the student, integrating theoretical knowledge and practical skills acquired throughout the program. The project aims to address real-world challenges through applied research and innovation, demonstrating the student\'s ability to plan, develop, and present a comprehensive solution in a professional context.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
          Text(
            'Credits',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
              height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: const [
                TextSpan(
                    text: 'Project by: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Ak Mohd Haziq Luthfil Al\'Hafez bin Pg Shahrol Rezal Malek Faesal\n'),
                TextSpan(
                    text: 'UTB Supervisors: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Dr. Wida Susanty Haji Suhaili, Ak. Dr Mohd Salihin Pg Haji Abdul Rahim\n'),
                TextSpan(
                    text: 'Host Supervisor: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'ASP Dk Husmawati Pg Hussin, INSP. Hayati Binti Tassim'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;
    final fontSize = themeProvider.fontSize;

    return Padding(
      padding: EdgeInsets.only(
          bottom: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
      child: Row(
        children: [
          Icon(icon, size: AppTheme.getFontSize(20, fontSize)),
          SizedBox(
              width: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
