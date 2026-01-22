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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:law_library/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final ScrollController _mainScrollController = ScrollController();
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
    final lawProvider = Provider.of<LawProvider>(context, listen: false);
    await lawProvider.fetchLaws(refresh: true);
  }

  void _handleSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final lawProvider = Provider.of<LawProvider>(context, listen: false);
      lawProvider.setSearchQuery(query.isNotEmpty ? query : null);
      lawProvider.fetchLaws(refresh: true);
    });
  }

  void _handleCategoryChange(String? category) {
    final lawProvider = Provider.of<LawProvider>(context, listen: false);
    lawProvider.setFilterCategory(category);
    lawProvider.fetchLaws(refresh: true);
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return const FavoritesScreen();
      case 2:
        return const PaymentScreen();
      case 3:
        return const AboutScreen();
      case 4:
        return const SettingsScreen();
      default:
        return _buildHomeBody();
    }
  }

  Widget _buildHomeBody() {
    final theme = context.watch<ThemeProvider>();
    final uiDensity = theme.uiDensity;

    return CustomScrollView(
      controller: _mainScrollController,
      slivers: [
        // --- Header ---
        SliverToBoxAdapter(
          child: _buildHomeHeader().animate().fadeIn(duration: 400.ms),
        ),

        // --- Search Bar ---
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
            child: AppSearchBar(
              controller: _searchController,
              onSearch: _handleSearch,
            ),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),
        ),

        // --- Search Results Info ---
        SliverToBoxAdapter(
          child: Consumer<LawProvider>(
            builder: (context, lawProvider, _) {
              if (lawProvider.searchQuery != null && lawProvider.searchQuery!.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
                    vertical: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 16, color: Theme.of(context).colorScheme.secondary),
                      SizedBox(width: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
                      Expanded(
                        child: Text(
                          'Found ${lawProvider.laws.length} ${lawProvider.laws.length == 1 ? 'entry' : 'entries'} for "${lawProvider.searchQuery}"',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        // --- Total Laws Count ---
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
              vertical: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
            ),
            child: FutureBuilder<int>(
              future: _totalLawsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Theme.of(context).colorScheme.error));
                } else if (snapshot.hasData) {
                  return Text(
                    'Total Laws: ${snapshot.data}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.left,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),

        // --- Category Filter ---
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
            ),
            child: Consumer<LawProvider>(
              builder: (context, lawProvider, _) {
                return CategoryFilter(
                  categories: lawProvider.categories,
                  selectedCategory: lawProvider.selectedCategory,
                  onCategoryChanged: _handleCategoryChange,
                );
              },
            ),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),
        ),

        // --- Law List ---
        SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: LawList(scrollController: _mainScrollController),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/logo.png', width: 80, height: 80, fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('JSKLL Law Library', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  'A modern law library app for searching, browsing, and managing legal information efficiently.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGuideDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to Law Library!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const [
              Text("Here's how to use the app:"),
              SizedBox(height: 12),
              Text('• Use the search bar at the top to find laws by keywords.'),
              Text('• Filter laws by category using the dropdown below the search bar.'),
              Text('• Tap a law to view its details.'),
              Text('• Tap the star icon to add or remove a law from your favorites.'),
              Text('• Use the bottom navigation to switch between Home, Favorites, About, and Settings.'),
              Text('• Admins can access the Admin Panel from the top right menu.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Law Library'
              : _currentIndex == 1
              ? 'Favorites'
              : _currentIndex == 2
              ? 'Payment'
              : _currentIndex == 3
              ? 'About'
              : 'Settings',
        ),
        actions: [
          if (authProvider.isLoggedIn) ...[
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdminPanelScreen(),
                  ));
                },
                tooltip: 'Admin Panel',
              ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authProvider.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              tooltip: 'Logout',
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              tooltip: 'Login',
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: AppBottomNavigation(currentIndex: _currentIndex, onTap: _onTabChanged),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
