import 'package:flutter/material.dart';
import 'package:vee_zee_coffee/models/category_model.dart';
import 'package:vee_zee_coffee/models/product_model.dart';
import 'package:vee_zee_coffee/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _setLoading(true);
    try {
      _products = await _productService.getProducts();
      _filteredProducts = List.from(_products);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> fetchCategories() async {
    _setLoading(true);
    try {
      _categories = await _productService.getCategories();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      return null;
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    if (category == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        return product.category.toLowerCase() == category.toLowerCase();
      }).toList();
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _setLoading(true);
    try {
      await _productService.addProduct(product);
      await fetchProducts();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    _setLoading(true);
    try {
      await _productService.updateProduct(product);
      await fetchProducts();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    _setLoading(true);
    try {
      await _productService.deleteProduct(id);
      await fetchProducts();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}