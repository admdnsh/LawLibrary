import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesService {
  static const _key = 'recent_searches';
  static const _maxItems = 5;

  /// Returns the saved list, most recent first.
  Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Adds a query to the front of the list, deduplicates, and trims to [_maxItems].
  Future<List<String>> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return getAll();

    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    // Remove duplicate if it already exists, then insert at front
    current.removeWhere((q) => q.toLowerCase() == trimmed.toLowerCase());
    current.insert(0, trimmed);

    // Keep only the most recent [_maxItems]
    final updated = current.take(_maxItems).toList();
    await prefs.setStringList(_key, updated);
    return updated;
  }

  /// Clears all saved searches.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}