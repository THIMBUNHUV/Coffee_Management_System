import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/cart_model.dart';
import 'package:coffee_shop_app/services/cart_service.dart';
import 'package:coffee_shop_app/services/product_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  Future<void> fetchCartItems(int customerId) async {
    _setLoading(true);
    try {
      _cartItems = await _cartService.getCartItems(customerId);
      
      // Fetch product prices for each cart item
      for (int i = 0; i < _cartItems.length; i++) {
        if (_cartItems[i].price == null) {
          final product = await _productService.getProductById(_cartItems[i].productId);
          if (product != null) {
            _cartItems[i] = _cartItems[i].copyWith(price: product.price);
          }
        }
      }
      
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> addToCart(CartItem cartItem) async {
    _setLoading(true);
    try {
      // Get product price if not provided
      if (cartItem.price == null) {
        final product = await _productService.getProductById(cartItem.productId);
        cartItem = cartItem.copyWith(price: product?.price ?? 0);
      }
      
      await _cartService.addToCart(cartItem);
      await fetchCartItems(cartItem.customerId);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // OPTIMIZED: Update quantity without full refresh
  Future<void> updateQuantity(int cartItemId, int customerId, int newQuantity) async {
    try {
      // Find the cart item and update locally first
      final cartItemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (cartItemIndex != -1) {
        // Create updated item with new quantity
        final updatedItem = _cartItems[cartItemIndex].copyWith(quantity: newQuantity);
        
        // Update local state immediately
        _cartItems[cartItemIndex] = updatedItem;
        notifyListeners(); // This updates UI instantly without loading
        
        // Then update in database (silently in background)
        await _cartService.updateCartItem(updatedItem);
        
        // Optional: Verify sync without triggering loading
        await _verifyCartSync(customerId);
      }
    } catch (e) {
      // If update fails, refresh from server to restore correct state
      await fetchCartItems(customerId);
      rethrow;
    }
  }

  Future<void> updateCartItem(CartItem cartItem) async {
    _setLoading(true);
    try {
      await _cartService.updateCartItem(cartItem);
      await fetchCartItems(cartItem.customerId);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> removeFromCart(int id, int customerId) async {
    _setLoading(true);
    try {
      await _cartService.removeFromCart(id);
      await fetchCartItems(customerId);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> clearCart(int customerId) async {
    _setLoading(true);
    try {
      await _cartService.clearCart(customerId);
      _cartItems = [];
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  double get totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + (item.price ?? 0) * item.quantity);
  }

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Helper method to verify cart sync without showing loading
  Future<void> _verifyCartSync(int customerId) async {
    try {
      final latestItems = await _cartService.getCartItems(customerId);
      
      // Only update if there's a mismatch (rare case)
      if (latestItems.length != _cartItems.length) {
        _cartItems = latestItems;
        notifyListeners();
      }
    } catch (e) {
      // Silent fail - we don't want to disrupt user experience
      // The local state is already updated
    }
  }
}