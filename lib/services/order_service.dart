import 'package:vee_zee_coffee/config/database_helper.dart';
import 'package:vee_zee_coffee/models/order_model.dart';

class OrderService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Order>> getOrders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblOrder',
      orderBy: 'order_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<List<Order>> getCustomerOrders(int customerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblOrder',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'order_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblOrderDetail',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    return List.generate(maps.length, (i) {
      return OrderDetail.fromMap(maps[i]);
    });
  }

  Future<void> placeOrder(Order order, List<OrderDetail> orderDetails) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      final orderId = await txn.insert('tblOrder', order.toMap());
      for (var detail in orderDetails) {
        detail.orderId = orderId;
        await txn.insert('tblOrderDetail', detail.toMap());
      }
      
      // Add payment record
      await txn.insert('tblPayment', {
        'order_id': orderId,
        'method': 'cash', // Default, should be passed as parameter
        'status': 'pending',
      });
    });
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblOrder',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}