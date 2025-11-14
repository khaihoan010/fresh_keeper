import 'package:flutter/foundation.dart';

import '../../data/models/user_product.dart';

/// Multi-Select Provider
/// Manages multi-select state for product lists
class MultiSelectProvider with ChangeNotifier {
  bool _isMultiSelectMode = false;
  final Set<String> _selectedProductIds = {};

  // Getters
  bool get isMultiSelectMode => _isMultiSelectMode;
  Set<String> get selectedProductIds => Set.unmodifiable(_selectedProductIds);
  int get selectedCount => _selectedProductIds.length;
  bool get hasSelection => _selectedProductIds.isNotEmpty;

  /// Check if a product is selected
  bool isSelected(String productId) {
    return _selectedProductIds.contains(productId);
  }

  /// Enter multi-select mode with initial selection
  void enterMultiSelectMode(String initialProductId) {
    _isMultiSelectMode = true;
    _selectedProductIds.clear();
    _selectedProductIds.add(initialProductId);
    debugPrint('✅ Entered multi-select mode with product: $initialProductId');
    notifyListeners();
  }

  /// Exit multi-select mode
  void exitMultiSelectMode() {
    _isMultiSelectMode = false;
    _selectedProductIds.clear();
    debugPrint('✅ Exited multi-select mode');
    notifyListeners();
  }

  /// Toggle product selection
  void toggleSelection(String productId) {
    if (_selectedProductIds.contains(productId)) {
      _selectedProductIds.remove(productId);
      debugPrint('➖ Deselected product: $productId');
    } else {
      _selectedProductIds.add(productId);
      debugPrint('➕ Selected product: $productId');
    }

    // Auto-exit if no selections remain
    if (_selectedProductIds.isEmpty) {
      exitMultiSelectMode();
    } else {
      notifyListeners();
    }
  }

  /// Select all products from a list
  void selectAll(List<UserProduct> products) {
    _selectedProductIds.clear();
    for (final product in products) {
      _selectedProductIds.add(product.id);
    }
    debugPrint('✅ Selected all ${_selectedProductIds.length} products');
    notifyListeners();
  }

  /// Deselect all products
  void deselectAll() {
    _selectedProductIds.clear();
    exitMultiSelectMode();
  }

  /// Get list of selected products from a list
  List<UserProduct> getSelectedProducts(List<UserProduct> allProducts) {
    return allProducts.where((p) => _selectedProductIds.contains(p.id)).toList();
  }

  /// Clear selections without exiting multi-select mode
  void clearSelections() {
    _selectedProductIds.clear();
    notifyListeners();
  }
}
