import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/screens/admin_panel_screen.dart';
import 'package:law_library/screens/about_screen.dart';
import 'package:law_library/screens/favorites_screen.dart';
import 'package:law_library/screens/login_screen.dart';
import 'package:law_library/screens/payment_screen.dart';
import 'package:law_library/screens/settings_screen.dart';
import 'package:law_library/widgets/bottom_navigation.dart';
import 'package:law_library/widgets/category_filter.dart';
import 'package:law_library/widgets/law_list.dart';
import 'package:law_library/widgets/search_bar.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/services/api_service.dart';
import 'package:law_library/l10n/app_localizations.dart';

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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _totalLawsFuture = ApiService().getTotalLawCount();
    _refreshData();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showGuideDialog());

    _screens = const [
      SizedBox(), // Home placeholder
      FavoritesScreen(),
      PaymentScreen(),
      AboutScreen(),
      SettingsScreen(),
    ];
  }

  Future<void> _refreshData() async {
    await context.read<LawProvider>().fetchLaws(refresh: true);
  }

  void _debouncedSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final provider = context.read<LawProvider>();
      provider.setSearchQuery(query.isNotEmpty ? query : null);
      provider.fetchLaws(refresh: true);
    });
  }

  void _handleCategoryChange(String? category) {
    final provider = context.read<LawProvider>();
    provider.setFilterCategory(category);
    provider.fetchLaws(refresh: true);
  }

  double _spacing(double base) =>
      AppTheme.getSpacing(base, context.watch<ThemeProvider>().uiDensity);

  // ------------------------- UI SECTIONS -------------------------

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: AppTheme.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_spacing(AppTheme.borderRadiusMedium)),
      ),
      margin: EdgeInsets.all(_spacing(16)),
      child: Padding(
        padding: EdgeInsets.all(_spacing(16)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/logo.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: _spacing(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeSubtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: _spacing(16),
      vertical: _spacing(8),
    ),
    child: AppSearchBar(
      controller: _searchController,
      onSearch: _debouncedSearch,
    ),
  );

  Widget _buildSearchInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LawProvider>(
      builder: (_, provider, __) {
        if (provider.searchQuery?.isNotEmpty ?? false) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _spacing(16),
              vertical: _spacing(4),
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
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTotalLawsCount(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: AppTheme.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_spacing(AppTheme.borderRadiusMedium)),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _spacing(16),
        vertical: _spacing(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(_spacing(16)),
        child: FutureBuilder<int>(
          future: _totalLawsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              );
            }
            if (snapshot.hasData) {
              return Text(
                l10n.totalLaws(snapshot.data!),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() => Card(
    elevation: AppTheme.elevationSmall,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_spacing(AppTheme.borderRadiusMedium)),
    ),
    margin: EdgeInsets.symmetric(
      horizontal: _spacing(16),
      vertical: _spacing(8),
    ),
    child: Padding(
      padding: EdgeInsets.all(_spacing(16)),
      child: Consumer<LawProvider>(
        builder: (_, provider, __) {
          return CategoryFilter(
            categories: provider.categories,
            selectedCategory: provider.selectedCategory,
            onCategoryChanged: _handleCategoryChange,
          );
        },
      ),
    ),
  );

  Widget _buildLawList() => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: _spacing(16),
      vertical: _spacing(8),
    ),
    child: RefreshIndicator(
      onRefresh: _refreshData,
      child: LawList(scrollController: _scrollController),
    ),
  );

  Widget _buildHomeBody(BuildContext context) => CustomScrollView(
    controller: _scrollController,
    slivers: [
      SliverToBoxAdapter(child: _buildHeader(context)),
      SliverToBoxAdapter(child: _buildSearchBar()),
      SliverToBoxAdapter(child: _buildSearchInfo(context)),
      SliverToBoxAdapter(child: _buildTotalLawsCount(context)),
      SliverToBoxAdapter(child: _buildCategoryFilter()),
      SliverFillRemaining(child: _buildLawList()),
    ],
  );

  void _showGuideDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.welcomeTitle),
        content: SingleChildScrollView(
          child: ListBody(
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.gotIt),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;

    final titles = [
      l10n.homeTitle,
      l10n.tabFavorites,
      l10n.tabPayment,
      l10n.tabAbout,
      l10n.tabSettings,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        actions: [
          if (authProvider.isLoggedIn) ...[
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authProvider.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.logoutSuccess)),
                );
              },
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeBody(context)
          : _screens[_currentIndex],
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
