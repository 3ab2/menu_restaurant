import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/menu_item.dart';
import '../services/database_service.dart';

class OrderService {
  final DatabaseService _databaseService = DatabaseService();

  Future<Order> createOrder({
    required String tableNumber,
    required String customerName,
    required MenuItem menuItem,
    String? notes,
  }) async {
    try {
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tableNumber: tableNumber,
        customerName: customerName,
        items: [
          OrderItem(
            menuItem: menuItem,
            quantity: 1,
            notes: notes,
          ),
        ],
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      await _databaseService.saveOrder(order);
      return order;
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow;
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      return await _databaseService.getOrders();
    } catch (e) {
      debugPrint('Error getting orders: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _databaseService.updateOrderStatus(orderId, newStatus);
    } catch (e) {
      debugPrint('Error updating order status: $e');
      rethrow;
    }
  }
} 