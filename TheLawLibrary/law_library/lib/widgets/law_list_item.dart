import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:law_library/providers/theme_provider.dart';

class LawListItem extends StatelessWidget {
  final Law law;
  final VoidCallback onTap;

  const LawListItem({
    super.key,
    required this.law,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;
    final fontSize = themeProvider.fontSize;

    // Determine fine display — show compound fine if available, otherwise N/A
    final bool hasFine =
        law.compoundFine != null && law.compoundFine!.trim().isNotEmpty;
    final String fineLabel = hasFine ? '${law.compoundFine}' : 'No fine';

    return Padding(
      padding: EdgeInsets.only(
          bottom: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity)),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                final lawProvider = Provider.of<LawProvider>(
                  context,
                  listen: false,
                );
                lawProvider.toggleFavorite(law);
              },
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
              icon: law.isFavorite ? Icons.star : Icons.star_border,
              label: law.isFavorite ? 'Unfavorite' : 'Favorite',
              borderRadius: BorderRadius.circular(
                  AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
              AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
          child: Container(
            padding: EdgeInsets.all(
                AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(
                  AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Main content ──────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top row: chapter badge + fine badge
                      // Using Wrap so badges flow to next line if space is tight
                      Wrap(
                        spacing: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
                        runSpacing: AppTheme.getSpacing(AppTheme.baseSpacing4, uiDensity),
                        children: [
                          // Chapter badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.getSpacing(
                                  AppTheme.baseSpacing8, uiDensity),
                              vertical: AppTheme.getSpacing(
                                  AppTheme.baseSpacing4, uiDensity),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(
                                  AppTheme.getSpacing(
                                      AppTheme.borderRadiusSmall, uiDensity)),
                            ),
                            child: Text(
                              law.chapter,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Fine badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.getSpacing(
                                  AppTheme.baseSpacing8, uiDensity),
                              vertical: AppTheme.getSpacing(
                                  AppTheme.baseSpacing4, uiDensity),
                            ),
                            decoration: BoxDecoration(
                              color: hasFine
                                  ? Colors.red.shade50
                                  : Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant,
                              borderRadius: BorderRadius.circular(
                                  AppTheme.getSpacing(
                                      AppTheme.borderRadiusSmall, uiDensity)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.monetization_on_outlined,
                                  size: AppTheme.getFontSize(12, fontSize),
                                  color: hasFine
                                      ? Colors.red.shade700
                                      : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  fineLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                    color: hasFine
                                        ? Colors.red.shade700
                                        : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                          height: AppTheme.getSpacing(
                              AppTheme.baseSpacing8, uiDensity)),

                      // Title
                      Hero(
                        tag: 'law-title-${law.chapter}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            law.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      SizedBox(
                          height: AppTheme.getSpacing(
                              AppTheme.baseSpacing4, uiDensity)),

                      // Category
                      Text(
                        law.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ── Right side: favourite star + arrow ───────────
                SizedBox(
                  width: AppTheme.getSpacing(60, uiDensity),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (law.isFavorite)
                        Icon(
                          Icons.star,
                          color: AppTheme.accentColor,
                          size: AppTheme.getFontSize(20, fontSize),
                        ),
                      SizedBox(
                          width: AppTheme.getSpacing(
                              AppTheme.baseSpacing8, uiDensity)),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: AppTheme.getFontSize(16, fontSize),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}