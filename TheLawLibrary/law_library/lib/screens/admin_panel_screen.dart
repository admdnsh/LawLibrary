import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/screens/law_form_screen.dart';
import 'package:law_library/screens/manage_users_screen.dart';
import 'package:law_library/services/api_service.dart';
import 'package:law_library/l10n/app_localizations.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  Timer? _debounce;
  Future<int>? _totalCountFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _totalCountFuture = _apiService.getTotalLawCount();
    final provider = context.read<LawProvider>();
    provider.setFilterCategory(null);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<LawProvider>().setSearchQuery(query.isEmpty ? null : query);
    });
  }

  void _onCategoryChanged(String? category) {
    setState(() => _selectedCategory = category);
    context.read<LawProvider>().setFilterCategory(category);
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.adminDeleteLawTitle),
        content: Text(l10n.adminDeleteLawMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  // --------------------------------------------------
  // STATS BANNER
  // --------------------------------------------------

  Widget _buildStatsBanner(
      BuildContext context, LawProvider lawProvider, double spacing) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, spacing, spacing, 0),
      child: Row(
        children: [
          Expanded(
            child: FutureBuilder<int>(
              future: _totalCountFuture,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return _buildStatCard(
                  context,
                  icon: Icons.gavel_outlined,
                  label: l10n.dashboardTotalLaws,
                  value: snapshot.connectionState == ConnectionState.waiting
                      ? '—'
                      : '$count',
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.category_outlined,
              label: l10n.adminCategories,
              value: '${lawProvider.categories.length}',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.list_outlined,
              label: l10n.adminThisPage,
              value: '${lawProvider.laws.length}',
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0);
  }

  Widget _buildStatCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 16,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(0.7)),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CATEGORY FILTER CHIPS
  // --------------------------------------------------

  Widget _buildCategoryFilter(
      BuildContext context, LawProvider lawProvider, double spacing) {
    if (lawProvider.categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing),
        children: [
          // All chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(AppLocalizations.of(context)!.adminFilterAll),
              selected: _selectedCategory == null,
              onSelected: (_) => _onCategoryChanged(null),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor:
              Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          // Category chips
          ...lawProvider.categories.map((category) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (_) => _onCategoryChanged(
                  _selectedCategory == category ? null : category),
              selectedColor:
              Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor:
              Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          )),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final uiDensity = themeProvider.uiDensity;
    final spacing = AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminPanelTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts_outlined),
            tooltip: 'Manage Users',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<LawProvider>(
        builder: (context, lawProvider, _) {
          if (lawProvider.isLoading && lawProvider.laws.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stats banner ─────────────────────────────────
              _buildStatsBanner(context, lawProvider, spacing),

              SizedBox(height: spacing),

              // ── Search bar ───────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    labelText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.getSpacing(
                            AppTheme.borderRadiusMedium, uiDensity),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                        : null,
                  ),
                ),
              ),

              SizedBox(
                  height:
                  AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),

              // ── Category filter chips ─────────────────────────
              _buildCategoryFilter(context, lawProvider, spacing),

              SizedBox(
                  height:
                  AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),

              // ── Active filter indicator ──────────────────────
              if (_selectedCategory != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.adminFilteringBy(_selectedCategory!),
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _onCategoryChanged(null),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Empty state ──────────────────────────────────
              if (lawProvider.laws.isEmpty && !lawProvider.isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 56,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.searchNoResultsTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedCategory != null
                              ? l10n.adminNoLawsInCategory(_selectedCategory!)
                              : l10n.adminNoLawsHint,
                          style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          icon: const Icon(Icons.add),
                          label: Text(l10n.adminAddLaw),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LawFormScreen()),
                          ),
                        ),
                      ],
                    ).animate().fadeIn().scale(),
                  ),
                )

              // ── Law list ─────────────────────────────────────
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => lawProvider.fetchLaws(reset: true),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(spacing, 8, spacing, 90),
                      itemCount: lawProvider.laws.length,
                      itemBuilder: (context, index) {
                        final Law law = lawProvider.laws[index];

                        return Card(
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.only(bottom: spacing),
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(16, 12, 8, 12),
                            child: Row(
                              children: [
                                // ── Main content ──────────────
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                              BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              law.chapter,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              law.category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        law.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                            fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // ── Action buttons ────────────
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                      tooltip: l10n.edit,
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              LawFormScreen(law: law),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error,
                                        size: 20,
                                      ),
                                      tooltip: l10n.delete,
                                      onPressed: () async {
                                        final confirmed =
                                        await _confirmDelete(context);
                                        if (confirmed) {
                                          final success =
                                          await lawProvider.deleteLaw(
                                              law.chapter);
                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    l10n.adminLawDeleted),
                                              ),
                                            );
                                            // Refresh total count
                                            setState(() {
                                              _totalCountFuture = _apiService
                                                  .getTotalLawCount();
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(
                          duration: 350.ms,
                          delay: Duration(milliseconds: index * 40),
                        );
                      },
                    ),
                  ),
                ),

              // ── Pagination ───────────────────────────────────
              if (!lawProvider.isLoading && lawProvider.laws.isNotEmpty)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: lawProvider.currentPage > 1
                              ? () => lawProvider
                              .setPage(lawProvider.currentPage - 1)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${l10n.adminPage(lawProvider.currentPage)}'
                                '${lawProvider.hasNextPage ? '' : ' ${l10n.adminPageLast}'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: lawProvider.hasNextPage
                              ? () => lawProvider
                              .setPage(lawProvider.currentPage + 1)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      // ── Add Law FAB ────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.adminAddLaw),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LawFormScreen()),
        ).then((_) {
          // Refresh total count after returning from form
          setState(() {
            _totalCountFuture = _apiService.getTotalLawCount();
          });
        }),
      ),
    );
  }
}