class Favorite {
  final int? id;
  final int customerId;
  final int productId;
  final DateTime? dateAdded;

  Favorite({
    this.id,
    required this.customerId,
    required this.productId,
    this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'date_added': dateAdded?.toIso8601String(),
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      customerId: map['customer_id'],
      productId: map['product_id'],
      dateAdded: map['date_added'] != null ? DateTime.parse(map['date_added']) : null,
    );
  }
}