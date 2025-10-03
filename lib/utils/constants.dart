class AppConstants {
  static const String appName = 'Coffee App';
  static const String defaultImage = 'assets/images/coffee_default.png';
  static const String currencySymbol = '\$';
  
  // Order statuses
  static const String orderPending = 'Pending';
  static const String orderPreparing = 'Preparing';
  static const String orderReady = 'Ready';
  static const String orderDelivered = 'Delivered';
  static const String orderCancelled = 'Cancelled';
  
  // Payment methods
  static const String paymentCash = 'Cash';
  static const String paymentCard = 'Card';
  static const String paymentMobile = 'Mobile';
  
  // User roles
  static const String roleCustomer = 'customer';
  static const String roleEmployee = 'employee';
  static const String roleOwner = 'owner';
  
  // Employee roles
  static const String roleBarista = 'Barista';
  static const String roleManager = 'Manager';
  
  // Purchase statuses
  static const String purchasePending = 'Pending';
  static const String purchaseReceived = 'Received';
  static const String purchaseCancelled = 'Cancelled';
  
  // Default values
  static const int defaultQuantity = 1;
  static const String defaultSize = 'Medium';
  static const String defaultMilk = 'Whole';
  static const int defaultSugar = 1;
}