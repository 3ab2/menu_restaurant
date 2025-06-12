import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

enum SortOption { name, price, popularity }

class MenuProvider with ChangeNotifier {
  final List<MenuItem> _menuItems = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortOption _sortOption = SortOption.name;
  bool _sortAscending = true;

  List<MenuItem> get menuItems => _menuItems;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  bool get sortAscending => _sortAscending;

  List<String> get categories {
    final categories = _menuItems.map((item) => item.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<MenuItem> get filteredMenuItems {
    var filtered = _menuItems;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
      switch (_sortOption) {
        case SortOption.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortOption.price:
          comparison = a.price.compareTo(b.price);
          break;
        case SortOption.popularity:
          // For now, we'll use a random number as popularity
          comparison = 0;
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(SortOption option, {bool? ascending}) {
    if (option == _sortOption && ascending == null) {
      _sortAscending = !_sortAscending;
    } else {
      _sortOption = option;
      _sortAscending = ascending ?? true;
    }
    notifyListeners();
  }

  void addMenuItem(MenuItem item) {
    _menuItems.add(item);
    notifyListeners();
  }

  void removeMenuItem(String id) {
    _menuItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateMenuItem(MenuItem updatedItem) {
    final index = _menuItems.indexWhere((item) => item.id == updatedItem.id);
    if (index >= 0) {
      _menuItems[index] = updatedItem;
      notifyListeners();
    }
  }
} 