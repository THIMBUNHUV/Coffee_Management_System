import 'package:vee_zee_coffee/models/product_model.dart';

class CartItem {
  final int? id;
  final int customerId;
  final int productId;
  final int quantity;
  final String? customization;
  final String dateAdded;
  final double? price;
  final Product? product;

  CartItem({
    this.id,
    required this.customerId,
    required this.productId,
    required this.quantity,
    this.customization,
    required this.dateAdded,
    this.price, this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'quantity': quantity,
      'customization': customization,
      'date_added': dateAdded,
      'price': price ?? 0.0,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      customerId: map['customer_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      customization: map['customization'],
      dateAdded: map['date_added'],
      price: map['price']?.toDouble(),
    );
  }

  double get totalPrice => (price ?? 0) * quantity;

  CartItem copyWith({
    int? id,
    int? customerId,
    int? productId,
    int? quantity,
    String? customization,
    String? dateAdded,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      customization: customization ?? this.customization,
      dateAdded: dateAdded ?? this.dateAdded,
      price: price ?? this.price,
    );
  }
}