import 'package:flutter/foundation.dart';

import '../../config/app_localizations.dart';
import '../../data/models/user_product.dart';
import '../../data/models/product_template.dart';
import '../../data/repositories/product_repository.dart';

/// Sort options for product list
enum SortOption {
  expiryAsc,
  expiryDesc,
  nameAsc,
  nameDesc,
  createdDesc,
  createdAsc;

  String get displayName {
    switch (this) {
      case SortOption.expiryAsc:
        return 'Gần hết hạn nhất';
      case SortOption.expiryDesc:
        return 'Còn hạn lâu nhất';
      case SortOption.nameAsc:
        return 'Tên A-Z';
      case SortOption.nameDesc:
        return 'Tên Z-A';
      case SortOption.createdDesc:
        return 'Mới thêm nhất';
      case SortOption.createdAsc:
        return 'Cũ nhất';
    }
  }

  String getLocalizedName(AppLocalizations l10n) {
    switch (this) {
      case SortOption.expiryAsc:
        return l10n.expiryDateSoon;
      case SortOption.expiryDesc:
        return l10n.expiryDateLate;
      case SortOption.nameAsc:
        return l10n.nameAZ;
      case SortOption.nameDesc:
        return l10n.nameZA;
      case SortOption.createdDesc:
        return l10n.addedNewest;
      case SortOption.createdAsc:
        return l10n.addedOldest;
    }
  }
}

