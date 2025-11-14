import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/database_service.dart';
import '../../../config/constants.dart';
import '../../models/user_product.dart';
import '../../models/product_template.dart';
import '../../models/category.dart' as models;

/// Product Local Data Source
/// Handles all database operations for products
class ProductLocalDataSource {
  final DatabaseService _databaseService;

  ProductLocalDataSource(this._databaseService);

  /// Factory method to create instance
  static Future<ProductLocalDataSource> create() async {
    final databaseService = DatabaseService();
    return ProductLocalDataSource(databaseService);
  }

  // ==================== USER PRODUCTS ====================

  /// Insert a user product
  Future<int> insertProduct(UserProduct product) async {
    try {
      final db = await _databaseService.database;
      final result = await db.insert(
        AppConstants.tableUserProducts,
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('✅ Inserted product: ${product.name}');
      return result;
    } catch (e) {
      debugPrint('❌ Error inserting product: $e');
      rethrow;
    }
  }

  /// Get product by ID
  Future<UserProduct?> getProductById(String id) async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableUserProducts,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return UserProduct.fromJson(results.first);
    } catch (e) {
      debugPrint('❌ Error getting product by ID: $e');
      rethrow;
    }
  }

  /// Get all products
  Future<List<UserProduct>> getAllProducts() async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableUserProducts,
        where: 'status = ?',
        whereArgs: ['active'],
        orderBy: 'expiry_date ASC',
      );

      return results.map((json) => UserProduct.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting all products: $e');
      rethrow;
    }
  }

  /// Get products by category
  Future<List<UserProduct>> getProductsByCategory(String category) async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableUserProducts,
        where: 'category = ? AND status = ?',
        whereArgs: [category, 'active'],
        orderBy: 'expiry_date ASC',
      );

      return results.map((json) => UserProduct.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting products by category: $e');
      rethrow;
    }
  }

  /// Get products by status
  Future<List<UserProduct>> getProductsByStatus(ProductStatus status) async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableUserProducts,
        where: 'status = ?',
        whereArgs: [status.name],
        orderBy: 'expiry_date ASC',
      );

      return results.map((json) => UserProduct.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting products by status: $e');
      rethrow;
    }
  }

  /// Get expiring soon products (within specified days)
  Future<List<UserProduct>> getExpiringSoon(int days) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now();
      final futureDate = now.add(Duration(days: days));

      final results = await db.query(
        AppConstants.tableUserProducts,
        where: 'expiry_date <= ? AND expiry_date >= ? AND status = ?',
        whereArgs: [
          futureDate.toIso8601String(),
          now.toIso8601String(),
          'active',
        ],
        orderBy: 'expiry_date ASC',
      );

      return results.map((json) => UserProduct.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting expiring soon products: $e');
      rethrow;
    }
  }

  /// Get recently added products
  Future<List<UserProduct>> getRecentProducts(int days) async {
    try {
      final db = await _databaseService.database;
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final results = await db.query(
        AppConstants.tableUserProducts,
        where: 'created_at >= ? AND status = ?',
        whereArgs: [cutoffDate.toIso8601String(), 'active'],
        orderBy: 'created_at DESC',
        limit: AppConstants.recentProductsLimit,
      );

      return results.map((json) => UserProduct.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting recent products: $e');
      rethrow;
    }
  }

  /// Search products by name
  Future<List<UserProduct>> searchProducts(String query) async {
    try {
      final db = await _databaseService.database;
      final searchPattern = '%$query%';

      final results = await db.query(
        AppConstants.tableUserProducts,
        where: '(name LIKE ? OR name_en LIKE ?) AND status = ?',
        whereArgs: [searchPattern, searchPattern, 'active'],
        orderBy: 'expiry_date ASC',
      );

      return results.map((json) => UserProduct.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error searching products: $e');
      rethrow;
    }
  }

  /// Update product
  Future<int> updateProduct(UserProduct product) async {
    try {
      final db = await _databaseService.database;
      final result = await db.update(
        AppConstants.tableUserProducts,
        product.toJson(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      debugPrint('✅ Updated product: ${product.name}');
      return result;
    } catch (e) {
      debugPrint('❌ Error updating product: $e');
      rethrow;
    }
  }

  /// Delete product
  Future<int> deleteProduct(String id) async {
    try {
      final db = await _databaseService.database;
      final result = await db.delete(
        AppConstants.tableUserProducts,
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('✅ Deleted product: $id');
      return result;
    } catch (e) {
      debugPrint('❌ Error deleting product: $e');
      rethrow;
    }
  }

  // ==================== STATISTICS ====================

  /// Get total count of active products
  Future<int> getTotalCount() async {
    try {
      final db = await _databaseService.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.tableUserProducts} WHERE status = ?',
        ['active'],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting total count: $e');
      rethrow;
    }
  }

  /// Get count of expiring soon products
  Future<int> getExpiringSoonCount(int days) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now();
      final futureDate = now.add(Duration(days: days));

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.tableUserProducts} '
        'WHERE expiry_date <= ? AND expiry_date >= ? AND status = ?',
        [futureDate.toIso8601String(), now.toIso8601String(), 'active'],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting expiring soon count: $e');
      rethrow;
    }
  }

  /// Get count by category
  Future<Map<String, int>> getCountByCategory() async {
    try {
      final db = await _databaseService.database;
      final results = await db.rawQuery(
        'SELECT category, COUNT(*) as count FROM ${AppConstants.tableUserProducts} '
        'WHERE status = ? GROUP BY category',
        ['active'],
      );

      final Map<String, int> counts = {};
      for (final row in results) {
        counts[row['category'] as String] = row['count'] as int;
      }
      return counts;
    } catch (e) {
      debugPrint('❌ Error getting count by category: $e');
      rethrow;
    }
  }

  // ==================== PRODUCT TEMPLATES ====================

  /// Insert a product template
  Future<int> insertTemplate(ProductTemplate template) async {
    try {
      final db = await _databaseService.database;
      final result = await db.insert(
        AppConstants.tableProductTemplates,
        template.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('✅ Inserted template: ${template.nameVi}');
      return result;
    } catch (e) {
      debugPrint('❌ Error inserting template: $e');
      rethrow;
    }
  }

  /// Search product templates using LIKE search
  Future<List<ProductTemplate>> searchTemplates(String query) async {
    try {
      final db = await _databaseService.database;
      final searchPattern = '%$query%';

      // Use LIKE search with indexes for good performance
      final results = await db.query(
        AppConstants.tableProductTemplates,
        where: 'name_vi LIKE ? OR name_en LIKE ? OR aliases LIKE ?',
        whereArgs: [searchPattern, searchPattern, searchPattern],
        limit: AppConstants.searchSuggestionLimit,
      );

      debugPrint('🔍 LIKE search found ${results.length} templates for: $query');
      return results.map((json) => ProductTemplate.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error searching templates: $e');
      rethrow;
    }
  }

  /// Get template by ID
  Future<ProductTemplate?> getTemplateById(String id) async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableProductTemplates,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return ProductTemplate.fromJson(results.first);
    } catch (e) {
      debugPrint('❌ Error getting template by ID: $e');
      rethrow;
    }
  }

  /// Get templates by category
  Future<List<ProductTemplate>> getTemplatesByCategory(String category) async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableProductTemplates,
        where: 'category = ?',
        whereArgs: [category],
      );

      return results.map((json) => ProductTemplate.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting templates by category: $e');
      rethrow;
    }
  }

  // ==================== CUSTOM TEMPLATES ====================

  /// Insert a custom product template
  Future<int> insertCustomTemplate(ProductTemplate template) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toIso8601String();

      final data = {
        'id': template.id,
        'name_vi': template.nameVi,
        'name_en': template.nameEn,
        'aliases': template.aliases.isEmpty ? '[]' : '["${template.aliases.join('","')}"]',
        'category': template.category,
        'shelf_life_refrigerated': template.shelfLifeRefrigerated,
        'shelf_life_frozen': template.shelfLifeFrozen,
        'shelf_life_pantry': template.shelfLifePantry,
        'shelf_life_opened': template.shelfLifeOpened,
        'created_at': now,
        'updated_at': now,
      };

      final result = await db.insert(
        AppConstants.tableCustomTemplates,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('✅ Inserted custom template: ${template.nameVi}');
      return result;
    } catch (e) {
      debugPrint('❌ Error inserting custom template: $e');
      rethrow;
    }
  }

  /// Search custom templates
  Future<List<ProductTemplate>> searchCustomTemplates(String query) async {
    try {
      final db = await _databaseService.database;
      final searchPattern = '%$query%';

      final results = await db.query(
        AppConstants.tableCustomTemplates,
        where: 'name_vi LIKE ? OR name_en LIKE ? OR aliases LIKE ?',
        whereArgs: [searchPattern, searchPattern, searchPattern],
        limit: AppConstants.searchSuggestionLimit,
      );

      debugPrint('🔍 Found ${results.length} custom templates for: $query');
      return results.map((json) => ProductTemplate.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error searching custom templates: $e');
      rethrow;
    }
  }

  /// Get all custom templates
  Future<List<ProductTemplate>> getAllCustomTemplates() async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableCustomTemplates,
        orderBy: 'name_vi ASC',
      );

      return results.map((json) => ProductTemplate.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting all custom templates: $e');
      rethrow;
    }
  }

  /// Delete custom template
  Future<int> deleteCustomTemplate(String id) async {
    try {
      final db = await _databaseService.database;
      final result = await db.delete(
        AppConstants.tableCustomTemplates,
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('✅ Deleted custom template: $id');
      return result;
    } catch (e) {
      debugPrint('❌ Error deleting custom template: $e');
      rethrow;
    }
  }

  // ==================== CATEGORIES ====================

  /// Get all categories
  Future<List<models.Category>> getAllCategories() async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableCategories,
        orderBy: 'sort_order ASC',
      );

      return results.map((json) => models.Category.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error getting all categories: $e');
      rethrow;
    }
  }

  /// Get category by ID
  Future<models.Category?> getCategoryById(String id) async {
    try {
      final db = await _databaseService.database;
      final results = await db.query(
        AppConstants.tableCategories,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return models.Category.fromJson(results.first);
    } catch (e) {
      debugPrint('❌ Error getting category by ID: $e');
      rethrow;
    }
  }
}
