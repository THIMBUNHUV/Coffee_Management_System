import 'package:coffee_shop_app/config/database_helper.dart';
import 'package:coffee_shop_app/models/customer_model.dart';
import 'package:coffee_shop_app/models/employee_model.dart';
import 'package:coffee_shop_app/models/owner_model.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<Customer> loginCustomer(String email, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblCustomer',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) {
      throw Exception('Customer not found');
    }

    return Customer.fromMap(maps.first);
  }

  Future<Employee> loginEmployee(String email, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblEmployee',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) {
      throw Exception('Employee not found');
    }

    return Employee.fromMap(maps.first);
  }

  Future<Owner> loginOwner(String email, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblOwner',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) {
      throw Exception('Owner not found');
    }

    return Owner.fromMap(maps.first);
  }

  Future<void> registerCustomer(Customer customer) async {
    final db = await _dbHelper.database;
    await db.insert('tblCustomer', customer.toMap());
  }

  Future<void> registerEmployee(Employee employee) async {
    final db = await _dbHelper.database;
    await db.insert('tblEmployee', employee.toMap());
  }

  Future<void> registerOwner(Owner owner) async {
    final db = await _dbHelper.database;
    await db.insert('tblOwner', owner.toMap());
  }
}