/// Product Provider
/// Manages product state and operations
class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  // State
  List<UserProduct> _products = []; // All products (for stats)
  List<UserProduct> _filteredProducts = []; // Filtered products (for display)
  List<UserProduct> _expiringSoon = [];
  List<UserProduct> _recentProducts = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'all';
  SortOption _sortBy = SortOption.expiryAsc;

  // Getters
  List<UserProduct> get products => _products;
  List<UserProduct> get expiringSoon => _expiringSoon;
  List<UserProduct> get recentProducts => _recentProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  SortOption get sortBy => _sortBy;

  /// Filtered and sorted products (optimized)
  ///
  /// Returns pre-filtered products from database, then sorted in memory.
  /// This avoids filtering large datasets in memory.
  List<UserProduct> get filteredProducts {
    return _sortProducts(_filteredProducts);
  }

  /// Total count
  int get totalCount => _products.length;

  /// Expiring soon count
  int get expiringSoonCount => _expiringSoon.length;

  /// Category statistics
  Map<String, int> get categoryStats {
    final Map<String, int> stats = {};
    for (final product in _products) {
      stats[product.category] = (stats[product.category] ?? 0) + 1;
    }
    return stats;
  }

  // ==================== LOAD DATA ====================

  /// Load all products
  Future<void> loadProducts() async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _repository.getAllProducts();
      if (result.isSuccess) {
        _products = result.data!;
        // Also update filtered products to match
        _filteredProducts = _products;
        debugPrint('✅ Loaded ${_products.length} products');
      } else {
        _error = result.error;
        debugPrint('❌ Error loading products: $_error');
      }
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi tải sản phẩm.';
      debugPrint('❌ Exception loading products: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load expiring soon products
  Future<void> loadExpiringSoon({bool notify = true}) async {
    try {
      final result = await _repository.getExpiringSoon(7);
      if (result.isSuccess) {
        _expiringSoon = result.data!;
        debugPrint('✅ Loaded ${_expiringSoon.length} expiring soon products');
        if (notify) notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Exception loading expiring soon: $e');
    }
  }

  /// Load recent products
  Future<void> loadRecentProducts({bool notify = true}) async {
    try {
      final result = await _repository.getRecentProducts(7);
      if (result.isSuccess) {
        _recentProducts = result.data!;
        debugPrint('✅ Loaded ${_recentProducts.length} recent products');
        if (notify) notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Exception loading recent products: $e');
    }
  }

  /// Load dashboard data (all at once) - optimized
  ///
  /// Loads all dashboard data in parallel and notifies listeners only once
  /// at the end. This prevents multiple UI rebuilds during data loading.
  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Notify loading state started

    try {
      // Load all data in parallel WITHOUT notifying
      final results = await Future.wait([
        _repository.getAllProducts(),
        _repository.getExpiringSoon(7),
        _repository.getRecentProducts(7),
      ]);

      // Update all state at once
      if (results[0].isSuccess) {
        _products = results[0].data!;
        _filteredProducts = _products;
        debugPrint('✅ Loaded ${_products.length} products');
      }
      if (results[1].isSuccess) {
        _expiringSoon = results[1].data!;
        debugPrint('✅ Loaded ${_expiringSoon.length} expiring soon products');
      }
      if (results[2].isSuccess) {
        _recentProducts = results[2].data!;
        debugPrint('✅ Loaded ${_recentProducts.length} recent products');
      }

      debugPrint('✅ Dashboard data loaded - notifying once');
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi tải dữ liệu.';
      debugPrint('❌ Exception loading dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Single notification with all data loaded
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadDashboard();
  }

  // ==================== CRUD OPERATIONS ====================

  /// Add product
  Future<bool> addProduct(UserProduct product) async {
    _setLoading(true);
    _error = null;

    try {
      // Validate
      final validationError = _repository.validateProduct(product);
      if (validationError != null) {
        _error = validationError;
        _setLoading(false);
        return false;
      }

      final result = await _repository.addProduct(product);
      if (result.isSuccess) {
        await loadDashboard(); // Reload all data
        debugPrint('✅ Product added successfully');
        return true;
      } else {
        _error = result.error;
        debugPrint('❌ Error adding product: $_error');
        return false;
      }
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi thêm sản phẩm.';
      debugPrint('❌ Exception adding product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update product
  Future<bool> updateProduct(UserProduct product) async {
    _setLoading(true);
    _error = null;

    try {
      // Validate
      final validationError = _repository.validateProduct(product);
      if (validationError != null) {
        _error = validationError;
        _setLoading(false);
        return false;
      }

      final result = await _repository.updateProduct(product);
      if (result.isSuccess) {
        await loadDashboard(); // Reload all data
        debugPrint('✅ Product updated successfully');
        return true;
      } else {
        _error = result.error;
        debugPrint('❌ Error updating product: $_error');
        return false;
      }
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi cập nhật sản phẩm.';
      debugPrint('❌ Exception updating product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String id) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _repository.deleteProduct(id);
      if (result.isSuccess) {
        await loadDashboard(); // Reload all data
        debugPrint('✅ Product deleted successfully');
        return true;
      } else {
        _error = result.error;
        debugPrint('❌ Error deleting product: $_error');
        return false;
      }
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi xóa sản phẩm.';
      debugPrint('❌ Exception deleting product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Mark product as used
  Future<bool> markAsUsed(String id) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _repository.markAsUsed(id);
      if (result.isSuccess) {
        await loadDashboard(); // Reload all data
        debugPrint('✅ Product marked as used');
        return true;
      } else {
        _error = result.error;
        debugPrint('❌ Error marking as used: $_error');
        return false;
      }
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi đánh dấu đã sử dụng.';
      debugPrint('❌ Exception marking as used: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== FILTER & SORT ====================

  /// Set category filter (optimized with database-level filtering)
  Future<void> setCategory(String category) async {
    if (_selectedCategory == category) return;

    _selectedCategory = category;
    _setLoading(true);

    try {
      if (category == 'all') {
        // Load all products from database
        final result = await _repository.getAllProducts();
        if (result.isSuccess) {
          _products = result.data!;
          _filteredProducts = _products;
          debugPrint('📂 Category filter: all (${_products.length} products)');
        }
      } else {
        // Load filtered products from database
        final result = await _repository.getProductsByCategory(category);
        if (result.isSuccess) {
          _filteredProducts = result.data!;
          debugPrint('📂 Category filter: $category (${_filteredProducts.length} products)');
        }
      }
    } catch (e) {
      debugPrint('❌ Error filtering by category: $e');
      // Fallback to in-memory filtering if database query fails
      _filteredProducts = category == 'all'
          ? _products
          : _products.where((p) => p.category == category).toList();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Set sort option
  void setSortOption(SortOption option) {
    if (_sortBy != option) {
      _sortBy = option;
      notifyListeners();
      debugPrint('🔄 Sort by: ${option.displayName}');
    }
  }

  /// Sort products
  List<UserProduct> _sortProducts(List<UserProduct> products) {
    final sorted = List<UserProduct>.from(products);

    switch (_sortBy) {
      case SortOption.expiryAsc:
        sorted.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
      case SortOption.expiryDesc:
        sorted.sort((a, b) => b.expiryDate.compareTo(a.expiryDate));
        break;
      case SortOption.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.createdDesc:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.createdAsc:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return sorted;
  }

  // ==================== SEARCH ====================

  /// Search product templates
  Future<List<ProductTemplate>> searchTemplates(String query) async {
    if (query.trim().length < 2) {
      return [];
    }

    try {
      // Search both system templates and custom templates
      final results = await Future.wait([
        _repository.searchTemplates(query),
        _repository.searchCustomTemplates(query),
      ]);

      final systemTemplates = results[0];
      final customTemplates = results[1];

      // Merge results: custom templates first (higher priority), then system templates
      final allTemplates = <ProductTemplate>[];

      if (customTemplates.isSuccess) {
        allTemplates.addAll(customTemplates.data!);
      }

      if (systemTemplates.isSuccess) {
        allTemplates.addAll(systemTemplates.data!);
      }

      debugPrint('🔍 Found ${allTemplates.length} templates (${customTemplates.data?.length ?? 0} custom + ${systemTemplates.data?.length ?? 0} system) for: $query');
      return allTemplates;
    } catch (e) {
      debugPrint('❌ Exception searching templates: $e');
      return [];
    }
  }

  /// Get all product templates
  Future<List<ProductTemplate>> getAllTemplates() async {
    try {
      final result = await _repository.getAllTemplates();
      if (result.isSuccess) {
        return result.data!;
      }
      return [];
    } catch (e) {
      debugPrint('❌ Exception getting all templates: $e');
      return [];
    }
  }

  /// Get product template by ID
  Future<ProductTemplate?> getProductTemplate(String id) async {
    try {
      return await _repository.getProductTemplate(id);
    } catch (e) {
      debugPrint('❌ Exception getting template by ID: $e');
      return null;
    }
  }

  /// Search user products
  Future<List<UserProduct>> searchProducts(String query) async {
    if (query.trim().length < 2) {
      return filteredProducts;
    }

    try {
      final result = await _repository.searchProducts(query);
      if (result.isSuccess) {
        debugPrint('🔍 Found ${result.data!.length} products for: $query');
        return _sortProducts(result.data!);
      } else {
        debugPrint('❌ Error searching products: ${result.error}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Exception searching products: $e');
      return [];
    }
  }

  /// Save custom product template
  Future<bool> saveCustomTemplate(ProductTemplate template) async {
    try {
      final result = await _repository.saveCustomTemplate(template);
      if (result.isSuccess) {
        debugPrint('✅ Custom template saved: ${template.nameVi}');
        return true;
      } else {
        debugPrint('❌ Error saving custom template: ${result.error}');
        _error = result.error;
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception saving custom template: $e');
      _error = 'Không thể lưu mẫu tùy chỉnh.';
      return false;
    }
  }

  // ==================== HELPERS ====================

  /// Get product by ID
  UserProduct? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
