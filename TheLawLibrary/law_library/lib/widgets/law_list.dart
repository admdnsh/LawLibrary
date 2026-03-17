import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/widgets/law_list_item.dart';
import 'package:law_library/screens/law_detail_screen.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/l10n/app_localizations.dart';

class LawList extends StatefulWidget {
  final ScrollController scrollController;
  const LawList({super.key, required this.scrollController});

  @override
  State<LawList> createState() => _LawListState();
}

class _LawListState extends State<LawList> {
  // Suggested keywords shown in the no-results state
  static const List<String> _suggestions = [
    'Seatbelt',
    'Speeding',
    'Mobile phone',
    'Parking',
    'Helmet',
    'Lane',
    'Roadtax',
    'Insurance',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LawProvider>(
      builder: (context, lawProvider, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final uiDensity = themeProvider.uiDensity;

        // ── Loading state ────────────────────────────────────────
        if (lawProvider.isLoading && lawProvider.laws.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── No results state ─────────────────────────────────────
        if (lawProvider.laws.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 56,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.4),
                  ),
                  SizedBox(
                      height: AppTheme.getSpacing(
                          AppTheme.baseSpacing16, uiDensity)),

                  // Title
                  Text(
                    'No results found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height:
                      AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),

                  // Helpful hint
                  Text(
                    'Try searching by offence title, chapter number, or category.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                      height: AppTheme.getSpacing(24, uiDensity)),

                  // "Try searching for" label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Try searching for:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Suggestion chips — tapping one triggers a new search
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _suggestions.map((suggestion) {
                        return ActionChip(
                          label: Text(suggestion),
                          onPressed: () {
                            lawProvider.setSearchQuery(suggestion);
                          },
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ).animate().fadeIn().scale(),
            ),
          );
        }

        // ── Main list with pagination ─────────────────────────────
        return Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: widget.scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemCount: lawProvider.laws.length,
                  itemBuilder: (context, index) {
                    final law = lawProvider.laws[index];
                    return LawListItem(
                      law: law,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LawDetailScreen(law: law),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: index * 50),
                    )
                        .slideX(
                      begin: 0.1,
                      end: 0,
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: index * 50),
                      curve: Curves.easeOutQuad,
                    );
                  },
                ),
              ),
            ),

            // ── Pagination controls ───────────────────────────────
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 18),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: lawProvider.hasPreviousPage
                            ? () => lawProvider.previousPage()
                            : null,
                        tooltip: l10n.paginationPrevious,
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          '${lawProvider.currentPage}',
                          style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 18),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: lawProvider.hasNextPage
                            ? () => lawProvider.nextPage()
                            : null,
                        tooltip: l10n.paginationNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Error message ─────────────────────────────────────
            if (lawProvider.error != null)
              Container(
                padding: EdgeInsets.all(
                    AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
                color: Theme.of(context).colorScheme.errorContainer,
                child: Row(
                  children: [
                    Icon(Icons.error,
                        color: Theme.of(context).colorScheme.error),
                    SizedBox(
                        width: AppTheme.getSpacing(
                            AppTheme.baseSpacing8, uiDensity)),
                    Expanded(
                      child: Text(
                        l10n.searchError(lawProvider.error!),
                        style: TextStyle(
                          color:
                          Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: lawProvider.clearError,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}