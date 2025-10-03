class Product {
  final int? id;
  final String name;
  final String? description;
  final String category;
  final double price;
  final String? image; // For network URLs (stored in database)
  final String? imagePath; // For local file paths (stored in database)

  Product({
    this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    this.image,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': image, // Store network URL in 'image' column
      'image_path': imagePath, // Store local path in 'image_path' column
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price']?.toDouble() ?? 0.0,
      image: map['image'], // Load network URL from 'image' column
      imagePath: map['image_path'], // Load local path from 'image_path' column
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    double? price,
    String? image,
    String? imagePath,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      image: image ?? this.image,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}