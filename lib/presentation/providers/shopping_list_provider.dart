import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../config/constants.dart';
import '../../data/models/shopping_list_item.dart';
import '../../data/models/product_template.dart';
import '../../data/models/user_product.dart';
import '../../services/database_service.dart';

/// Shopping List Provider
/// Manages shopping list state and operations
class ShoppingListProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  List<ShoppingListItem> _items = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ShoppingListItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  /// Load all shopping list items
  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tableShoppingList,
        orderBy: 'sort_order ASC',
      );

      _items = maps.map((map) => ShoppingListItem.fromMap(map)).toList();
      debugPrint('✅ Loaded ${_items.length} shopping list items');
    } catch (e) {
      _error = 'Failed to load shopping list: $e';
      debugPrint('❌ Error loading shopping list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new item to shopping list
  Future<bool> addItem(String name, {String unit = 'cái', String category = 'other'}) async {
    if (name.trim().isEmpty) return false;

    // Check for duplicates
    if (_items.any((item) => item.name.toLowerCase() == name.trim().toLowerCase())) {
      _error = 'Item already exists in shopping list';
      notifyListeners();
      return false;
    }

    try {
      final db = await _databaseService.database;
      final newItem = ShoppingListItem(
        id: _uuid.v4(),
        name: name.trim(),
        unit: unit,
        category: category,
        sortOrder: _items.length,
        createdAt: DateTime.now(),
      );

      await db.insert(
        AppConstants.tableShoppingList,
        newItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _items.add(newItem);
      debugPrint('✅ Added item to shopping list: ${newItem.name} ($unit, $category)');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add item: $e';
      debugPrint('❌ Error adding item: $e');
      notifyListeners();
      return false;
    }
  }

  /// Add item from product template (with nutrition data preserved)
  Future<bool> addItemFromTemplate(
    ProductTemplate template, {
    double quantity = 1.0,
    String? unit,
  }) async {
    // Check for duplicates
    if (_items.any((item) => item.name.toLowerCase() == template.nameVi.toLowerCase())) {
      _error = 'Item already exists in shopping list';
      notifyListeners();
      return false;
    }

    try {
      final db = await _databaseService.database;
      final newItem = ShoppingListItem.fromTemplate(
        template,
        id: _uuid.v4(),
        quantity: quantity,
        unit: unit,
        sortOrder: _items.length,
      );

      await db.insert(
        AppConstants.tableShoppingList,
        newItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _items.add(newItem);
      debugPrint('✅ Added item from template: ${newItem.name} (with nutrition data: ${newItem.nutritionData != null})');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add item from template: $e';
      debugPrint('❌ Error adding item from template: $e');
      notifyListeners();
      return false;
    }
  }

  /// Add item from user product (when moving from fridge to shopping list)
  /// Preserves nutrition data if template is provided
  Future<bool> addItemFromUserProduct(
    UserProduct product,
    ProductTemplate? template,
  ) async {
    // Check for duplicates
    if (_items.any((item) => item.name.toLowerCase() == product.name.toLowerCase())) {
      _error = 'Item already exists in shopping list';
      notifyListeners();
      return false;
    }

    try {
      final db = await _databaseService.database;
      final newItem = ShoppingListItem.fromUserProduct(
        product,
        template,
        sortOrder: _items.length,
      );

      await db.insert(
        AppConstants.tableShoppingList,
        newItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _items.add(newItem);
      debugPrint('✅ Added item from user product: ${newItem.name} (with nutrition data: ${newItem.nutritionData != null})');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add item from user product: $e';
      debugPrint('❌ Error adding item from user product: $e');
      notifyListeners();
      return false;
    }
  }

  /// Add multiple items to shopping list
  Future<int> addItems(List<String> names) async {
    int addedCount = 0;

    try {
      final db = await _databaseService.database;
      final batch = db.batch();

      for (final name in names) {
        if (name.trim().isEmpty) continue;

        // Skip duplicates
        if (_items.any((item) => item.name.toLowerCase() == name.trim().toLowerCase())) {
          continue;
        }

        final newItem = ShoppingListItem(
          id: _uuid.v4(),
          name: name.trim(),
          sortOrder: _items.length + addedCount,
          createdAt: DateTime.now(),
        );

        batch.insert(
          AppConstants.tableShoppingList,
          newItem.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        _items.add(newItem);
        addedCount++;
      }

      await batch.commit(noResult: true);
      debugPrint('✅ Added $addedCount items to shopping list');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add items: $e';
      debugPrint('❌ Error adding items: $e');
    }

    return addedCount;
  }

  /// Add multiple items with units to shopping list
  Future<int> addItemsWithUnits(List<Map<String, String>> items) async {
    int addedCount = 0;

    try {
      final db = await _databaseService.database;
      final batch = db.batch();

      for (final item in items) {
        final name = item['name'] ?? '';
        final unit = item['unit'] ?? 'cái';
        final category = item['category'] ?? 'other';

        if (name.trim().isEmpty) continue;

        // Skip duplicates
        if (_items.any((i) => i.name.toLowerCase() == name.trim().toLowerCase())) {
          continue;
        }

        final newItem = ShoppingListItem(
          id: _uuid.v4(),
          name: name.trim(),
          unit: unit,
          category: category,
          sortOrder: _items.length + addedCount,
          createdAt: DateTime.now(),
        );

        batch.insert(
          AppConstants.tableShoppingList,
          newItem.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        _items.add(newItem);
        addedCount++;
      }

      await batch.commit(noResult: true);
      debugPrint('✅ Added $addedCount items with units to shopping list');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add items: $e';
      debugPrint('❌ Error adding items: $e');
    }

    return addedCount;
  }

  /// Delete an item from shopping list
  Future<bool> deleteItem(String id) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        AppConstants.tableShoppingList,
        where: 'id = ?',
        whereArgs: [id],
      );

      _items.removeWhere((item) => item.id == id);

      // Reorder remaining items
      await _reorderItems();

      debugPrint('✅ Deleted item from shopping list');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete item: $e';
      debugPrint('❌ Error deleting item: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete multiple items from shopping list
  Future<bool> deleteItems(List<String> ids) async {
    if (ids.isEmpty) return false;

    try {
      final db = await _databaseService.database;
      final batch = db.batch();

      for (final id in ids) {
        batch.delete(
          AppConstants.tableShoppingList,
          where: 'id = ?',
          whereArgs: [id],
        );
      }

      await batch.commit(noResult: true);
      _items.removeWhere((item) => ids.contains(item.id));

      // Reorder remaining items
      await _reorderItems();

      debugPrint('✅ Deleted ${ids.length} items from shopping list');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete items: $e';
      debugPrint('❌ Error deleting items: $e');
      notifyListeners();
      return false;
    }
  }

  /// Clear all items from shopping list
  Future<bool> clearAll() async {
    try {
      final db = await _databaseService.database;
      await db.delete(AppConstants.tableShoppingList);

      _items.clear();
      debugPrint('✅ Cleared shopping list');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to clear shopping list: $e';
      debugPrint('❌ Error clearing shopping list: $e');
      notifyListeners();
      return false;
    }
  }

  /// Reorder items after moving/deleting
  Future<void> reorderItem(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    try {
      // Adjust newIndex if moving down
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // Move item in list
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);

      // Update sort orders
      await _reorderItems();

      debugPrint('✅ Reordered item from $oldIndex to $newIndex');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to reorder item: $e';
      debugPrint('❌ Error reordering item: $e');
      notifyListeners();
    }
  }

  /// Update sort order for all items
  Future<void> _reorderItems() async {
    try {
      final db = await _databaseService.database;
      final batch = db.batch();

      for (int i = 0; i < _items.length; i++) {
        final updatedItem = _items[i].copyWith(sortOrder: i);
        _items[i] = updatedItem;

        batch.update(
          AppConstants.tableShoppingList,
          {'sort_order': i},
          where: 'id = ?',
          whereArgs: [updatedItem.id],
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('⚠️ Error reordering items: $e');
    }
  }

  /// Update an item
  Future<bool> updateItem(ShoppingListItem item) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        AppConstants.tableShoppingList,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );

      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
      }

      debugPrint('✅ Updated item: ${item.name}');
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update item: $e';
      debugPrint('❌ Error updating item: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update item quantity
  Future<bool> updateQuantity(String id, double quantity) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return false;

    final updatedItem = _items[index].copyWith(quantity: quantity);
    return updateItem(updatedItem);
  }

  /// Update item unit
  Future<bool> updateUnit(String id, String unit) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return false;

    final updatedItem = _items[index].copyWith(unit: unit);
    return updateItem(updatedItem);
  }

  /// Update item category
  Future<bool> updateCategory(String id, String category) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return false;

    final updatedItem = _items[index].copyWith(category: category);
    return updateItem(updatedItem);
  }

  /// Toggle purchased state
  Future<bool> togglePurchased(String id) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return false;

    final updatedItem = _items[index].copyWith(
      isPurchased: !_items[index].isPurchased,
    );
    return updateItem(updatedItem);
  }

  /// Refresh shopping list
  Future<void> refresh() async {
    await loadItems();
  }
}
