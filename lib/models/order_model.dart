class Order {
  final int? id;
   int customerId;
  final double totalPrice;
  final String status;
  final String orderDate;
  final String? deliveryAddress;

  Order({
    this.id,
    required this.customerId,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    this.deliveryAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'total_price': totalPrice,
      'status': status,
      'order_date': orderDate,
      'delivery_address': deliveryAddress,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerId: map['customer_id'],
      totalPrice: map['total_price'],
      status: map['status'],
      orderDate: map['order_date'],
      deliveryAddress: map['delivery_address'],
    );
  }

  get items => null;
}

class OrderDetail {
  final int? id;
  int orderId;
  final int productId;
  final int quantity;
  final double price;
  final String? customization;

  OrderDetail({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.customization,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'customization': customization,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      price: map['price'],
      customization: map['customization'],
    );
  }
}