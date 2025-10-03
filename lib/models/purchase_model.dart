class Purchase {
  final int? id;
  final String supplierName;
  final double totalPrice;
  final String purchaseDate;
  final String? status;
  final String? notes;
  final String? phone;
  final String? address;
  final String? paymentMethod;
  final String? deliveryDate;
  final double? taxAmount;
  final double? discount;

  Purchase({
    this.id,
    required this.supplierName,
    required this.totalPrice,
    required this.purchaseDate,
    this.status = 'Pending',
    this.notes,
    this.phone,
    this.address,
    this.paymentMethod,
    this.deliveryDate,
    this.taxAmount = 0.0,
    this.discount = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplier_name': supplierName,
      'total_price': totalPrice,
      'purchase_date': purchaseDate,
      'status': status,
      'notes': notes,
      'phone': phone,
      'address': address,
      'payment_method': paymentMethod,
      'delivery_date': deliveryDate,
      'tax_amount': taxAmount,
      'discount': discount,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      supplierName: map['supplier_name'],
      totalPrice: map['total_price']?.toDouble() ?? 0.0,
      purchaseDate: map['purchase_date'],
      status: map['status'],
      notes: map['notes'],
      phone: map['phone'],
      address: map['address'],
      paymentMethod: map['payment_method'],
      deliveryDate: map['delivery_date'],
      taxAmount: map['tax_amount']?.toDouble() ?? 0.0,
      discount: map['discount']?.toDouble() ?? 0.0,
    );
  }

  Purchase copyWith({
    int? id,
    String? supplierName,
    double? totalPrice,
    String? purchaseDate,
    String? status,
    String? notes,
    String? phone,
    String? address,
    String? paymentMethod,
    String? deliveryDate,
    double? taxAmount,
    double? discount,
  }) {
    return Purchase(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      totalPrice: totalPrice ?? this.totalPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      taxAmount: taxAmount ?? this.taxAmount,
      discount: discount ?? this.discount,
    );
  }
}

class PurchaseDetail {
  final int? id;
  final int purchaseId;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double total;
  final String? notes;
  final String? unit;
  final DateTime? expiryDate;

  PurchaseDetail({
    this.id,
    required this.purchaseId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
    this.notes,
    this.unit = 'pcs',
    this.expiryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchase_id': purchaseId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'total': total,
      'notes': notes,
      'unit': unit,
      'expiry_date': expiryDate?.toIso8601String(),
    };
  }

  factory PurchaseDetail.fromMap(Map<String, dynamic> map) {
    return PurchaseDetail(
      id: map['id'],
      purchaseId: map['purchase_id'],
      productId: map['product_id'],
      productName: map['product_name'] ?? 'Unknown Product',
      quantity: map['quantity'],
      price: map['price']?.toDouble() ?? 0.0,
      total: map['total']?.toDouble() ?? 0.0,
      notes: map['notes'],
      unit: map['unit'] ?? 'pcs',
      expiryDate: map['expiry_date'] != null 
          ? DateTime.parse(map['expiry_date']) 
          : null,
    );
  }

  // Helper methods
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  
  PurchaseDetail copyWith({
    int? id,
    int? purchaseId,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
    double? total,
    String? notes,
    String? unit,
    DateTime? expiryDate,
  }) {
    return PurchaseDetail(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}