import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/screens/law_form_screen.dart';

class LawDetailScreen extends StatefulWidget {
  final Law law;

  const LawDetailScreen({
    super.key,
    required this.law,
  });

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Law Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? AppTheme.accentColor : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              Provider.of<LawProvider>(context, listen: false)
                  .toggleFavorite(widget.law);
            },
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
          if (isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LawFormScreen(law: widget.law),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppTheme.errorColor),
                      SizedBox(width: 8),
                      Text('Delete',
                          style: TextStyle(color: AppTheme.errorColor)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
            AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            _buildCategorySection(context, uiDensity)
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 400))
                .moveY(begin: -10, end: 0),

            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),

            // Chapter
            _buildChapterSection(context, uiDensity)
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 100),
                )
                .moveY(begin: -10, end: 0),

            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),

            // Description
            _buildDescriptionSection(context, uiDensity)
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 200),
                )
                .moveY(begin: -10, end: 0),

            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),

            // Fines
            _buildFinesSection(context, uiDensity)
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 300),
                )
                .moveY(begin: -10, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterSection(BuildContext context, UiDensity uiDensity) {
    return Card(
      elevation: AppTheme.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.getSpacing(
                          AppTheme.baseSpacing12, uiDensity),
                      vertical:
                          AppTheme.getSpacing(AppTheme.baseSpacing4, uiDensity),
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(AppTheme.getSpacing(
                          AppTheme.borderRadiusSmall, uiDensity)),
                    ),
                    child: Text(
                      widget.law.chapter,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, UiDensity uiDensity) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.getSpacing(
                          AppTheme.baseSpacing12, uiDensity),
                      vertical:
                          AppTheme.getSpacing(AppTheme.baseSpacing4, uiDensity),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.getSpacing(
                          AppTheme.borderRadiusSmall, uiDensity)),
                    ),
                    child: Text(
                      widget.law.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, UiDensity uiDensity) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
            Text(
              widget.law.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinesSection(BuildContext context, UiDensity uiDensity) {
    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compound Fines',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
            // Fix: Use ?? '' to provide a default empty string if compoundFine is null
            _buildFineItem(context, uiDensity, 'First Offense',
                widget.law.compoundFine ?? ''),

            // Fix: Use ?.isNotEmpty == true for null-safe check
            if (widget.law.secondCompoundFine?.isNotEmpty == true)
              // Fix: Use ?? '' when passing to _buildFineItem
              _buildFineItem(context, uiDensity, 'Second Offense',
                  widget.law.secondCompoundFine ?? ''),

            // Fix: Use ?.isNotEmpty == true for null-safe check
            if (widget.law.thirdCompoundFine?.isNotEmpty == true)
              // Fix: Use ?? '' when passing to _buildFineItem
              _buildFineItem(context, uiDensity, 'Third Offense',
                  widget.law.thirdCompoundFine ?? ''),

            // Fix: Use ?.isNotEmpty == true for null-safe check
            if (widget.law.fourthCompoundFine?.isNotEmpty == true)
              // Fix: Use ?? '' when passing to _buildFineItem
              _buildFineItem(context, uiDensity, 'Fourth Offense',
                  widget.law.fourthCompoundFine ?? ''),

            // Fix: Use ?.isNotEmpty == true for null-safe check
            if (widget.law.fifthCompoundFine?.isNotEmpty == true)
              // Fix: Use ?? '' when passing to _buildFineItem
              _buildFineItem(context, uiDensity, 'Fifth Offense',
                  widget.law.fifthCompoundFine ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildFineItem(
      BuildContext context, UiDensity uiDensity, String label, String amount) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal:
                    AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity),
                vertical: AppTheme.getSpacing(AppTheme.baseSpacing4, uiDensity),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(
                    AppTheme.getSpacing(AppTheme.borderRadiusSmall, uiDensity)),
              ),
              child: Text(
                amount,
                softWrap: true,
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete Chapter ${widget.law.chapter}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final lawProvider =
                  Provider.of<LawProvider>(context, listen: false);
              final success = await lawProvider.deleteLaw(widget.law.chapter);

              if (success && context.mounted) {
                Navigator.of(context).pop();
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
}
