import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item.dart';

class FavoritesProvider with ChangeNotifier {
  static const String _favoritesKey = 'favorites';
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteIds.addAll(favorites);
    notifyListeners();
  }

  Future<void> toggleFavorite(MenuItem item) async {
    if (_favoriteIds.contains(item.id)) {
      _favoriteIds.remove(item.id);
    } else {
      _favoriteIds.add(item.id);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
    notifyListeners();
  }

  bool isFavorite(MenuItem item) => _favoriteIds.contains(item.id);
} 