import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/widgets/search_bar.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/screens/law_detail_screen.dart';
import 'package:law_library/providers/theme_provider.dart';

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

  List<Law> _filterFavorites(List<Law> favorites) {
    if (_searchQuery.isEmpty) return favorites;

    return favorites.where((law) {
      final searchLower = _searchQuery.toLowerCase();
      return law.title.toLowerCase().contains(searchLower) ||
          law.description.toLowerCase().contains(searchLower) ||
          law.chapter.toLowerCase().contains(searchLower) ||
          law.category.toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LawProvider>(
      builder: (context, lawProvider, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final uiDensity = themeProvider.uiDensity;

        final filteredFavorites = _filterFavorites(lawProvider.favorites);

        if (lawProvider.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                SizedBox(
                    height:
                        AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
                Text(
                  'No favorites yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                    height:
                        AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
                Text(
                  'Add laws to your favorites to see them here',
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
            // Search bar
            Padding(
              padding: EdgeInsets.all(
                  AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
              child: AppSearchBar(
                controller: _searchController,
                onSearch: _handleSearch,
                hintText: 'Search favorites...',
              ),
            ),
            // Search results count
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
                  right: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
                  bottom: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(
                        width: AppTheme.getSpacing(
                            AppTheme.baseSpacing8, uiDensity)),
                    Text(
                      'Found ${filteredFavorites.length} ${filteredFavorites.length == 1 ? 'entry' : 'entries'} for "$_searchQuery"',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
            // Favorites list
            Expanded(
              child: filteredFavorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ),
                          SizedBox(
                              height: AppTheme.getSpacing(
                                  AppTheme.baseSpacing16, uiDensity)),
                          Text(
                            'No matches found',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                              height: AppTheme.getSpacing(
                                  AppTheme.baseSpacing8, uiDensity)),
                          Text(
                            'Try adjusting your search',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(AppTheme.getSpacing(
                          AppTheme.baseSpacing16, uiDensity)),
                      itemCount: filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final law = filteredFavorites[index];
                        return Card(
                          margin: EdgeInsets.only(
                              bottom: AppTheme.getSpacing(
                                  AppTheme.baseSpacing16, uiDensity)),
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
                                  'Chapter ${law.chapter} • ${law.category}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon:
                                  const Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => lawProvider.toggleFavorite(law),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LawDetailScreen(law: law),
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
