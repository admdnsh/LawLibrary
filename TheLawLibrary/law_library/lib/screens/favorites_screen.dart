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

  List<Law> _filterFavorites(List<Law> allLaws) {
    final favorites = allLaws.where((law) => law.isFavorite).toList();

    if (_searchQuery.isEmpty) return favorites;

    final searchLower = _searchQuery.toLowerCase();
    return favorites.where((law) {
      return law.title.toLowerCase().contains(searchLower) ||
          law.description.toLowerCase().contains(searchLower) ||
          law.chapter.toLowerCase().contains(searchLower) ||
          law.category.toLowerCase().contains(searchLower);
    }).toList();
  }

  double _spacing(double base) =>
      AppTheme.getSpacing(base, context.watch<ThemeProvider>().uiDensity);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LawProvider>(
      builder: (context, lawProvider, _) {
        final allLaws = lawProvider.laws;
        final filteredFavorites = _filterFavorites(allLaws);

        return Column(
          children: [
            // ---------------- Search Bar ----------------
            Padding(
              padding: EdgeInsets.all(_spacing(AppTheme.baseSpacing16)),
              child: AppSearchBar(
                controller: _searchController,
                onSearch: _handleSearch,
                hintText: l10n.searchFavoritesHint,
              ),
            ),

            // ---------------- Empty State ----------------
            if (filteredFavorites.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchQuery.isEmpty ? Icons.favorite_border : Icons.search_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            // ---------------- Favorites List ----------------
            if (filteredFavorites.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(_spacing(AppTheme.baseSpacing16)),
                  itemCount: filteredFavorites.length,
                  itemBuilder: (context, index) {
                    final law = filteredFavorites[index];

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
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: index * 50),
                    ).slideX(
                      begin: 0.1,
                      end: 0,
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: index * 50),
                      curve: Curves.easeOutQuad,
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
