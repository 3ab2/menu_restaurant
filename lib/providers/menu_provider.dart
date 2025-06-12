import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

enum SortOption { name, price, popularity }

class MenuProvider with ChangeNotifier {
  final List<MenuItem> _items = [
    MenuItem(
      id: '1',
      name: 'Salade César',
      description: 'Laitue romaine, poulet grillé, parmesan, croûtons, sauce césar',
      price: 12.90,
      category: 'Entrées',
      imageUrl: 'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg',
    ),
    MenuItem(
      id: '2',
      name: 'Steak Frites',
      description: 'Steak de bœuf, frites maison, sauce au poivre',
      price: 24.90,
      category: 'Plats',
      imageUrl: 'https://images.pexels.com/photos/1639561/pexels-photo-1639561.jpeg',
    ),
    MenuItem(
      id: '3',
      name: 'Crème Brûlée',
      description: 'Crème vanille, caramel croquant',
      price: 8.90,
      category: 'Desserts',
      imageUrl: 'https://images.pexels.com/photos/2144112/pexels-photo-2144112.jpeg',
    ),
    MenuItem(
      id: '4',
      name: 'Burger Gourmet',
      description: 'Steak de bœuf, cheddar affiné, bacon, oignons caramélisés, sauce secrète',
      price: 16.90,
      category: 'Plats',
      imageUrl: 'https://images.pexels.com/photos/1633578/pexels-photo-1633578.jpeg',
    ),
    MenuItem(
      id: '5',
      name: 'Pizza Margherita',
      description: 'Sauce tomate, mozzarella, basilic frais',
      price: 14.90,
      category: 'Plats',
      imageUrl: 'https://images.pexels.com/photos/825661/pexels-photo-825661.jpeg',
    ),
    MenuItem(
      id: '6',
      name: 'Sushi Mix',
      description: 'Assortiment de sushis et makis frais',
      price: 22.90,
      category: 'Plats',
      imageUrl: 'https://images.pexels.com/photos/2098085/pexels-photo-2098085.jpeg',
    ),
    MenuItem(
      id: '7',
      name: 'Tiramisu',
      description: 'Mascarpone, café, cacao',
      price: 7.90,
      category: 'Desserts',
      imageUrl: 'https://images.pexels.com/photos/2144112/pexels-photo-2144112.jpeg',
    ),
    MenuItem(
      id: '8',
      name: 'Soupe à l\'Oignon',
      description: 'Oignons caramélisés, gratinée au fromage',
      price: 9.90,
      category: 'Entrées',
      imageUrl: 'https://images.pexels.com/photos/539451/pexels-photo-539451.jpeg',
    ),
    MenuItem(
      id: '9',
      name: 'Pâtes Carbonara',
      description: 'Spaghetti, lardons, crème, parmesan',
      price: 15.90,
      category: 'Plats',
      imageUrl: 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
    ),
    MenuItem(
      id: '10',
      name: 'Mousse au Chocolat',
      description: 'Chocolat noir, crème fraîche',
      price: 8.90,
      category: 'Desserts',
      imageUrl: 'https://images.pexels.com/photos/291528/pexels-photo-291528.jpeg',
    ),
  ];

  List<MenuItem> get items => [..._items];

  List<MenuItem> getItemsByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  List<String> get categories {
    return _items.map((item) => item.category).toSet().toList();
  }

  MenuItem? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortOption _sortOption = SortOption.name;
  bool _sortAscending = true;

  List<MenuItem> get menuItems => _items;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  bool get sortAscending => _sortAscending;

  List<MenuItem> get filteredMenuItems {
    var filtered = _items;

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
    _items.add(item);
    notifyListeners();
  }

  void removeMenuItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateMenuItem(MenuItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index >= 0) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }
} 