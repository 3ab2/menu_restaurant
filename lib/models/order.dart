import 'package:uuid/uuid.dart';
import 'menu_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled
}

class Order {
  final String id;
  final String restaurantId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final OrderStatus status;
  final String? tableNumber;
  final String? customerName;
  final String? notes;

  Order({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.status,
    this.tableNumber,
    this.customerName,
    this.notes,
  });

  double get subtotal => items.fold(
        0,
        (sum, item) => sum + (item.menuItem.price * item.quantity),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
      'tableNumber': tableNumber,
      'customerName': customerName,
      'notes': notes,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restaurantId: json['restaurantId'],
      items: [], // Items will be loaded separately
      totalAmount: json['totalAmount'],
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      tableNumber: json['tableNumber'],
      customerName: json['customerName'],
      notes: json['notes'],
    );
  }
}

class OrderItem {
  final MenuItem menuItem;
  int quantity;
  String? notes;

  OrderItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  double get totalPrice => menuItem.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItem.id,
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      notes: json['notes'],
    );
  }
} 