import 'package:flutter/foundation.dart';
import '../models/law.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class LawRepository {
  final ApiService _apiService = ApiService();

  // Only create DB service on non-web platforms
  final DatabaseService? _dbService =
  kIsWeb ? null : DatabaseService();

  /* -------------------- LAWS (API) -------------------- */

  Future<List<Law>> getLaws({
    int page = 1,
    int limit = 10,
    String? searchQuery,
    String? category,
  }) {
    return _apiService.getLaws(
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      filterCategory: category,
    );
  }

  Future<int> getTotalLawCount() {
    return _apiService.getTotalLawCount();
  }

  Future<List<String>> getCategories() {
    return _apiService.getCategories();
  }

  /* -------------------- FAVORITES -------------------- */

  Future<List<Law>> getFavorites() async {
    if (kIsWeb) return [];
    return _dbService!.getFavorites();
  }

  Future<bool> isFavorite(String chapter) async {
    if (kIsWeb) return false;
    return _dbService!.isFavorite(chapter);
  }

  Future<void> addFavorite(Law law) async {
    if (kIsWeb) return;
    await _dbService!.addFavorite(law);
  }

  Future<void> removeFavorite(String chapter) async {
    if (kIsWeb) return;
    await _dbService!.removeFavorite(chapter);
  }

  Future<void> clearFavorites() async {
    if (kIsWeb) return;
    await _dbService!.clearFavorites();
  }
}
  