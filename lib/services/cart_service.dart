import 'package:coffee_shop_app/config/database_helper.dart';
import 'package:coffee_shop_app/models/cart_model.dart';

class CartService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<CartItem>> getCartItems(int customerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblCart',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'date_added DESC',
    );

    return List.generate(maps.length, (i) {
      return CartItem.fromMap(maps[i]);
    });
  }

  Future<void> addToCart(CartItem cartItem) async {
    final db = await _dbHelper.database;
    await db.insert('tblCart', cartItem.toMap());
  }

  Future<void> updateCartItem(CartItem cartItem) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblCart',
      cartItem.toMap(),
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );
  }

  Future<void> removeFromCart(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'tblCart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearCart(int customerId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'tblCart',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );
  }

  


}