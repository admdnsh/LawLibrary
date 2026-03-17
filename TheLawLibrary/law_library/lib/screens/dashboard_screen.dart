import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/services/api_service.dart';
import 'package:law_library/services/recent_searches_service.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  final RecentSearchesService _recentSearchesService = RecentSearchesService();

  // Futures for each data source
  late Future<_DashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboardData();
  }

  Future<_DashboardData> _loadDashboardData() async {
    // Fetch all three data sources in parallel
    final results = await Future.wait([
      _apiService.getTotalLawCount(),
      _apiService.getCategories(),
      _recentSearchesService.getAll(),
    ]);

    final totalLaws = results[0] as int;
    final categories = results[1] as List<String>;
    final recentSearches = results[2] as List<String>;

    // Fetch law count per category in parallel
    final categoryCountFutures = categories.map((category) async {
      final laws = await _apiService.getLaws(
        page: 1,
        limit: 1,
        filterCategory: category,
      );
      // getLaws returns up to 'limit' items — we need total count
      // We fetch with limit=999 to approximate total per category
      final allLaws = await _apiService.getLaws(
        page: 1,
        limit: 999,
        filterCategory: category,
      );
      return MapEntry(category, allLaws.length);
    });

    final categoryEntries = await Future.wait(categoryCountFutures);
    final categoryCounts = Map<String, int>.fromEntries(categoryEntries);

    // Sort categories by count descending
    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _DashboardData(
      totalLaws: totalLaws,
      categoryCounts: sortedCategories,
      recentSearches: recentSearches,
    );
  }

  void _refresh() {
    setState(() {
      _dashboardFuture = _loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final uiDensity = themeProvider.uiDensity;
    final spacing = AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity);

    return FutureBuilder<_DashboardData>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        // ── Loading ────────────────────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ──────────────────────────────────────────────
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(spacing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off,
                      size: 56,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load dashboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check your connection and try again.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!;

        // ── Dashboard ──────────────────────────────────────────
        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: EdgeInsets.all(spacing),
            children: [
              // ── Total laws metric card ───────────────────────
              _buildTotalLawsCard(context, uiDensity, data.totalLaws),

              SizedBox(height: spacing),

              // ── Laws by category ─────────────────────────────
              _buildSectionHeader(context, Icons.category_outlined,
                  'Laws by Category'),
              SizedBox(
                  height: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity)),
              _buildCategoryList(context, uiDensity, data.categoryCounts,
                  data.totalLaws),

              SizedBox(height: spacing),

              // ── Most searched terms ──────────────────────────
              _buildSectionHeader(
                  context, Icons.history, 'Recent Searches'),
              SizedBox(
                  height: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity)),
              _buildRecentSearches(context, uiDensity, data.recentSearches),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // TOTAL LAWS CARD
  // --------------------------------------------------

  Widget _buildTotalLawsCard(
      BuildContext context, UiDensity uiDensity, int totalLaws) {
    return Container(
      padding: EdgeInsets.all(
          AppTheme.getSpacing(AppTheme.baseSpacing24, uiDensity)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Laws',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$totalLaws',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Road offences in database',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.gavel,
            size: 56,
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withOpacity(0.2),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.05, end: 0);
  }

  // --------------------------------------------------
  // SECTION HEADER
  // --------------------------------------------------

  Widget _buildSectionHeader(
      BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon,
            size: 18, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 350.ms, delay: 100.ms);
  }

  // --------------------------------------------------
  // CATEGORY LIST WITH BAR INDICATORS
  // --------------------------------------------------

  Widget _buildCategoryList(
      BuildContext context,
      UiDensity uiDensity,
      List<MapEntry<String, int>> categoryCounts,
      int totalLaws,
      ) {
    if (categoryCounts.isEmpty) {
      return _buildEmptyState(context, 'No category data available');
    }

    final maxCount =
        categoryCounts.first.value; // Already sorted descending

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: categoryCounts.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value.key;
          final count = entry.value.value;
          final fraction = maxCount > 0 ? count / maxCount : 0.0;
          final isLast = index == categoryCounts.length - 1;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category name + count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            category,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$count',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 6,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                duration: 350.ms,
                delay: Duration(milliseconds: 150 + index * 60),
              )
                  .slideX(begin: 0.05, end: 0),
              if (!isLast)
                Divider(
                  height: 1,
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.3),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // --------------------------------------------------
  // RECENT SEARCHES
  // --------------------------------------------------

  Widget _buildRecentSearches(
      BuildContext context,
      UiDensity uiDensity,
      List<String> searches,
      ) {
    if (searches.isEmpty) {
      return _buildEmptyState(
          context, 'No searches yet — start searching to see history here');
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: searches.asMap().entries.map((entry) {
          final index = entry.key;
          final query = entry.value;
          final isLast = index == searches.length - 1;
          // Rank badge colour — gold for 1st, silver for 2nd, bronze for 3rd
          final Color rankColor = index == 0
              ? Colors.amber.shade600
              : index == 1
              ? Colors.blueGrey.shade400
              : index == 2
              ? Colors.brown.shade400
              : Theme.of(context).colorScheme.outlineVariant;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: rankColor,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  query,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.history,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.5),
                ),
              )
                  .animate()
                  .fadeIn(
                duration: 350.ms,
                delay: Duration(milliseconds: 200 + index * 60),
              )
                  .slideX(begin: 0.05, end: 0),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56,
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.3),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // --------------------------------------------------
  // EMPTY STATE
  // --------------------------------------------------

  Widget _buildEmptyState(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// --------------------------------------------------
// DATA MODEL
// --------------------------------------------------

class _DashboardData {
  final int totalLaws;
  final List<MapEntry<String, int>> categoryCounts;
  final List<String> recentSearches;

  _DashboardData({
    required this.totalLaws,
    required this.categoryCounts,
    required this.recentSearches,
  });
}