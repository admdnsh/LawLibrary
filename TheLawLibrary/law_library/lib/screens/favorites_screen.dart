import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/widgets/search_bar.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/screens/law_detail_screen.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // Filter favorites based on search
  List<Law> _filterFavorites(List<Law> laws) {
    final favorites = laws.where((law) => law.isFavorite).toList();
    if (_searchQuery.isEmpty) return favorites;

    final searchLower = _searchQuery.toLowerCase();
    return favorites.where((law) {
      return law.title.toLowerCase().contains(searchLower) ||
          law.description.toLowerCase().contains(searchLower) ||
          law.chapter.toLowerCase().contains(searchLower) ||
          law.category.toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();
    final uiDensity = themeProvider.uiDensity;

    return Consumer<LawProvider>(
      builder: (context, lawProvider, _) {
        final filteredFavorites = _filterFavorites(lawProvider.laws);

        if (filteredFavorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isEmpty ? Icons.favorite_border : Icons.search_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
                Text(
                  _searchQuery.isEmpty ? l10n.noFavoritesTitle : l10n.noSearchResultsTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
                Text(
                  _searchQuery.isEmpty
                      ? l10n.noFavoritesDescription
                      : l10n.noSearchResultsDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // ---------------- Search Bar ----------------
            Padding(
              padding: EdgeInsets.all(AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
              child: AppSearchBar(
                controller: _searchController,
                onSearch: _handleSearch,
                hintText: l10n.searchFavoritesHint,
              ),
            ),

            // ---------------- Search Result Info ----------------
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
                  vertical: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 16, color: Theme.of(context).colorScheme.secondary),
                    SizedBox(width: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
                    Text(
                      l10n.favoritesSearchResult(filteredFavorites.length, _searchQuery),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),

            // ---------------- Favorites List ----------------
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
                itemCount: filteredFavorites.length,
                itemBuilder: (context, index) {
                  final law = filteredFavorites[index];
                  return Card(
                    margin: EdgeInsets.only(
                      bottom: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
                    ),
                    child: ListTile(
                      title: Text(law.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            law.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.lawChapterCategory(law.chapter, law.category),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => lawProvider.toggleFavorite(law),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LawDetailScreen(law: law),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
