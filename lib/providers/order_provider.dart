import 'package:flutter/material.dart';
import 'package:vee_zee_coffee/models/order_model.dart';
import 'package:vee_zee_coffee/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  List<OrderDetail> _orderDetails = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  List<OrderDetail> get orderDetails => _orderDetails;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _setLoading(true);
    try {
      _orders = await _orderService.getOrders();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> fetchOrderDetails(int orderId) async {
    _setLoading(true);
    try {
      _orderDetails = await _orderService.getOrderDetails(orderId);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> fetchCustomerOrders(int customerId) async {
    _setLoading(true);
    try {
      _orders = await _orderService.getCustomerOrders(customerId);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> placeOrder(Order order, List<OrderDetail> orderDetails) async {
    _setLoading(true);
    try {
      await _orderService.placeOrder(order, orderDetails);
      await fetchOrders();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    _setLoading(true);
    try {
      await _orderService.updateOrderStatus(orderId, status);
      await fetchOrders();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}