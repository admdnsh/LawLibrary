import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/screens/law_form_screen.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LawDetailScreen extends StatefulWidget {
  final Law law;

  const LawDetailScreen({super.key, required this.law});

  @override
  State<LawDetailScreen> createState() => _LawDetailScreenState();
}

class _LawDetailScreenState extends State<LawDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.law.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    Provider.of<LawProvider>(context, listen: false).toggleFavorite(widget.law);
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete Chapter ${widget.law.chapter}?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final lawProvider = Provider.of<LawProvider>(context, listen: false);
              final success = await lawProvider.deleteLaw(widget.law.chapter);
              if (success && context.mounted) {
                Navigator.of(context).pop(); // Go back after deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Law deleted successfully')),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required Widget content,
    required UiDensity uiDensity,
    double elevation = AppTheme.elevationSmall,
  }) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, {Color? color, Color? textColor}) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color ?? AppTheme.primaryColor,
    );
  }

  Widget _buildFineItem(UiDensity uiDensity, String label, String amount) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 1, child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity),
                vertical: AppTheme.getSpacing(AppTheme.baseSpacing4, uiDensity),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(
                  AppTheme.getSpacing(AppTheme.borderRadiusSmall, uiDensity),
                ),
              ),
              child: Text(
                amount,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    final fines = [
      widget.law.compoundFine,
      widget.law.secondCompoundFine,
      widget.law.thirdCompoundFine,
      widget.law.fourthCompoundFine,
      widget.law.fifthCompoundFine,
    ].where((e) => e?.isNotEmpty == true).map((e) => e!).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Law Details'),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border,
                color: _isFavorite ? AppTheme.accentColor : null),
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
          if (isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LawFormScreen(law: widget.law)));
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        children: [
          _buildCardSection(
            title: 'Category',
            uiDensity: uiDensity,
            content: _buildChip(widget.law.category,
                color: Theme.of(context).colorScheme.secondaryContainer,
                textColor: Theme.of(context).colorScheme.onSecondaryContainer),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),

          SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),

          _buildCardSection(
            title: 'Chapter',
            uiDensity: uiDensity,
            content: _buildChip(widget.law.chapter),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).moveY(begin: -10, end: 0),

          SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),

          _buildCardSection(
            title: 'Description',
            uiDensity: uiDensity,
            content: Text(widget.law.description, style: Theme.of(context).textTheme.bodyMedium),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).moveY(begin: -10, end: 0),

          if (fines.isNotEmpty) ...[
            SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),
            _buildCardSection(
              title: 'Compound Fines',
              uiDensity: uiDensity,
              content: Column(
                children: fines
                    .asMap()
                    .entries
                    .map((e) => _buildFineItem(uiDensity, 'Offense ${e.key + 1}', e.value))
                    .toList(),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).moveY(begin: -10, end: 0),
          ],
        ],
      ),
    );
  }
}
