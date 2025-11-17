import 'package:flutter/foundation.dart';

import '../data_sources/local/product_local_data_source.dart';
import '../models/user_product.dart';
import '../models/product_template.dart';
import '../models/category.dart' as models;

/// Result wrapper for repository operations
class Result<T> {
  final T? data;
  final String? error;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
}

/// Dashboard Statistics
class DashboardStats {
  final int totalProducts;
  final int expiringSoonCount;
  final List<UserProduct> recentProducts;
  final Map<String, int> categoryStats;

  DashboardStats({
    required this.totalProducts,
    required this.expiringSoonCount,
    required this.recentProducts,
    required this.categoryStats,
  });
}

/// Product Repository
/// Business logic layer for product operations
class ProductRepository {
  final ProductLocalDataSource _localDataSource;

  ProductRepository(this._localDataSource);

  // ==================== USER PRODUCTS ====================

  /// Add a new product
  Future<Result<int>> addProduct(UserProduct product) async {
    try {
      final result = await _localDataSource.insertProduct(product);
      return Result.success(result);
    } catch (e) {
      debugPrint('❌ Repository: Error adding product - $e');
      return Result.failure('Không thể thêm sản phẩm. Vui lòng thử lại.');
    }
  }

  /// Get product by ID
  Future<Result<UserProduct>> getProduct(String id) async {
    try {
      final product = await _localDataSource.getProductById(id);
      if (product == null) {
        return Result.failure('Không tìm thấy sản phẩm.');
      }
      return Result.success(product);
    } catch (e) {
      debugPrint('❌ Repository: Error getting product - $e');
      return Result.failure('Không thể tải sản phẩm. Vui lòng thử lại.');
    }
  }

  /// Get all active products
  Future<Result<List<UserProduct>>> getAllProducts() async {
    try {
      final products = await _localDataSource.getAllProducts();
      return Result.success(products);
    } catch (e) {
      debugPrint('❌ Repository: Error getting all products - $e');
      return Result.failure('Không thể tải danh sách sản phẩm.');
    }
  }

