class ReceivePurchase {
  final int? id;
  final int purchaseId;
  final String receivedDate;
  final String status;
  final int? receivedBy; // Employee ID who received the purchase
  final String? notes;

  ReceivePurchase({
    this.id,
    required this.purchaseId,
    required this.receivedDate,
    required this.status,
    this.receivedBy,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchase_id': purchaseId,
      'received_date': receivedDate,
      'status': status,
      'received_by': receivedBy,
      'notes': notes,
    };
  }

  factory ReceivePurchase.fromMap(Map<String, dynamic> map) {
    return ReceivePurchase(
      id: map['id'],
      purchaseId: map['purchase_id'],
      receivedDate: map['received_date'],
      status: map['status'],
      receivedBy: map['received_by'],
      notes: map['notes'],
    );
  }
}

class ReceivePurchaseDetail {
  final int? id;
  int receiveId;
  final int productId;
  final int quantity;
  final int? receivedQuantity; // In case partial receipt
  final String? notes;

  ReceivePurchaseDetail({
    this.id,
    required this.receiveId,
    required this.productId,
    required this.quantity,
    this.receivedQuantity,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receive_id': receiveId,
      'product_id': productId,
      'quantity': quantity,
      'received_quantity': receivedQuantity,
      'notes': notes,
    };
  }

  factory ReceivePurchaseDetail.fromMap(Map<String, dynamic> map) {
    return ReceivePurchaseDetail(
      id: map['id'],
      receiveId: map['receive_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      receivedQuantity: map['received_quantity'],
      notes: map['notes'],
    );
  }
}