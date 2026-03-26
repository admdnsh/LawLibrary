import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/widgets/law_list_item.dart';
import 'package:law_library/screens/law_detail_screen.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/widgets/search_bar.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/models/law.dart';

enum _SortBy { title, category, chapter }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _SortBy _sortBy = _SortBy.title;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query);
  }

  List<Law> _processedFavorites(List<Law> favorites) {
    var list = favorites.where((law) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return law.title.toLowerCase().contains(q) ||
          law.description.toLowerCase().contains(q) ||
          law.chapter.toLowerCase().contains(q) ||
          law.category.toLowerCase().contains(q);
    }).toList();

    switch (_sortBy) {
      case _SortBy.category:
        list.sort((a, b) => a.category.compareTo(b.category));
        break;
      case _SortBy.chapter:
        list.sort((a, b) => a.chapter.compareTo(b.chapter));
        break;
      case _SortBy.title:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    return list;
  }

  double _spacing(double base) =>
      AppTheme.getSpacing(base, context.watch<ThemeProvider>().uiDensity);

  String _sortLabel(AppLocalizations l10n) {
    switch (_sortBy) {
      case _SortBy.title:
        return l10n.sortTitle;
      case _SortBy.category:
        return l10n.sortCategory;
      case _SortBy.chapter:
        return l10n.sortChapter;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LawProvider>(
      builder: (context, lawProvider, _) {
        final processed = _processedFavorites(lawProvider.favorites);
        final total = lawProvider.favorites.length;

        return Column(
          children: [
            // ── Search bar ────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                _spacing(AppTheme.baseSpacing16),
                _spacing(AppTheme.baseSpacing16),
                _spacing(AppTheme.baseSpacing16),
                _spacing(AppTheme.baseSpacing8),
              ),
              child: AppSearchBar(
                controller: _searchController,
                onSearch: _handleSearch,
                hintText: l10n.searchFavoritesHint,
              ),
            ),

            // ── Count + Sort row ──────────────────────────────────
            if (total > 0)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _spacing(AppTheme.baseSpacing16),
                  vertical: _spacing(4),
                ),
                child: Row(
                  children: [
                    Text(
                      _searchQuery.isNotEmpty && processed.length != total
                          ? '${processed.length} of ${l10n.savedLawsCount(total)}'
                          : l10n.savedLawsCount(total),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const Spacer(),
                    PopupMenuButton<_SortBy>(
                      initialValue: _sortBy,
                      onSelected: (v) => setState(() => _sortBy = v),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _SortBy.title,
                          child: Text(l10n.sortByTitle),
                        ),
                        PopupMenuItem(
                          value: _SortBy.category,
                          child: Text(l10n.sortByCategory),
                        ),
                        PopupMenuItem(
                          value: _SortBy.chapter,
                          child: Text(l10n.sortByChapter),
                        ),
                      ],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sort,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _sortLabel(l10n),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // ── Empty state ───────────────────────────────────────
            if (processed.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchQuery.isEmpty
                            ? Icons.favorite_border
                            : Icons.search_off,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                      ),
                      SizedBox(height: _spacing(AppTheme.baseSpacing16)),
                      Text(
                        _searchQuery.isEmpty
                            ? l10n.noFavoritesTitle
                            : l10n.noSearchResultsTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: _spacing(AppTheme.baseSpacing8)),
                      Text(
                        _searchQuery.isEmpty
                            ? l10n.noFavoritesDescription
                            : l10n.noSearchResultsDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (_searchQuery.isEmpty) ...[
                        SizedBox(height: _spacing(AppTheme.baseSpacing16)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.swipe_left_outlined,
                                  size: 18,
                                  color:
                                      Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Swipe left on any law to save it',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95)),
                ),
              ),

            // ── Favorites list ────────────────────────────────────
            if (processed.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => lawProvider.loadFavorites(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(_spacing(AppTheme.baseSpacing16)),
                    itemCount: processed.length,
                    itemBuilder: (context, index) {
                      final law = processed[index];
                      return LawListItem(
                        law: law,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LawDetailScreen(law: law),
                          ),
                        ),
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
          ],
        );
      },
    );
  }
}
