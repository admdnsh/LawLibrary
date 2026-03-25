import 'package:flutter/material.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/services/api_service.dart';
import 'package:law_library/services/database_service.dart';

class LawProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();

  // ------------------- State -------------------
  List<Law> _laws = [];
  List<Law> _favorites = [];
  List<String> _categories = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasMorePages = true;

  String? _searchQuery;
  String? _selectedCategory;

  // ------------------- Getters -------------------
  List<Law> get laws => _laws;
  List<Law> get favorites => _favorites;
  List<String> get categories => _categories;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasMorePages;
  bool get hasPreviousPage => _currentPage > 1;

  String? get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  // ------------------- Init -------------------
  Future<void> initialize() async {
    await fetchCategories();
    //await fetchLaws(reset: true);//
    await loadFavorites();
  }

  // ------------------- Fetch Laws -------------------
  Future<void> fetchLaws({bool reset = false}) async {
    if (reset) {
      if (_isLoading) return;
      _laws = [];
      _hasMorePages = true;
      _isLoading = true;
      _isLoadingMore = false;
    } else {
      if (_isLoading || _isLoadingMore || !_hasMorePages) return;
      _isLoadingMore = true;
    }

    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getLaws(
        page: _currentPage,
        limit: _itemsPerPage,
        searchQuery: _searchQuery,
        filterCategory: _selectedCategory,
      );

      if (reset) {
        _laws = result;
      } else {
        _laws = [..._laws, ...result];
      }
      _hasMorePages = result.length == _itemsPerPage;

      _syncFavorites();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // ------------------- Categories -------------------
  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.getCategories();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ------------------- Search & Filter -------------------
  void setSearchQuery(String? query) {
    _searchQuery = query?.isNotEmpty == true ? query : null;
    _currentPage = 1;
    fetchLaws(reset: true);
  }

  void setFilterCategory(String? category) {
    _selectedCategory = category;
    _currentPage = 1;
    fetchLaws(reset: true);
  }

  // ------------------- Pagination -------------------
  Future<void> nextPage() async {
    if (!_hasMorePages || _isLoading || _isLoadingMore) return;
    _currentPage++;
    await fetchLaws(reset: false);
  }

  void setPage(int page) {
    if (page < 1 || _isLoading) return;
    _currentPage = page;
    fetchLaws(reset: true);
  }

  // ------------------- Favorites -------------------
  Future<void> loadFavorites() async {
    try {
      _favorites = await _databaseService.getFavorites();
      _syncFavorites();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Law law) async {
    try {
      final isFav = await _databaseService.isFavorite(law.chapter);

      if (isFav) {
        await _databaseService.removeFavorite(law.chapter);
        _favorites.removeWhere((l) => l.chapter == law.chapter);
      } else {
        await _databaseService.addFavorite(law);
        _favorites.add(law.copyWith(isFavorite: true));
      }

      _syncFavorites();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearFavorites() async {
    try {
      await _databaseService.clearFavorites();
      _favorites.clear();
      _syncFavorites();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _syncFavorites() {
    final favChapters = _favorites.map((e) => e.chapter).toSet();

    _laws = _laws.map((law) {
      return law.copyWith(
        isFavorite: favChapters.contains(law.chapter),
      );
    }).toList();
  }

  // ------------------- Error -------------------
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ------------------- Admin CRUD -------------------
  Future<bool> createLaw(Law law) async {
    try {
      final success = await _apiService.createLaw(law);
      if (success) {
        await fetchLaws(reset: true);
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLaw(Law law, {required String originalChapter}) async {
    try {
      final success = await _apiService.updateLaw(
        law,
        originalChapter: originalChapter,
      );
      if (success) {
        await fetchLaws(reset: true);
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLaw(String chapter) async {
    try {
      final success = await _apiService.deleteLaw(chapter);
      if (success) {
        if (await _databaseService.isFavorite(chapter)) {
          await _databaseService.removeFavorite(chapter);
          _favorites.removeWhere((l) => l.chapter == chapter);
        }
        _laws.removeWhere((l) => l.chapter == chapter);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
