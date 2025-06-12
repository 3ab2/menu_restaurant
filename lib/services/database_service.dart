import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/restaurant.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'restaurant_menu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        address TEXT,
        phone TEXT,
        imageUrl TEXT,
        isActive INTEGER,
        categories TEXT,
        settings TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE menu_items(
        id TEXT PRIMARY KEY,
        restaurantId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT,
        imageUrl TEXT,
        isAvailable INTEGER,
        FOREIGN KEY (restaurantId) REFERENCES restaurants (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        restaurantId TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        createdAt TEXT NOT NULL,
        status TEXT NOT NULL,
        tableNumber TEXT,
        customerName TEXT,
        notes TEXT,
        FOREIGN KEY (restaurantId) REFERENCES restaurants (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items(
        id TEXT PRIMARY KEY,
        orderId TEXT NOT NULL,
        menuItemId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        notes TEXT,
        FOREIGN KEY (orderId) REFERENCES orders (id),
        FOREIGN KEY (menuItemId) REFERENCES menu_items (id)
      )
    ''');
  }

  // Restaurant operations
  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      'restaurants',
      {
        ...restaurant.toJson(),
        'isActive': restaurant.isActive ? 1 : 0,
        'categories': restaurant.categories.join(','),
        'settings': restaurant.settings?.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('restaurants');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Restaurant(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        address: map['address'],
        phone: map['phone'],
        imageUrl: map['imageUrl'],
        isActive: map['isActive'] == 1,
        categories: map['categories'].toString().split(','),
        settings: map['settings'] != null
            ? Map<String, dynamic>.from(
                Map<String, dynamic>.from(
                  map['settings'].toString() as Map,
                ),
              )
            : null,
      );
    });
  }

  // Menu item operations
  Future<void> insertMenuItem(MenuItem item) async {
    final db = await database;
    await db.insert(
      'menu_items',
      {
        ...item.toJson(),
        'isAvailable': item.isAvailable ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'menu_items',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return MenuItem(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        category: map['category'],
        imageUrl: map['imageUrl'],
        isAvailable: map['isAvailable'] == 1,
      );
    });
  }

  // Order operations
  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'orders',
        {
          ...order.toJson(),
          'status': order.status.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var item in order.items) {
        await txn.insert(
          'order_items',
          {
            'id': const Uuid().v4(),
            'orderId': order.id,
            'menuItemId': item.menuItem.id,
            'quantity': item.quantity,
            'notes': item.notes,
          },
        );
      }
    });
  }

  Future<List<Order>> getOrders(String restaurantId) async {
    final db = await database;
    final List<Map<String, dynamic>> orderMaps = await db.query(
      'orders',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );

    List<Order> orders = [];
    for (var orderMap in orderMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [orderMap['id']],
      );

      List<OrderItem> items = [];
      for (var itemMap in itemMaps) {
        final menuItemMaps = await db.query(
          'menu_items',
          where: 'id = ?',
          whereArgs: [itemMap['menuItemId']],
        );

        if (menuItemMaps.isNotEmpty) {
          final menuItem = MenuItem.fromJson(menuItemMaps.first);
          items.add(OrderItem(
            menuItem: menuItem,
            quantity: itemMap['quantity'],
            notes: itemMap['notes'],
          ));
        }
      }

      orders.add(Order(
        id: orderMap['id'],
        restaurantId: orderMap['restaurantId'],
        items: items,
        totalAmount: orderMap['totalAmount'],
        createdAt: DateTime.parse(orderMap['createdAt']),
        status: OrderStatus.values.firstWhere(
          (e) => e.toString() == orderMap['status'],
        ),
        tableNumber: orderMap['tableNumber'],
        customerName: orderMap['customerName'],
        notes: orderMap['notes'],
      ));
    }

    return orders;
  }
} 