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
  static const List<String> _fallbackSuggestions = [
    'Seatbelt',
    'Speeding',
    'Parking',
    'Helmet',
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final pos = widget.scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      final provider = context.read<LawProvider>();
      if (!provider.isLoading && !provider.isLoadingMore && provider.hasNextPage) {
        provider.nextPage();
      }
    }
  }

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
          final suggestions = lawProvider.categories.isNotEmpty
              ? lawProvider.categories
              : _fallbackSuggestions;

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

                  Text(
                    l10n.noResultsFound,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height:
                      AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),

                  Text(
                    l10n.noResultsHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppTheme.getSpacing(24, uiDensity)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.noResultsTryLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: suggestions.map((suggestion) {
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

        // ── Main list with infinite scroll ────────────────────────
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
                  itemCount: lawProvider.laws.length +
                      (lawProvider.isLoadingMore ? 1 : 0) +
                      (!lawProvider.hasNextPage && lawProvider.laws.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading more spinner at the end
                    if (lawProvider.isLoadingMore &&
                        index == lawProvider.laws.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    // End-of-results indicator
                    if (!lawProvider.hasNextPage &&
                        index == lawProvider.laws.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            '— End of results —',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.6),
                            ),
                          ),
                        ),
                      );
                    }

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
                      delay: Duration(milliseconds: (index % 10) * 40),
                    )
                        .slideX(
                      begin: 0.1,
                      end: 0,
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: (index % 10) * 40),
                      curve: Curves.easeOutQuad,
                    );
                  },
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
