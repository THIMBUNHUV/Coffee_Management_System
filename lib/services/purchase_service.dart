import 'package:vee_zee_coffee/config/database_helper.dart';
import 'package:vee_zee_coffee/models/purchase_model.dart';
import 'package:vee_zee_coffee/models/receive_model.dart';

class PurchaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Purchase CRUD Operations
  Future<List<Purchase>> getPurchases() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchase',
      orderBy: 'purchase_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }

  Future<Purchase?> getPurchaseById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchase',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Purchase.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Purchase>> getPurchasesByStatus(String status) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchase',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'purchase_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }

  Future<List<PurchaseDetail>> getPurchaseDetails(int purchaseId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchaseDetail',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
    );

    return List.generate(maps.length, (i) {
      return PurchaseDetail.fromMap(maps[i]);
    });
  }

  Future<void> addPurchase(Purchase purchase, List<PurchaseDetail> details) async {
    final db = await _dbHelper.database;
    await PurchaseService().addPurchase(purchase, details);

    await db.transaction((txn) async {
      final purchaseId = await txn.insert('tblPurchase', purchase.toMap());
      for (var detail in details) {
        // Create new detail with the correct purchaseId

        final newDetail = PurchaseDetail(
          purchaseId: purchaseId,
          productId: detail.productId,
          quantity: detail.quantity,
          price: detail.price,
          notes: detail.notes,
          productName: '',
          total: detail.quantity * detail.price,
        );
        await txn.insert('tblPurchaseDetail', newDetail.toMap());
      }
    });
  }

  Future<void> updatePurchase(Purchase purchase) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblPurchase',
      purchase.toMap(),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  Future<void> updatePurchaseStatus(int purchaseId, String status) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblPurchase',
      {'status': status},
      where: 'id = ?',
      whereArgs: [purchaseId],
    );
  }

  Future<void> deletePurchase(int id) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // Delete purchase details first
      await txn.delete( 
        'tblPurchaseDetail',
        where: 'purchase_id = ?',
        whereArgs: [id],
      );
      // Then delete purchase
      await txn.delete(
        'tblPurchase',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // Receive Purchase CRUD Operations
  Future<List<ReceivePurchase>> getReceivePurchases() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblReceivePurchase',
      orderBy: 'received_date DESC',
    );

    return List.generate(maps.length, (i) {
      return ReceivePurchase.fromMap(maps[i]);
    });
  }

  Future<ReceivePurchase?> getReceivePurchaseById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblReceivePurchase',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ReceivePurchase.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ReceivePurchase>> getReceivePurchasesByStatus(String status) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblReceivePurchase',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'received_date DESC',
    );

    return List.generate(maps.length, (i) {
      return ReceivePurchase.fromMap(maps[i]);
    });
  }

  Future<List<ReceivePurchaseDetail>> getReceivePurchaseDetails(int receiveId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblReceivePurchaseDetail',
      where: 'receive_id = ?',
      whereArgs: [receiveId],
    );

    return List.generate(maps.length, (i) {
      return ReceivePurchaseDetail.fromMap(maps[i]);
    });
  }

  Future<void> addReceivePurchase(ReceivePurchase receivePurchase, List<ReceivePurchaseDetail> details) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      final receiveId = await txn.insert('tblReceivePurchase', receivePurchase.toMap());
      for (var detail in details) {
        // Create new detail with the correct receiveId
        final newDetail = ReceivePurchaseDetail(
          receiveId: receiveId,
          productId: detail.productId,
          quantity: detail.quantity,
          notes: detail.notes,
        );
        await txn.insert('tblReceivePurchaseDetail', newDetail.toMap());
      }
    });
  }

  Future<void> updateReceivePurchase(ReceivePurchase receivePurchase) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblReceivePurchase',
      receivePurchase.toMap(),
      where: 'id = ?',
      whereArgs: [receivePurchase.id],
    );
  }

  Future<void> updateReceivePurchaseStatus(int receiveId, String status) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblReceivePurchase',
      {'status': status},
      where: 'id = ?',
      whereArgs: [receiveId],
    );
  }

  Future<void> deleteReceivePurchase(int id) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // Delete receive purchase details first
      await txn.delete(
        'tblReceivePurchaseDetail',
        where: 'receive_id = ?',
        whereArgs: [id],
      );
      // Then delete receive purchase
      await txn.delete(
        'tblReceivePurchase',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // Statistics and Analytics
  Future<Map<String, dynamic>> getPurchaseStats() async {
    final db = await _dbHelper.database;
    
    // Total purchases count
    final totalCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM tblPurchase');
    final totalCount = totalCountResult.first['count'] as int? ?? 0;
    
    // Total amount
    final totalAmountResult = await db.rawQuery('SELECT SUM(total_price) as total FROM tblPurchase');
    final totalAmount = (totalAmountResult.first['total'] as num?)?.toDouble() ?? 0.0;
    
    // This month total
    final thisMonth = DateTime.now();
    final firstDayOfMonth = DateTime(thisMonth.year, thisMonth.month, 1).toIso8601String();
    final thisMonthAmountResult = await db.rawQuery('''
      SELECT SUM(total_price) as total FROM tblPurchase 
      WHERE purchase_date >= ?
    ''', [firstDayOfMonth]);
    final thisMonthAmount = (thisMonthAmountResult.first['total'] as num?)?.toDouble() ?? 0.0;
    
    // Pending purchases count
    final pendingCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM tblPurchase WHERE status = ?', ['Pending']);
    final pendingCount = pendingCountResult.first['count'] as int? ?? 0;

    // Completed purchases count
    final completedCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM tblPurchase WHERE status = ?', ['Completed']);
    final completedCount = completedCountResult.first['count'] as int? ?? 0;
    
    return {
      'totalCount': totalCount,
      'totalAmount': totalAmount,
      'thisMonthAmount': thisMonthAmount,
      'pendingCount': pendingCount,
      'completedCount': completedCount,
    };
  }

  Future<Map<String, dynamic>> getReceivePurchaseStats() async {
    final db = await _dbHelper.database;
    
    // Total receive purchases count
    final totalCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM tblReceivePurchase');
    final totalCount = totalCountResult.first['count'] as int? ?? 0;
    
    // Pending receive purchases count
    final pendingCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM tblReceivePurchase WHERE status = ?', ['Pending']);
    final pendingCount = pendingCountResult.first['count'] as int? ?? 0;

    // Completed receive purchases count
    final completedCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM tblReceivePurchase WHERE status = ?', ['Completed']);
    final completedCount = completedCountResult.first['count'] as int? ?? 0;
    
    return {
      'totalCount': totalCount,
      'pendingCount': pendingCount,
      'completedCount': completedCount,
    };
  }

  // Get purchases with details
  Future<Map<String, dynamic>?> getPurchaseWithDetails(int purchaseId) async {
    final purchase = await getPurchaseById(purchaseId);
    if (purchase == null) return null;

    final details = await getPurchaseDetails(purchaseId);
    
    return {
      'purchase': purchase,
      'details': details,
    };
  }

  // Get receive purchase with details
  Future<Map<String, dynamic>?> getReceivePurchaseWithDetails(int receiveId) async {
    final receivePurchase = await getReceivePurchaseById(receiveId);
    if (receivePurchase == null) return null;

    final details = await getReceivePurchaseDetails(receiveId);
    
    return {
      'receivePurchase': receivePurchase,
      'details': details,
    };
  }

  // Search methods
  Future<List<Purchase>> searchPurchases(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchase',
      where: 'supplier_name LIKE ? OR status LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'purchase_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }

  // Get purchases that haven't been received yet
  Future<List<Purchase>> getUnreceivedPurchases() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.* FROM tblPurchase p
      LEFT JOIN tblReceivePurchase rp ON p.id = rp.purchase_id
      WHERE rp.id IS NULL OR rp.status != 'Completed'
      ORDER BY p.purchase_date DESC
    ''');

    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }
}