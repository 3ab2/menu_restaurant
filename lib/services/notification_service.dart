import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/order.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initSettings);
  }

  Future<void> showOrderStatusNotification(Order order) async {
    const androidDetails = AndroidNotificationDetails(
      'order_status_channel',
      'Order Status',
      channelDescription: 'Notifications for order status updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String title;
    String body;

    switch (order.status) {
      case OrderStatus.confirmed:
        title = 'Commande confirmée';
        body = 'Votre commande #${order.id.substring(0, 8)} a été confirmée';
        break;
      case OrderStatus.preparing:
        title = 'Commande en préparation';
        body = 'Votre commande #${order.id.substring(0, 8)} est en cours de préparation';
        break;
      case OrderStatus.ready:
        title = 'Commande prête';
        body = 'Votre commande #${order.id.substring(0, 8)} est prête à être servie';
        break;
      case OrderStatus.delivered:
        title = 'Commande livrée';
        body = 'Votre commande #${order.id.substring(0, 8)} a été livrée';
        break;
      case OrderStatus.cancelled:
        title = 'Commande annulée';
        body = 'Votre commande #${order.id.substring(0, 8)} a été annulée';
        break;
      default:
        return;
    }

    await _notifications.show(
      order.id.hashCode,
      title,
      body,
      details,
    );
  }

  Future<void> showNewOrderNotification(Order order) async {
    const androidDetails = AndroidNotificationDetails(
      'new_order_channel',
      'New Orders',
      channelDescription: 'Notifications for new orders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      order.id.hashCode,
      'Nouvelle commande',
      'Commande #${order.id.substring(0, 8)} reçue',
      details,
    );
  }
} 