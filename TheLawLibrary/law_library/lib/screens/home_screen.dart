import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:law_library/l10n/app_localizations.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/auth_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/services/recent_searches_service.dart';

import 'package:law_library/widgets/bottom_navigation.dart';
import 'package:law_library/widgets/search_bar.dart';
import 'package:law_library/widgets/law_list.dart';

import 'package:law_library/screens/favorites_screen.dart';
import 'package:law_library/screens/payment_screen.dart';
import 'package:law_library/screens/about_screen.dart';
import 'package:law_library/screens/settings_screen.dart';
import 'package:law_library/screens/login_screen.dart';
import 'package:law_library/screens/admin_panel_screen.dart';
import 'package:law_library/screens/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RecentSearchesService _recentSearchesService = RecentSearchesService();

  int _currentIndex = 0;
  Timer? _debounce;
  List<String> _recentSearches = [];

  // Offline state
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // --------------------------------------------------
  // LIFECYCLE
  // --------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _initConnectivity();
  }

  // --------------------------------------------------
  // OFFLINE DETECTION (feature 8)
  // Checks connectivity on load and listens for changes.
  // Shows an orange banner when the device is offline.
  // --------------------------------------------------

  Future<void> _initConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _updateOfflineState(results);
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateOfflineState);
  }

  void _updateOfflineState(List<ConnectivityResult> results) {
    final offline = results.every((r) => r == ConnectivityResult.none);
    if (mounted && offline != _isOffline) {
      setState(() => _isOffline = offline);
    }
  }

  // --------------------------------------------------
  // RECENT SEARCHES
  // --------------------------------------------------

  Future<void> _loadRecentSearches() async {
    final searches = await _recentSearchesService.getAll();
    if (mounted) setState(() => _recentSearches = searches);
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    final updated = await _recentSearchesService.add(query);
    if (mounted) setState(() => _recentSearches = updated);
  }

  Future<void> _clearRecentSearches() async {
    await _recentSearchesService.clear();
    if (mounted) setState(() => _recentSearches = []);
  }

  // --------------------------------------------------
  // SEARCH
  // --------------------------------------------------

  void _handleSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final provider = context.read<LawProvider>();
      provider.setSearchQuery(query.isEmpty ? null : query);
      if (query.isNotEmpty) _saveRecentSearch(query);
    });
  }

  void _applyRecentSearch(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    context.read<LawProvider>().setSearchQuery(query);
    _saveRecentSearch(query);
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  // --------------------------------------------------
  // OFFLINE BANNER
  // --------------------------------------------------

  Widget _buildOfflineBanner() {
    return AnimatedSlide(
      offset: _isOffline ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: _isOffline ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: double.infinity,
          color: Colors.orange.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You\'re offline — results may be limited or unavailable',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HOME BODY
  // --------------------------------------------------

  Widget _buildHomeBody(BuildContext context, AppLocalizations l10n) {
    return Consumer<LawProvider>(
      builder: (context, provider, _) {
        final bool isIdle = provider.searchQuery == null;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              // ── Offline banner ────────────────────────────────────
              _buildOfflineBanner(),

              // ── Top section: always visible ───────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                padding: EdgeInsets.fromLTRB(
                  24,
                  isIdle ? 0 : 24,
                  24,
                  isIdle ? 0 : 12,
                ),
                child: isIdle
                    ? _buildIdleLayout(context, l10n, provider)
                    : _buildActiveLayout(context, l10n, provider),
              ),

              // ── Results: only shown when searching ────────────────
              if (!isIdle)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LawList(scrollController: _scrollController),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // IDLE LAYOUT
  // --------------------------------------------------

  Widget _buildIdleLayout(
      BuildContext context,
      AppLocalizations l10n,
      LawProvider provider,
      ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', width: 96)
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 500))
              .scale(
            begin: const Offset(0.85, 0.85),
            end: const Offset(1, 1),
          ),

          const SizedBox(height: 20),

          Text(
            l10n.homeTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 100),
          )
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 6),

          Text(
            l10n.homeSubtitle,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 150),
          ),

          const SizedBox(height: 32),

          AppSearchBar(
            controller: _searchController,
            hintText: l10n.searchHint,
            onSearch: _handleSearch,
          )
              .animate()
              .fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 200),
          )
              .slideY(begin: 0.15, end: 0),

          if (_recentSearches.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildRecentSearches(context),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.history,
                    size: 14,
                    color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  'Recent',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _clearRecentSearches,
              child: Text(
                'Clear',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: const Duration(milliseconds: 250),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.asMap().entries.map((entry) {
            final index = entry.key;
            final query = entry.value;
            return ActionChip(
              avatar: Icon(
                Icons.history,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              label: Text(query),
              onPressed: () => _applyRecentSearch(query),
              backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            )
                .animate()
                .fadeIn(
              duration: const Duration(milliseconds: 300),
              delay: Duration(milliseconds: 270 + (index * 50)),
            )
                .slideX(begin: 0.1, end: 0);
          }).toList(),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // ACTIVE LAYOUT
  // --------------------------------------------------

  Widget _buildActiveLayout(
      BuildContext context,
      AppLocalizations l10n,
      LawProvider provider,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/logo.png', width: 40),
            const SizedBox(width: 12),
            Text(
              l10n.homeTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        AppSearchBar(
          controller: _searchController,
          hintText: l10n.searchHint,
          onSearch: _handleSearch,
        ),

        const SizedBox(height: 8),

        if (!provider.isLoading)
          Text(
            l10n.searchFound(provider.laws.length, provider.searchQuery!),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 250))
              .slideY(begin: -0.1, end: 0),
      ],
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            l10n.tabHome,
            l10n.tabFavorites,
            'Dashboard',
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
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeBody(context, l10n)
          : [
        const SizedBox(),
        const FavoritesScreen(),
        const DashboardScreen(),
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
    _scrollController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}