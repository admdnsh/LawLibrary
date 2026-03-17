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
    setState(() => _isFavorite = !_isFavorite);
    Provider.of<LawProvider>(context, listen: false)
        .toggleFavorite(widget.law);
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final lawProvider =
              Provider.of<LawProvider>(context, listen: false);
              final success =
              await lawProvider.deleteLaw(widget.law.chapter);
              if (success && context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Law deleted successfully')),
                );
              }
            },
            child: Text(
              'Delete',
              style:
              TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // FINE ROW
  // Highlights the 1st offence in red — the one officers
  // need most often — and shows subsequent offences in a
  // subdued style below.
  // --------------------------------------------------

  Widget _buildFineRow({
    required BuildContext context,
    required UiDensity uiDensity,
    required String label,
    required String amount,
    required bool isFirst,
  }) {
    final Color bgColor = isFirst
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.surfaceVariant;
    final Color textColor = isFirst
        ? Theme.of(context).colorScheme.onErrorContainer
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final double fontSize = isFirst ? 16 : 14;
    final FontWeight fontWeight =
    isFirst ? FontWeight.w600 : FontWeight.w500;

    return Padding(
      padding: EdgeInsets.only(
          bottom: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal:
          AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
          vertical: AppTheme.getSpacing(
              isFirst ? AppTheme.baseSpacing12 : AppTheme.baseSpacing8,
              uiDensity),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
              AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
            Text(
              '$amount',
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // PILL BADGE
  // Used for category and chapter — compact, inline.
  // --------------------------------------------------

  Widget _buildPill(
      BuildContext context,
      String label,
      Color bgColor,
      Color textColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    // Collect only non-empty fines in order
    final fineLabels = [
      '1st offence',
      '2nd offence',
      '3rd offence',
      '4th offence',
      '5th offence',
    ];
    final fines = [
      widget.law.compoundFine,
      widget.law.secondCompoundFine,
      widget.law.thirdCompoundFine,
      widget.law.fourthCompoundFine,
      widget.law.fifthCompoundFine,
    ]
        .asMap()
        .entries
        .where((e) => e.value?.isNotEmpty == true)
        .map((e) => MapEntry(fineLabels[e.key], e.value!))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Law Details'),
        actions: [
          // Favourite toggle
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? AppTheme.accentColor : null,
            ),
            onPressed: _toggleFavorite,
            tooltip:
            _isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),

          // Admin edit / delete menu
          if (authProvider.isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LawFormScreen(law: widget.law)),
                  );
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    Text('Delete',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ]),
                ),
              ],
            ),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(
            AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
        children: [
          // ── Category + Chapter pills ──────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPill(
                context,
                widget.law.category,
                Theme.of(context).colorScheme.secondaryContainer,
                Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              _buildPill(
                context,
                widget.law.chapter,
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.05, end: 0),

          SizedBox(
              height:
              AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),

          // ── Title ─────────────────────────────────────────────
          Text(
            widget.law.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms, delay: 50.ms)
              .slideY(begin: -0.05, end: 0),

          SizedBox(
              height:
              AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity)),

          // ── Description ───────────────────────────────────────
          Text(
            widget.law.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms, delay: 100.ms)
              .slideY(begin: -0.05, end: 0),

          // ── Fines section ─────────────────────────────────────
          if (fines.isNotEmpty) ...[
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing24, uiDensity)),

            Divider(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withOpacity(0.5),
              height: 1,
            ),

            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)),

            // "Compound fines" label
            Text(
              'COMPOUND FINES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 150.ms),

            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing12, uiDensity)),

            // Fine rows
            ...fines.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value.key;
              final amount = entry.value.value;
              return _buildFineRow(
                context: context,
                uiDensity: uiDensity,
                label: label,
                amount: amount,
                isFirst: index == 0,
              )
                  .animate()
                  .fadeIn(
                duration: 350.ms,
                delay: Duration(milliseconds: 180 + index * 60),
              )
                  .slideY(begin: 0.05, end: 0);
            }),
          ],

          // Bottom padding so last item isn't flush against nav bar
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}