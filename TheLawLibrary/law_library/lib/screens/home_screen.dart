import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:law_library/l10n/app_localizations.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/services/api_service.dart';

import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/widgets/bottom_navigation.dart';
import 'package:law_library/widgets/search_bar.dart';
import 'package:law_library/widgets/category_filter.dart';
import 'package:law_library/widgets/law_list.dart';

import 'package:law_library/screens/favorites_screen.dart';
import 'package:law_library/screens/payment_screen.dart';
import 'package:law_library/screens/about_screen.dart';
import 'package:law_library/screens/settings_screen.dart';
import 'package:law_library/screens/login_screen.dart';
import 'package:law_library/screens/admin_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;
  Timer? _debounce;
  Future<int>? _totalLawsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _totalLawsFuture = ApiService().getTotalLawCount();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGuideDialog();
    });
  }

  Future<void> _refreshData() async {
    await context.read<LawProvider>().fetchLaws(refresh: true);
  }

  void _handleSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final provider = context.read<LawProvider>();
      provider.setSearchQuery(query.isEmpty ? null : query);
      provider.fetchLaws(refresh: true);
    });
  }

  void _handleCategoryChange(String? category) {
    final provider = context.read<LawProvider>();
    provider.setFilterCategory(category);
    provider.fetchLaws(refresh: true);
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  // --------------------------------------------------
  // HOME BODY
  // --------------------------------------------------

  Widget _buildHomeBody(
      BuildContext context,
      AppLocalizations l10n,
      UiDensity uiDensity,
      ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _buildHeader(context, l10n),
        ),

        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(
              AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
            ),
            child: AppSearchBar(
              controller: _searchController,
              hintText: l10n.searchHint,
              onSearch: _handleSearch,
            ),
          ),
        ),

        // Search result text
        SliverToBoxAdapter(
          child: Consumer<LawProvider>(
            builder: (context, provider, _) {
              if (provider.searchQuery?.isNotEmpty == true) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.getSpacing(
                        AppTheme.baseSpacing16, uiDensity),
                  ),
                  child: Text(
                    l10n.searchFound(
                      provider.laws.length,
                      provider.searchQuery!,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 300))
                    .slideY(begin: -0.1, end: 0);
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        // Total laws count
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
              AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
              vertical:
              AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
            ),
            child: FutureBuilder<int>(
              future: _totalLawsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text(
                    l10n.searchError(snapshot.error.toString()),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
                return Text(
                  l10n.totalLaws(snapshot.data ?? 0),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),

        // Category filter
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
              AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
            ),
            child: Consumer<LawProvider>(
              builder: (context, provider, _) {
                return CategoryFilter(
                  categories: provider.categories,
                  selectedCategory: provider.selectedCategory,
                  onCategoryChanged: _handleCategoryChange,
                );
              },
            ),
          ),
        ),

        // Law list (pagination stays here)
        SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.all(
              AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
            ),
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: LawList(scrollController: _scrollController),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          Image.asset('assets/logo.png', width: 72),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeTitle,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homeSubtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // GUIDE DIALOG
  // --------------------------------------------------

  void _showGuideDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.welcomeTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.welcomeIntro),
            const SizedBox(height: 12),
            Text(l10n.guideSearch),
            Text(l10n.guideFilter),
            Text(l10n.guideTap),
            Text(l10n.guideFavorite),
            Text(l10n.guideNav),
            Text(l10n.guideAdmin),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.gotIt),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            l10n.tabHome,
            l10n.tabFavorites,
            l10n.tabPayment,
            l10n.tabAbout,
            l10n.tabSettings,
          ][_currentIndex],
        ),
        actions: [
          if (auth.isLoggedIn && auth.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
              ),
            ),
          IconButton(
            icon: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),
            onPressed: auth.isLoggedIn
                ? () async {
              await auth.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.logoutSuccess)),
              );
            }
                : () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeBody(context, l10n, theme.uiDensity)
          : [
        const SizedBox(),
        const FavoritesScreen(),
        const PaymentScreen(),
        const AboutScreen(),
        const SettingsScreen(),
      ][_currentIndex],
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
