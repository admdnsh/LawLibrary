import 'package:flutter/foundation.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Law> _favorites = [];

  List<Law> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favorites = await _db.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Law law) async {
    if (_favorites.any((f) => f.chapter == law.chapter)) {
      await _db.removeFavorite(law.chapter);
      _favorites.removeWhere((f) => f.chapter == law.chapter);
    } else {
      await _db.addFavorite(law);
      _favorites.add(law.copyWith(isFavorite: true));
    }
    notifyListeners();
  }

  /// Sync favorites with the master law list (from LawProvider)
  List<Law> syncWithLawList(List<Law> allLaws) {
    final favoriteChapters =
    _favorites.map((f) => f.chapter).toSet();

    return allLaws.map((law) {
      return law.copyWith(
        isFavorite: favoriteChapters.contains(law.chapter),
      );
    }).toList();
  }
}
