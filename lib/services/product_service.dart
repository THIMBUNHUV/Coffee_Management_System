
import 'dart:io';

import 'package:vee_zee_coffee/config/database_helper.dart';
import 'package:vee_zee_coffee/models/category_model.dart';
import 'package:vee_zee_coffee/models/product_model.dart';
import 'package:vee_zee_coffee/services/image_service.dart';

class ProductService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Product>> getProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tblProduct');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<void> addProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.insert('tblProduct', product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.update(
      'tblProduct',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> updateProductWithImage({
    required Product product,
    required File? newImageFile,
    required bool removeCurrentImage,
  }) async {
    String? finalImagePath = product.imagePath;
    String? finalImageUrl = product.image;

    // Handle image removal
    if (removeCurrentImage) {
      if (product.imagePath != null) {
        await ImageService.deleteImageFile(product.imagePath);
        finalImagePath = null;
      }
      // Also clear network image if removing
      finalImageUrl = null;
    }

    // Handle new image
    if (newImageFile != null) {
      // Delete old local image if exists
      if (product.imagePath != null) {
        await ImageService.deleteImageFile(product.imagePath);
      }
      // Save new image to local storage
      finalImagePath = await ImageService.saveImageToAppDirectory(newImageFile);
      // Clear network image when using local image
      finalImageUrl = null;
    }

    // Update product with new image info
    final updatedProduct = product.copyWith(
      imagePath: finalImagePath,
      image: finalImageUrl,
    );
    await updateProduct(updatedProduct);
  }

  Future<void> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    
    // First get the product to delete its image file
    final product = await getProductById(id);
    if (product != null && product.imagePath != null) {
      await ImageService.deleteImageFile(product.imagePath);
    }
    
    // Then delete from database
    await db.delete(
      'tblProduct',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Product?> getProductById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblProduct',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }
   Future<List<Category>> getCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tblCategory');

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
   
}