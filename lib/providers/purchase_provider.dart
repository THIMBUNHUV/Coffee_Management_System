
// purchase_provider.dart
import 'package:coffee_shop_app/config/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:coffee_shop_app/models/purchase_model.dart';

// Update your PurchaseProvider with new methods
class PurchaseProvider with ChangeNotifier {
  List<Purchase> _purchases = [];
  bool _isLoading = false;
  Map<String, dynamic> _stats = {};

  List<Purchase> get purchases => _purchases;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get stats => _stats;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> fetchPurchases() async {
    _isLoading = true;
    notifyListeners();

    try {
      _purchases = await _databaseHelper.getPurchases();
      await _fetchStats();
    } catch (e) {
      print('Error fetching purchases: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchStats() async {
    try {
      _stats = await _databaseHelper.getPurchaseStats();
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }


Future<void> addPurchase(Purchase purchase, List<PurchaseDetail> details) async {
  try {
    _isLoading = true;
    notifyListeners();

    final purchaseId = await _databaseHelper.insertPurchase(purchase);
    
    // Insert all purchase details with the correct purchaseId
    for (var detail in details) {
      final newDetail = PurchaseDetail(
        purchaseId: purchaseId,
        productId: detail.productId,
        productName: detail.productName,
        quantity: detail.quantity,
        price: detail.price,
        total: detail.total,
        notes: detail.notes,
        unit: detail.unit,
        expiryDate: detail.expiryDate,
      );
      await _databaseHelper.insertPurchaseDetail(newDetail);
    }
    
    // Add the new purchase to the local list immediately
    final newPurchase = purchase.copyWith(id: purchaseId);
    _purchases.insert(0, newPurchase); // Add to beginning of list
    
    await _fetchStats(); // Update stats
    notifyListeners(); // Notify UI immediately
    
  } catch (e) {
    print('Error adding purchase: $e');
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Future<void> updatePurchase(Purchase purchase) async {
  //   try {
  //     await _databaseHelper.updatePurchase(purchase);
  //     await fetchPurchases();
  //   } catch (e) {
  //     print('Error updating purchase: $e');
  //     rethrow;
  //   }
  // }


  Future<void> updatePurchase(Purchase purchase) async {
  try {
    _isLoading = true;
    notifyListeners();

    await _databaseHelper.updatePurchase(purchase);
    
    // Update the purchase in the local list
    final index = _purchases.indexWhere((p) => p.id == purchase.id);
    if (index != -1) {
      _purchases[index] = purchase;
    }
    
    await _fetchStats(); // Update stats
    notifyListeners(); // Notify UI immediately
    
  } catch (e) {
    print('Error updating purchase: $e');
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> deletePurchase(int id) async {
    try {
      // First delete related details
      await _databaseHelper.deletePurchaseDetails(id);
      // Then delete the purchase
      await _databaseHelper.deletePurchase(id);
      await fetchPurchases();
    } catch (e) {
      print('Error deleting purchase: $e');
      rethrow;
    }
  }

  Future<List<PurchaseDetail>> getPurchaseDetailsById(int purchaseId) async {
    return await _databaseHelper.getPurchaseDetails(purchaseId);
  }

}