  /// Get products by category
  Future<Result<List<UserProduct>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final products = await _localDataSource.getProductsByCategory(category);
      return Result.success(products);
    } catch (e) {
      debugPrint('❌ Repository: Error getting products by category - $e');
      return Result.failure('Không thể tải sản phẩm theo danh mục.');
    }
  }

  /// Get expiring soon products
  Future<Result<List<UserProduct>>> getExpiringSoon(int days) async {
    try {
      final products = await _localDataSource.getExpiringSoon(days);
      return Result.success(products);
    } catch (e) {
      debugPrint('❌ Repository: Error getting expiring soon - $e');
      return Result.failure('Không thể tải sản phẩm gần hết hạn.');
    }
  }

  /// Get recently added products
  Future<Result<List<UserProduct>>> getRecentProducts(int days) async {
    try {
      final products = await _localDataSource.getRecentProducts(days);
      return Result.success(products);
    } catch (e) {
      debugPrint('❌ Repository: Error getting recent products - $e');
      return Result.failure('Không thể tải sản phẩm mới thêm.');
    }
  }

  /// Search products
  Future<Result<List<UserProduct>>> searchProducts(String query) async {
    try {
      if (query.trim().isEmpty) {
        return Result.success([]);
      }
      final products = await _localDataSource.searchProducts(query);
      return Result.success(products);
    } catch (e) {
      debugPrint('❌ Repository: Error searching products - $e');
      return Result.failure('Không thể tìm kiếm sản phẩm.');
    }
  }

  /// Update product
  Future<Result<int>> updateProduct(UserProduct product) async {
    try {
      final result = await _localDataSource.updateProduct(product);
      if (result == 0) {
        return Result.failure('Không tìm thấy sản phẩm để cập nhật.');
      }
      return Result.success(result);
    } catch (e) {
      debugPrint('❌ Repository: Error updating product - $e');
      return Result.failure('Không thể cập nhật sản phẩm. Vui lòng thử lại.');
    }
  }

  /// Delete product
  Future<Result<int>> deleteProduct(String id) async {
    try {
      final result = await _localDataSource.deleteProduct(id);
      if (result == 0) {
        return Result.failure('Không tìm thấy sản phẩm để xóa.');
      }
      return Result.success(result);
    } catch (e) {
      debugPrint('❌ Repository: Error deleting product - $e');
      return Result.failure('Không thể xóa sản phẩm. Vui lòng thử lại.');
    }
  }

  /// Mark product as used
  Future<Result<int>> markAsUsed(String id) async {
    try {
      final productResult = await getProduct(id);
      if (productResult.isFailure) {
        return Result.failure(productResult.error!);
      }

      final product = productResult.data!;
      final updatedProduct = product.copyWith(status: ProductStatus.used);

      return await updateProduct(updatedProduct);
    } catch (e) {
      debugPrint('❌ Repository: Error marking as used - $e');
      return Result.failure('Không thể đánh dấu đã sử dụng.');
    }
  }

  // ==================== STATISTICS ====================

  /// Get dashboard statistics
  Future<Result<DashboardStats>> getDashboardStats() async {
    try {
      // Run all queries in parallel for better performance
      final results = await Future.wait([
        _localDataSource.getTotalCount(),
        _localDataSource.getExpiringSoonCount(7),
        _localDataSource.getRecentProducts(7),
        _localDataSource.getCountByCategory(),
      ]);

      final stats = DashboardStats(
        totalProducts: results[0] as int,
        expiringSoonCount: results[1] as int,
        recentProducts: results[2] as List<UserProduct>,
        categoryStats: results[3] as Map<String, int>,
      );

      return Result.success(stats);
    } catch (e) {
      debugPrint('❌ Repository: Error getting dashboard stats - $e');
      return Result.failure('Không thể tải thống kê.');
    }
  }

  // ==================== PRODUCT TEMPLATES ====================

  /// Search product templates
  Future<Result<List<ProductTemplate>>> searchTemplates(String query) async {
    try {
      if (query.trim().isEmpty) {
        return Result.success([]);
      }
      final templates = await _localDataSource.searchTemplates(query);
      return Result.success(templates);
    } catch (e) {
      debugPrint('❌ Repository: Error searching templates - $e');
      return Result.failure('Không thể tìm kiếm sản phẩm.');
    }
  }

  /// Get template by ID
  Future<Result<ProductTemplate>> getTemplate(String id) async {
    try {
      final template = await _localDataSource.getTemplateById(id);
      if (template == null) {
        return Result.failure('Không tìm thấy template.');
      }
      return Result.success(template);
    } catch (e) {
      debugPrint('❌ Repository: Error getting template - $e');
      return Result.failure('Không thể tải template.');
    }
  }

  /// Get product template directly (for UI use)
  Future<ProductTemplate?> getProductTemplate(String id) async {
    try {
      return await _localDataSource.getTemplateById(id);
    } catch (e) {
      debugPrint('❌ Repository: Error getting product template - $e');
      return null;
    }
  }

  /// Get all product templates
  Future<Result<List<ProductTemplate>>> getAllTemplates() async {
    try {
      final templates = await _localDataSource.getAllTemplates();
      return Result.success(templates);
    } catch (e) {
      debugPrint('❌ Repository: Error getting all templates - $e');
      return Result.failure('Không thể tải danh sách template.');
    }
  }

  /// Get templates by category
  Future<Result<List<ProductTemplate>>> getTemplatesByCategory(
    String category,
  ) async {
    try {
      final templates = await _localDataSource.getTemplatesByCategory(category);
      return Result.success(templates);
    } catch (e) {
      debugPrint('❌ Repository: Error getting templates by category - $e');
      return Result.failure('Không thể tải templates.');
    }
  }

  // ==================== CUSTOM TEMPLATES ====================

  /// Save a custom product template
  Future<Result<int>> saveCustomTemplate(ProductTemplate template) async {
    try {
      final result = await _localDataSource.insertCustomTemplate(template);
      return Result.success(result);
    } catch (e) {
      debugPrint('❌ Repository: Error saving custom template - $e');
      return Result.failure('Không thể lưu mẫu tùy chỉnh.');
    }
  }

  /// Search custom templates
  Future<Result<List<ProductTemplate>>> searchCustomTemplates(String query) async {
    try {
      if (query.trim().isEmpty) {
        return Result.success([]);
      }
      final templates = await _localDataSource.searchCustomTemplates(query);
      return Result.success(templates);
    } catch (e) {
      debugPrint('❌ Repository: Error searching custom templates - $e');
      return Result.failure('Không thể tìm kiếm mẫu tùy chỉnh.');
    }
  }

  /// Get all custom templates
  Future<Result<List<ProductTemplate>>> getAllCustomTemplates() async {
    try {
      final templates = await _localDataSource.getAllCustomTemplates();
      return Result.success(templates);
    } catch (e) {
      debugPrint('❌ Repository: Error getting custom templates - $e');
      return Result.failure('Không thể tải mẫu tùy chỉnh.');
    }
  }

  /// Delete custom template
  Future<Result<int>> deleteCustomTemplate(String id) async {
    try {
      final result = await _localDataSource.deleteCustomTemplate(id);
      if (result == 0) {
        return Result.failure('Không tìm thấy mẫu để xóa.');
      }
      return Result.success(result);
    } catch (e) {
      debugPrint('❌ Repository: Error deleting custom template - $e');
      return Result.failure('Không thể xóa mẫu tùy chỉnh.');
    }
  }

  // ==================== CATEGORIES ====================

  /// Get all categories
  Future<Result<List<models.Category>>> getAllCategories() async {
    try {
      final categories = await _localDataSource.getAllCategories();
      return Result.success(categories);
    } catch (e) {
      debugPrint('❌ Repository: Error getting categories - $e');
      return Result.failure('Không thể tải danh mục.');
    }
  }

  /// Get category by ID
  Future<Result<models.Category>> getCategory(String id) async {
    try {
      final category = await _localDataSource.getCategoryById(id);
      if (category == null) {
        return Result.failure('Không tìm thấy danh mục.');
      }
      return Result.success(category);
    } catch (e) {
      debugPrint('❌ Repository: Error getting category - $e');
      return Result.failure('Không thể tải danh mục.');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Get products grouped by expiry urgency
  Future<Result<Map<String, List<UserProduct>>>> getProductsGroupedByUrgency() async {
    try {
      final result = await getExpiringSoon(7);
      if (result.isFailure) {
        return Result.failure(result.error!);
      }

      final products = result.data!;
      final Map<String, List<UserProduct>> grouped = {
        'expired': [],
        'today': [],
        'urgent': [], // 1-2 days
        'soon': [], // 3-7 days
      };

      for (final product in products) {
        if (product.isExpired) {
          grouped['expired']!.add(product);
        } else if (product.daysUntilExpiry == 0) {
          grouped['today']!.add(product);
        } else if (product.daysUntilExpiry <= 2) {
          grouped['urgent']!.add(product);
        } else {
          grouped['soon']!.add(product);
        }
      }

      return Result.success(grouped);
    } catch (e) {
      debugPrint('❌ Repository: Error grouping products - $e');
      return Result.failure('Không thể nhóm sản phẩm.');
    }
  }

  /// Validate product data before saving
  String? validateProduct(UserProduct product) {
    if (product.name.trim().isEmpty) {
      return 'Tên sản phẩm không được để trống.';
    }

    if (product.quantity < 0) {
      return 'Số lượng không được âm.';
    }

    if (product.expiryDate.isBefore(product.purchaseDate)) {
      return 'Ngày hết hạn phải sau ngày mua.';
    }

    if (product.purchaseDate.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      return 'Ngày mua không thể là tương lai.';
    }

    return null; // Valid
  }
}
