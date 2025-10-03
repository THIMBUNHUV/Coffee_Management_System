import 'package:coffee_shop_app/models/customer_model.dart';
import 'package:coffee_shop_app/models/employee_model.dart';
import 'package:coffee_shop_app/models/owner_model.dart';
import 'package:coffee_shop_app/models/purchase_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'coffee_app.db');
    return await openDatabase(
      path,
      version: 21, // Incremented version for dual image support
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> clearDatabase() async {
    String path = join(await getDatabasesPath(), 'coffee_app.db');
    await deleteDatabase(path);
    _database = null;
  }

  Future<void> _createDB(Database db, int version) async {
    // User Tables
    await db.execute('''
      CREATE TABLE tblCustomer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        profile_image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tblEmployee(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        salary REAL,
        profile_image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tblOwner(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        business_name TEXT,
        business_address TEXT,
        profile_image_path TEXT
      )
    ''');

    // ✅ UPDATED: Product table with both image columns
    await db.execute('''
      CREATE TABLE tblProduct(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT,
        image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tblOrder(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        total_price REAL NOT NULL,
        status TEXT NOT NULL,
        order_date TEXT NOT NULL,
        delivery_address TEXT,
        FOREIGN KEY (customer_id) REFERENCES tblCustomer (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tblOrderDetail(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        customization TEXT,
        FOREIGN KEY (order_id) REFERENCES tblOrder (id),
        FOREIGN KEY (product_id) REFERENCES tblProduct (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tblPayment(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        method TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES tblOrder (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tblFavorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES tblCustomer (id),
        FOREIGN KEY (product_id) REFERENCES tblProduct (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tblCart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        customization TEXT,
        date_added TEXT NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES tblCustomer (id),
        FOREIGN KEY (product_id) REFERENCES tblProduct (id)
      )
    ''');

    // Purchase & Inventory Tables
    await db.execute('''
      CREATE TABLE tblPurchase(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        supplier_name TEXT NOT NULL,
        total_price REAL NOT NULL,
        purchase_date TEXT NOT NULL,
        status TEXT DEFAULT 'Pending',
        notes TEXT,
        phone TEXT,
        address TEXT,
        payment_method TEXT,
        delivery_date TEXT,
        tax_amount REAL DEFAULT 0.0,
        discount REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE tblPurchaseDetail(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchase_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        total REAL NOT NULL,
        notes TEXT,
        unit TEXT DEFAULT 'pcs',
        expiry_date TEXT,
        FOREIGN KEY (purchase_id) REFERENCES tblPurchase (id),
        FOREIGN KEY (product_id) REFERENCES tblProduct (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tblReceivePurchase(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchase_id INTEGER NOT NULL,
        received_date TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (purchase_id) REFERENCES tblPurchase (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tblReceivePurchaseDetail(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        receive_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (receive_id) REFERENCES tblReceivePurchase (id),
        FOREIGN KEY (product_id) REFERENCES tblProduct (id)
      )
    ''');

    // Optional / Helper Tables
    await db.execute('''
      CREATE TABLE tblCategory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tblDeliveryAddress(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        address TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (customer_id) REFERENCES tblCustomer (id)
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE tblCart ADD COLUMN price REAL NOT NULL DEFAULT 0.0',
      );
    }

    if (oldVersion < 8) {
      try {
        await db.execute('ALTER TABLE tblEmployee ADD COLUMN phone TEXT');
        await db.execute('ALTER TABLE tblEmployee ADD COLUMN address TEXT');
        await db.execute(
          'ALTER TABLE tblEmployee ADD COLUMN salary REAL DEFAULT 0.0',
        );
      } catch (e) {
        print('Error adding columns: $e');
      }
    }

    if (oldVersion < 10) {
      try {
        await db.execute('''
        CREATE TABLE tblPurchase_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          supplier_name TEXT NOT NULL,
          total_price REAL NOT NULL,
          purchase_date TEXT NOT NULL,
          status TEXT DEFAULT 'Pending',
          notes TEXT,
          phone TEXT,
          address TEXT,
          payment_method TEXT,
          delivery_date TEXT,
          tax_amount REAL DEFAULT 0.0,
          discount REAL DEFAULT 0.0
        )
      ''');

        await db.execute('''
        INSERT INTO tblPurchase_temp 
        (id, supplier_name, total_price, purchase_date, status, notes, phone, address, payment_method, delivery_date, tax_amount, discount)
        SELECT id, supplier_name, total_price, purchase_date, status, notes, phone, address, payment_method, delivery_date, tax_amount, discount
        FROM tblPurchase
      ''');

        await db.execute('DROP TABLE tblPurchase');
        await db.execute('ALTER TABLE tblPurchase_temp RENAME TO tblPurchase');
      } catch (e) {
        print('Error updating purchase table: $e');
      }
    }

    if (oldVersion < 13) {
      try {
        // Add new columns to tblOwner
        await db.execute('ALTER TABLE tblOwner ADD COLUMN phone TEXT');
        await db.execute('ALTER TABLE tblOwner ADD COLUMN business_name TEXT');
        await db.execute(
          'ALTER TABLE tblOwner ADD COLUMN business_address TEXT',
        );
        await db.execute(
          'ALTER TABLE tblOwner ADD COLUMN profile_image_path TEXT',
        );
      } catch (e) {
        print('Error adding owner columns: $e');
        // If ALTER TABLE fails, recreate the table
        await _recreateOwnerTable(db);
      }
    }

    // ✅ NEW: Add image_path column for version 20
    if (oldVersion < 20) {
      try {
        await db.execute('ALTER TABLE tblProduct ADD COLUMN image_path TEXT');
        print('Added image_path column to tblProduct');
      } catch (e) {
        print('Error adding image_path column: $e');
        // If ALTER TABLE fails, recreate the product table
        await _recreateProductTable(db);
      }
    }
  }

  // Method to recreate product table with new schema
  Future<void> _recreateProductTable(Database db) async {
    // Backup old data
    final oldProducts = await db.query('tblProduct');

    // Drop old table
    await db.execute('DROP TABLE IF EXISTS tblProduct');

    // Recreate table with new schema including image_path
    await db.execute('''
      CREATE TABLE tblProduct(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT,
        image_path TEXT
      )
    ''');

    // Restore data
    for (final product in oldProducts) {
      await db.insert('tblProduct', {
        'id': product['id'],
        'name': product['name'],
        'description': product['description'],
        'category': product['category'],
        'price': product['price'],
        'image': product['image'], // Keep existing image URLs
        'image_path': null, // Initialize image_path as null
      });
    }
    print('Recreated tblProduct with image_path column');
  }

  Future<void> _recreateOwnerTable(Database db) async {
    // Backup old data
    final oldOwners = await db.query('tblOwner');

    // Drop old table
    await db.execute('DROP TABLE IF EXISTS tblOwner');

    // Recreate table with new schema
    await db.execute('''
      CREATE TABLE tblOwner(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        business_name TEXT,
        business_address TEXT,
        profile_image_path TEXT
      )
    ''');

    // Restore data
    for (final owner in oldOwners) {
      await db.insert('tblOwner', owner);
    }
  }

  Future<void> _insertSampleData(Database db) async {
    // Insert sample customers
    final List<Map<String, dynamic>> existingCustomers = await db.query(
      'tblCustomer',
    );
    if (existingCustomers.isEmpty) {
      await db.insert('tblCustomer', {
        'name': 'Thim Bunhuv',
        'email': 'bunhov1232@gmail.com',
        'password': '12345678',
        'phone': '0888 928 826',
        'address': 'Sihanouk',
      });
    }

    // Insert sample employees
    final List<Map<String, dynamic>> existingEmployees = await db.query(
      'tblEmployee',
    );
    if (existingEmployees.isEmpty) {
      await db.insert('tblEmployee', {
        'name': 'Seng Ratana',
        'email': 'ratana@gmail.com',
        'password': '12345678',
        'role': 'Barista',
        'phone': '0888 928 826',
        'address': 'Kompot',
        'salary': 2500.00,
      });
    }

    // Insert sample owner
    final List<Map<String, dynamic>> existingOwners = await db.query(
      'tblOwner',
    );
    if (existingOwners.isEmpty) {
      await db.insert('tblOwner', {
        'name': 'Sok Dara',
        'email': 'dara@gmail.com',
        'password': '12345678',
        'phone': '092 747 747',
        'business_name': 'Coffee Shop Deluxe',
        'business_address': 'Phnom Penh',
      });
    }

    // Insert sample products
    final List<Map<String, dynamic>> existingProducts = await db.query(
      'tblProduct',
    );
    if (existingProducts.isNotEmpty) {
      return;
    }

    List<Map<String, dynamic>> sampleProducts = [
      {
        'name': 'Espresso',
        'description': 'Strong and bold coffee shot',
        'category': 'Espresso',
        'price': 2.50,
        'image':
            'https://media.istockphoto.com/id/136625069/photo/coffee-espresso.jpg?s=612x612&w=0&k=20&c=qsAwchQa1ExewNpHaaxUAElBSXs6f9u81QyMSjjW7Xc=',
        'image_path': null,
      },
      {
        'name': 'Americano',
        'description': 'Espresso with hot water',
        'category': 'Americano',
        'price': 3.00,
        'image': 'https://www.bakenroll.az/en/image/americano.jpg',
        'image_path': null,
      },
      {
        'name': 'Macchiato',
        'description': 'Espresso with a dollop of foamed milk',
        'category': 'Macchiato',
        'price': 3.75,
        'image':
            'https://img.freepik.com/free-photo/delicious-quality-coffee-cup_23-2150691325.jpg?semt=ais_hybrid&w=740',
        'image_path': null,
      },
      {
        'name': 'Flat White',
        'description': 'Similar to latte but with less foam',
        'category': 'Flat White',
        'price': 4.25,
        'image':
            'https://img.freepik.com/premium-photo/flat-white-coffee_488220-3363.jpg',
        'image_path': null,
      },
      {
        'name': 'Irish Coffee',
        'description': 'Coffee with Irish whiskey and cream',
        'category': 'Specialty',
        'price': 6.00,
        'image':
            'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
        'image_path': null,
      },
      {
        'name': 'Cappuccino',
        'description': 'Espresso with steamed milk foam',
        'category': 'Cappuccino',
        'price': 3.50,
        'image':
            'https://houseofcocoa.net/cdn/shop/products/Cappuccino.jpg?v=1655998082',
        'image_path': null,
      },
      {
        'name': 'Latte',
        'description': 'Espresso with steamed milk',
        'category': 'Latte',
        'price': 4.00,
        'image':
            'https://originalsin.com.sg/wp-content/uploads/2025/05/cafe-latte-recipe-1746593903.jpg',
        'image_path': null,
      },
      {
        'name': 'Mocha',
        'description': 'Espresso with chocolate and steamed milk',
        'category': 'Mocha',
        'price': 4.50,
        'image':
            'https://www.canterburycoffee.com/wp-content/uploads/2023/07/Hazy-Mocha-AdobeStock_466356719-scaled.jpeg',
        'image_path': null,
      },
      {
        'name': 'Cold Brew',
        'description': 'Smooth coffee brewed with cold water',
        'category': 'Cold Coffee',
        'price': 3.25,
        'image':
            'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500&h=500&fit=crop&bg=white',
        'image_path': null,
      },

      {
        'name': 'Caramel Macchiato',
        'description': 'Espresso with caramel and steamed milk',
        'category': 'Macchiato',
        'price': 4.75,
        'image':
            'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=500&h=500&fit=crop&bg=white',
        'image_path': null,
      },
    ];

    for (var product in sampleProducts) {
      await db.insert('tblProduct', product);
    }
  }

  // ========== EMPLOYEE CRUD OPERATIONS ==========
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert('tblEmployee', employee.toMap());
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tblEmployee');
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      'tblEmployee',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('tblEmployee', where: 'id = ?', whereArgs: [id]);
  }

  Future<Employee?> getEmployeeById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblEmployee',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Employee.fromMap(maps.first);
    }
    return null;
  }

  // ========== OWNER CRUD OPERATIONS ==========
  Future<int> updateOwner(Owner owner) async {
    final db = await database;
    return await db.update(
      'tblOwner',
      owner.toMap(),
      where: 'id = ?',
      whereArgs: [owner.id],
    );
  }

  Future<Owner?> getOwnerById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblOwner',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Owner.fromMap(maps.first);
    }
    return null;
  }

  Future<Owner?> getOwnerByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblOwner',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Owner.fromMap(maps.first);
    }
    return null;
  }

  // ========== PURCHASE CRUD OPERATIONS ==========
  Future<int> insertPurchase(Purchase purchase) async {
    final db = await database;
    return await db.insert('tblPurchase', purchase.toMap());
  }

  Future<List<Purchase>> getPurchases() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchase',
      orderBy: 'purchase_date DESC',
    );
    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }

  Future<int> updatePurchase(Purchase purchase) async {
    final db = await database;
    return await db.update(
      'tblPurchase',
      purchase.toMap(),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  Future<int> deletePurchase(int id) async {
    final db = await database;
    return await db.delete('tblPurchase', where: 'id = ?', whereArgs: [id]);
  }

  Future<Purchase?> getPurchaseById(int id) async {
    final db = await database;
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

  // ========== PURCHASE DETAIL CRUD OPERATIONS ==========
  Future<int> insertPurchaseDetail(PurchaseDetail detail) async {
    final db = await database;
    return await db.insert('tblPurchaseDetail', detail.toMap());
  }

  Future<List<PurchaseDetail>> getPurchaseDetails(int purchaseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPurchaseDetail',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
    );
    return List.generate(maps.length, (i) {
      return PurchaseDetail.fromMap(maps[i]);
    });
  }

  Future<int> updatePurchaseDetail(PurchaseDetail detail) async {
    final db = await database;
    return await db.update(
      'tblPurchaseDetail',
      detail.toMap(),
      where: 'id = ?',
      whereArgs: [detail.id],
    );
  }

  Future<int> deletePurchaseDetails(int purchaseId) async {
    final db = await database;
    return await db.delete(
      'tblPurchaseDetail',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
    );
  }

  // ========== CUSTOMER CRUD OPERATIONS ==========
  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update(
      'tblCustomer',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<Customer?> getCustomerById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblCustomer',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  Future<Customer?> getCustomerByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblCustomer',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  // ========== IMAGE MANAGEMENT ==========
  // Customer image methods
  Future<void> updateCustomerProfileImage(
    int customerId,
    String imagePath,
  ) async {
    final db = await database;
    await db.update(
      'tblCustomer',
      {'profile_image_path': imagePath},
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }

  Future<String?> getCustomerProfileImage(int customerId) async {
    final db = await database;
    final result = await db.query(
      'tblCustomer',
      columns: ['profile_image_path'],
      where: 'id = ?',
      whereArgs: [customerId],
    );
    if (result.isNotEmpty) {
      return result.first['profile_image_path'] as String?;
    }
    return null;
  }

  // Employee image methods
  Future<void> updateEmployeeProfileImage(
    int employeeId,
    String imagePath,
  ) async {
    final db = await database;
    await db.update(
      'tblEmployee',
      {'profile_image_path': imagePath},
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }

  Future<String?> getEmployeeProfileImage(int employeeId) async {
    final db = await database;
    final result = await db.query(
      'tblEmployee',
      columns: ['profile_image_path'],
      where: 'id = ?',
      whereArgs: [employeeId],
    );
    if (result.isNotEmpty) {
      return result.first['profile_image_path'] as String?;
    }
    return null;
  }

  // Owner image methods
  Future<void> updateOwnerProfileImage(int ownerId, String imagePath) async {
    final db = await database;
    await db.update(
      'tblOwner',
      {'profile_image_path': imagePath},
      where: 'id = ?',
      whereArgs: [ownerId],
    );
  }

  Future<String?> getOwnerProfileImage(int ownerId) async {
    final db = await database;
    final result = await db.query(
      'tblOwner',
      columns: ['profile_image_path'],
      where: 'id = ?',
      whereArgs: [ownerId],
    );
    if (result.isNotEmpty) {
      return result.first['profile_image_path'] as String?;
    }
    return null;
  }

  // ========== STATISTICS & UTILITY METHODS ==========
  Future<Map<String, dynamic>> getPurchaseStats() async {
    final db = await database;

    // Total purchases count
    final totalCountResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tblPurchase',
    );
    final totalCount = totalCountResult.first['count'] as int? ?? 0;

    // Total amount
    final totalAmountResult = await db.rawQuery(
      'SELECT SUM(total_price) as total FROM tblPurchase',
    );
    final totalAmount =
        (totalAmountResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // This month total
    final thisMonth = DateTime.now();
    final firstDayOfMonth = DateTime(
      thisMonth.year,
      thisMonth.month,
      1,
    ).toIso8601String();
    final thisMonthAmountResult = await db.rawQuery(
      'SELECT SUM(total_price) as total FROM tblPurchase WHERE purchase_date >= ?',
      [firstDayOfMonth],
    );
    final thisMonthAmount =
        (thisMonthAmountResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Pending purchases count
    final pendingCountResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tblPurchase WHERE status = ?',
      ['Pending'],
    );
    final pendingCount = pendingCountResult.first['count'] as int? ?? 0;

    // Completed purchases count
    final completedCountResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tblPurchase WHERE status = ?',
      ['Completed'],
    );
    final completedCount = completedCountResult.first['count'] as int? ?? 0;

    return {
      'totalCount': totalCount,
      'totalAmount': totalAmount,
      'thisMonthAmount': thisMonthAmount,
      'pendingCount': pendingCount,
      'completedCount': completedCount,
    };
  }

  // Get products for dropdown
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('tblProduct');
  }

  // Get purchase with details
  Future<Map<String, dynamic>?> getPurchaseWithDetails(int purchaseId) async {
    final purchase = await getPurchaseById(purchaseId);
    if (purchase == null) return null;
    final details = await getPurchaseDetails(purchaseId);
    return {'purchase': purchase, 'details': details};
  }

  // Get purchases by status
  Future<List<Purchase>> getPurchasesByStatus(String status) async {
    final db = await database;
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

  // Get monthly purchase summary
  Future<List<Map<String, dynamic>>> getMonthlyPurchaseSummary() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', purchase_date) as month,
        COUNT(*) as purchase_count,
        SUM(total_price) as total_amount
      FROM tblPurchase 
      GROUP BY strftime('%Y-%m', purchase_date)
      ORDER BY month DESC
      LIMIT 6
    ''');
    return result;
  }
}
