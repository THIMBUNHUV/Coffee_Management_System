class Category {
  final int? id;
  final String name;
  final String? description;
  final String? image;

  Category({
    this.id,
    required this.name,
    this.description,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
    );
  }
}