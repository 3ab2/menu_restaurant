import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/menu_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'models/menu_item.dart';
import 'screens/menu_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (ctx) {
          final provider = MenuProvider();
          // Add some sample menu items
          provider.addMenuItem(
            MenuItem(
              id: '1',
              name: 'Salade César',
              description: 'Laitue romaine, poulet grillé, parmesan, croûtons',
              price: 12.90,
              category: 'Entrées',
              imageUrl: 'https://picsum.photos/200/300?random=1',
            ),
          );
          provider.addMenuItem(
            MenuItem(
              id: '2',
              name: 'Steak Frites',
              description: 'Steak de bœuf, frites maison, sauce au poivre',
              price: 24.90,
              category: 'Plats Principaux',
              imageUrl: 'https://picsum.photos/200/300?random=2',
            ),
          );
          provider.addMenuItem(
            MenuItem(
              id: '3',
              name: 'Crème Brûlée',
              description: 'Crème vanille, caramel croquant',
              price: 8.90,
              category: 'Desserts',
              imageUrl: 'https://picsum.photos/200/300?random=3',
            ),
          );
          return provider;
        }),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Menu du Restaurant',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MenuScreen(),
          );
        },
      ),
    );
  }
}
