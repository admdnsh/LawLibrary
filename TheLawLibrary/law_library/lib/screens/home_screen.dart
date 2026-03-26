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
  final FocusNode _searchFocusNode = FocusNode();
  final RecentSearchesService _recentSearchesService = RecentSearchesService();

  int _currentIndex = 0;
  Timer? _debounce;
  List<String> _recentSearches = [];
  List<String> _filteredSuggestions = [];

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
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) _hideSuggestions();
        });
      }
    });
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
    _updateSuggestions(query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final provider = context.read<LawProvider>();
      provider.setSearchQuery(query.isEmpty ? null : query);
      if (query.isNotEmpty) _saveRecentSearch(query);
    });
  }

  void _applyRecentSearch(String query) {
    _hideSuggestions();
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    context.read<LawProvider>().setSearchQuery(query);
    _saveRecentSearch(query);
  }

  // --------------------------------------------------
  // AUTOCOMPLETE SUGGESTIONS
  // --------------------------------------------------

  void _updateSuggestions(String query) {
    if (query.trim().isEmpty) {
      _hideSuggestions();
      return;
    }

    final lowerQuery = query.toLowerCase();
    final provider = context.read<LawProvider>();
    final seen = <String>{};
    final matches = <String>[];

    for (final s in _recentSearches) {
      if (s.toLowerCase().contains(lowerQuery) && seen.add(s)) {
        matches.add(s);
      }
    }

    for (final c in provider.categories) {
      if (c.toLowerCase().contains(lowerQuery) && seen.add(c)) {
        matches.add(c);
      }
    }

    final suggestions = matches.take(6).toList();
    setState(() => _filteredSuggestions = suggestions);
  }

  void _hideSuggestions() {
    if (_filteredSuggestions.isNotEmpty) {
      setState(() => _filteredSuggestions = []);
    }
  }

  Widget _buildSuggestionsCard() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filteredSuggestions.asMap().entries.map((entry) {
            final suggestion = entry.value;
            final isRecent = _recentSearches.contains(suggestion);
            return InkWell(
              onTap: () {
                _hideSuggestions();
                _applyRecentSearch(suggestion);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      isRecent ? Icons.history : Icons.label_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Icon(
                      Icons.north_west,
                      size: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
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
          onTap: () {
            FocusScope.of(context).unfocus();
            _hideSuggestions();
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              // ── Offline banner ────────────────────────────────────
              _buildOfflineBanner(),

              // ── Content area ──────────────────────────────────────
              Expanded(
                child: isIdle
                    ? _buildIdleLayout(context, l10n, provider)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                            child: _buildActiveLayout(context, l10n, provider),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: LawList(scrollController: _scrollController),
                            ),
                          ),
                        ],
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
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
                    focusNode: _searchFocusNode,
                    hintText: l10n.searchHint,
                    onSearch: _handleSearch,
                  )
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 200),
                      )
                      .slideY(begin: 0.15, end: 0),

                  if (_filteredSuggestions.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildSuggestionsCard(),
                  ] else if (_recentSearches.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildRecentSearches(context),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.recentSearches,
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
                l10n.clearSearches,
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
          focusNode: _searchFocusNode,
          hintText: l10n.searchHint,
          onSearch: _handleSearch,
        ),

        if (_filteredSuggestions.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildSuggestionsCard(),
        ],

        const SizedBox(height: 8),

        if (!provider.isLoading && _filteredSuggestions.isEmpty)
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
    final isAdmin = auth.isLoggedIn && auth.isAdmin;

    // Build tab labels and screens dynamically based on role.
    // Index 0 is always Home (handled separately in body).
    final tabLabels = [
      l10n.tabHome,
      l10n.tabFavorites,
      if (isAdmin) l10n.tabDashboard,
      l10n.tabPayment,
      l10n.tabSettings,
    ];

    final tabScreens = [
      const SizedBox(), // Home is rendered via _buildHomeBody
      const FavoritesScreen(),
      if (isAdmin) const DashboardScreen(),
      const PaymentScreen(),
      const SettingsScreen(),
    ];

    // Clamp index in case auth state changed (e.g. logout while on Dashboard).
    final safeIndex = _currentIndex.clamp(0, tabLabels.length - 1);
    if (safeIndex != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) { if (mounted) setState(() => _currentIndex = 0); },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tabLabels[safeIndex]),
        actions: [
          if (isAdmin)
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
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.logoutSuccess)),
                      );
                    }
                  }
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
          ),
        ],
      ),
      body: safeIndex == 0
          ? _buildHomeBody(context, l10n)
          : tabScreens[safeIndex],
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: safeIndex,
        onTap: _onTabChanged,
        isAdmin: isAdmin,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}