import 'package:flutter/material.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/services/api_service.dart';
import 'package:law_library/services/database_service.dart';

class LawProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();

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
  bool get hasMorePages => _hasMorePages;
  String? get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  int get currentPage => _currentPage;

  // ------------------- Initialization -------------------
  Future<void> initialize() async {
    await fetchCategories();
    await fetchLaws(refresh: true);
    await loadFavorites();
  }

  // ------------------- Fetch Laws -------------------
  Future<void> fetchLaws({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newLaws = await _apiService.getLaws(
        page: _currentPage,
        limit: _itemsPerPage,
        searchQuery: _searchQuery,
        filterCategory: _selectedCategory,
      );

      if (refresh) {
        _laws = newLaws;
      } else {
        _laws.addAll(newLaws);
      }

      _hasMorePages = newLaws.length == _itemsPerPage;
      _updateFavoriteStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------- Fetch Categories -------------------
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------- Search & Filter -------------------
  void setSearchQuery(String? query) {
    _searchQuery = query;
    _currentPage = 1;
    _hasMorePages = true;
    fetchLaws(refresh: true);
  }

  void setFilterCategory(String? category) {
    _selectedCategory = category;
    _currentPage = 1;
    _hasMorePages = true;
    fetchLaws(refresh: true);
  }

  // ------------------- Favorites -------------------
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _databaseService.getFavorites();
      _updateFavoriteStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Law law) async {
    try {
      final isFav = await _databaseService.isFavorite(law.chapter);

      if (isFav) {
        await _databaseService.removeFavorite(law.chapter);
        _favorites.removeWhere((item) => item.chapter == law.chapter);
      } else {
        await _databaseService.addFavorite(law);
        _favorites.add(law.copyWith(isFavorite: true));
      }

      _updateFavoriteStatus();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _updateFavoriteStatus() {
    final favoriteChapters = _favorites.map((law) => law.chapter).toSet();

    for (int i = 0; i < _laws.length; i++) {
      _laws[i] = _laws[i].copyWith(
        isFavorite: favoriteChapters.contains(_laws[i].chapter),
      );
    }
  }

  Future<void> clearFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.clearFavorites();
      _favorites = [];
      _updateFavoriteStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------- Pagination -------------------
  void setPage(int page) {
    if (page > 0) {
      _currentPage = page;
      fetchLaws(refresh: true);
    }
  }

  // ------------------- Error Handling -------------------
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ------------------- CRUD Operations (Admin) -------------------
  Future<bool> createLaw(Law law) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.createLaw(law);
      if (result) {
        await fetchLaws(refresh: true);
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateLaw(Law law, {required String originalChapter}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result =
      await _apiService.updateLaw(law, originalChapter: originalChapter);
      if (result) {
        await fetchLaws(refresh: true);
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteLaw(String chapter) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.deleteLaw(chapter);
      if (result) {
        if (await _databaseService.isFavorite(chapter)) {
          await _databaseService.removeFavorite(chapter);
          _favorites.removeWhere((item) => item.chapter == chapter);
        }

        _laws.removeWhere((item) => item.chapter == chapter);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
