import 'package:coffee_shop_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/cart_model.dart';
import 'package:coffee_shop_app/services/cart_service.dart';
import 'package:coffee_shop_app/services/product_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  bool _isInitialLoad = true;
  final Map<int, bool> _itemLoadingStates = {};
  final Map<int, Product> _productsCache = {};

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  bool get isInitialLoad => _isInitialLoad;
  
  bool isItemLoading(int itemId) => _itemLoadingStates[itemId] ?? false;

  Future<void> fetchCartItems(int customerId) async {
    _setLoading(true);
    try {
      _cartItems = await _cartService.getCartItems(customerId);
      _setLoading(false); // Set loading false immediately after cart items
      
      // Fetch products in background without blocking UI
      _fetchProductsInBackground();
      
    } catch (e) {
      _setLoading(false);
      _isInitialLoad = false;
      rethrow;
    }
  }

  Future<void> _fetchProductsInBackground() async {
    try {
      final productIdsToFetch = _cartItems
          .where((item) => !_productsCache.containsKey(item.productId))
          .map((item) => item.productId)
          .toSet()
          .toList();
      
      if (productIdsToFetch.isNotEmpty) {
        await _fetchProductsByIds(productIdsToFetch);
        
        // Update UI with product data when ready
        for (int i = 0; i < _cartItems.length; i++) {
          final product = _productsCache[_cartItems[i].productId];
          if (product != null && _cartItems[i].price == null) {
            _cartItems[i] = _cartItems[i].copyWith(price: product.price);
          }
        }
        notifyListeners();
      }
      
      _isInitialLoad = false;
      notifyListeners();
    } catch (e) {
      print('Background product fetch failed: $e');
      _isInitialLoad = false;
      notifyListeners();
    }
  }

  Future<void> _fetchProductsByIds(List<int> productIds) async {
    try {
      for (int id in productIds) {
        if (!_productsCache.containsKey(id)) {
          final product = await _productService.getProductById(id);
          if (product != null) {
            _productsCache[id] = product;
          }
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Product? getCachedProduct(int productId) {
    return _productsCache[productId];
  }

  Future<void> addToCart(CartItem cartItem) async {
    _setLoading(true);
    try {
      // Get product price if not provided
      if (cartItem.price == null) {
        final product = await _productService.getProductById(cartItem.productId);
        cartItem = cartItem.copyWith(price: product?.price ?? 0);
        
        // Add to cache
        if (product != null) {
          _productsCache[cartItem.productId] = product;
        }
      }
      
      await _cartService.addToCart(cartItem);
      await fetchCartItems(cartItem.customerId);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> updateQuantity(int cartItemId, int customerId, int newQuantity) async {
    _setItemLoading(cartItemId, true);
    
    try {
      // Find the cart item and update locally first
      final cartItemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (cartItemIndex != -1) {
        // Create updated item with new quantity
        final updatedItem = _cartItems[cartItemIndex].copyWith(quantity: newQuantity);
        
        // Update local state immediately
        _cartItems[cartItemIndex] = updatedItem;
        notifyListeners(); // This updates UI instantly without global loading
        
        // Then update in database (silently in background)
        await _cartService.updateCartItem(updatedItem);
        
        // Verify sync without triggering loading
        await _verifyCartSync(customerId);
      }
    } catch (e) {
      // If update fails, refresh from server to restore correct state
      await fetchCartItems(customerId);
      rethrow;
    } finally {
      _setItemLoading(cartItemId, false);
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
      _productsCache.clear();
      _setLoading(false);
      _isInitialLoad = true;
      notifyListeners();
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

  void _setItemLoading(int itemId, bool value) {
    _itemLoadingStates[itemId] = value;
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

  // Clear cache when user logs out
  void clearCache() {
    _productsCache.clear();
    _cartItems = [];
    _isInitialLoad = true;
    notifyListeners();
  }
}