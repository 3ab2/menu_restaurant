import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../models/menu_item.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, child) {
          return ListView.builder(
            itemCount: menuProvider.menuItems.length,
            itemBuilder: (context, index) {
              final item = menuProvider.menuItems[index];
              return ListTile(
                leading: Image.network(
                  item.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.restaurant);
                  },
                ),
                title: Text(item.name),
                subtitle: Text('${item.price.toStringAsFixed(2)} € - ${item.category}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditDialog(context, item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteDialog(context, item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    double price = 0.0;
    String category = '';
    String imageUrl = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un plat'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => name = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => description = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Champ requis';
                    final price = double.tryParse(value!);
                    if (price == null || price <= 0) {
                      return 'Prix invalide';
                    }
                    return null;
                  },
                  onSaved: (value) => price = double.parse(value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => category = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'URL de l\'image'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => imageUrl = value ?? '',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                final newItem = MenuItem(
                  id: DateTime.now().toString(),
                  name: name,
                  description: description,
                  price: price,
                  category: category,
                  imageUrl: imageUrl,
                );
                context.read<MenuProvider>().addMenuItem(newItem);
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, MenuItem item) async {
    final formKey = GlobalKey<FormState>();
    String name = item.name;
    String description = item.description;
    double price = item.price;
    String category = item.category;
    String imageUrl = item.imageUrl;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le plat'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => name = value ?? '',
                ),
                TextFormField(
                  initialValue: description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => description = value ?? '',
                ),
                TextFormField(
                  initialValue: price.toString(),
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Champ requis';
                    final price = double.tryParse(value!);
                    if (price == null || price <= 0) {
                      return 'Prix invalide';
                    }
                    return null;
                  },
                  onSaved: (value) => price = double.parse(value!),
                ),
                TextFormField(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => category = value ?? '',
                ),
                TextFormField(
                  initialValue: imageUrl,
                  decoration: const InputDecoration(labelText: 'URL de l\'image'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                  onSaved: (value) => imageUrl = value ?? '',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                final updatedItem = MenuItem(
                  id: item.id,
                  name: name,
                  description: description,
                  price: price,
                  category: category,
                  imageUrl: imageUrl,
                );
                context.read<MenuProvider>().updateMenuItem(updatedItem);
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, MenuItem item) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le plat'),
        content: Text('Voulez-vous vraiment supprimer ${item.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<MenuProvider>().removeMenuItem(item.id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
} 