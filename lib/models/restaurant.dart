class Restaurant {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String imageUrl;
  final bool isActive;
  final List<String> categories;
  final Map<String, dynamic>? settings;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.imageUrl,
    this.isActive = true,
    this.categories = const [],
    this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'categories': categories,
      'settings': settings,
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      categories: List<String>.from(json['categories'] ?? []),
      settings: json['settings'],
    );
  }
} 