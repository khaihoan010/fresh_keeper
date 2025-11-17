import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/app_localizations.dart';
import '../../../config/constants.dart';
import '../../../data/models/shopping_list_item.dart';
import '../../../data/models/user_product.dart';
import '../../providers/shopping_list_provider.dart';
import '../../providers/multi_select_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';
import '../../widgets/multi_select/multi_select_app_bar.dart';
import '../../widgets/shopping_list/shopping_list_bottom_bar.dart';
import 'store_items_screen.dart';

/// Shopping List View for Bottom Navigation
/// Wrapper without Scaffold for use in IndexedStack
class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShoppingListScreen();
  }
}

/// Shopping List Screen
/// Reorderable list of items to purchase
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingListProvider>().loadItems();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await context.read<ShoppingListProvider>().refresh();
  }

  void _showAddItemDialog() {
    final l10n = AppLocalizations.of(context);
    _textController.clear();
    String selectedUnit = 'cái';
    String selectedCategory = 'other';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.addItem),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.enterItemName,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _addItem(value.trim(), selectedUnit, selectedCategory);
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    border: const OutlineInputBorder(),
                  ),
                  items: AppConstants.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat['id'],
                      child: Row(
                        children: [
                          Text(cat['icon']!, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(l10n.isVietnamese ? cat['name_vi']! : cat['name_en']!),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: InputDecoration(
                    labelText: l10n.unit,
                    border: const OutlineInputBorder(),
                  ),
                  items: AppConstants.units.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedUnit = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text.trim().isNotEmpty) {
                  _addItem(_textController.text.trim(), selectedUnit, selectedCategory);
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addItem(String name, String unit, String category) async {
    final provider = context.read<ShoppingListProvider>();
    final l10n = AppLocalizations.of(context);

    final success = await provider.addItem(name, unit: unit, category: category);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.itemAdded),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? l10n.itemAlreadyExists),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteItem(ShoppingListItem item) async {
    final provider = context.read<ShoppingListProvider>();
    final l10n = AppLocalizations.of(context);

    final success = await provider.deleteItem(item.id);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.itemDeleted),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  Future<void> _showClearListDialog() async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmClearList),
        content: Text(l10n.confirmClearListMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.clearList),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = context.read<ShoppingListProvider>();
      final success = await provider.clearAll();

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.listCleared),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    }
  }

  Future<void> _handleStore() async {
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.read<MultiSelectProvider>();
    final shoppingListProvider = context.read<ShoppingListProvider>();
    final productProvider = context.read<ProductProvider>();

    final selectedIds = multiSelectProvider.selectedProductIds;
    if (selectedIds.isEmpty) return;

    // Get selected items
    final selectedItems = shoppingListProvider.items
        .where((item) => selectedIds.contains(item.id.toString()))
        .toList();

    // Navigate to store items screen
    final result = await Navigator.push<List<StoreItemConfig>>(
      context,
      MaterialPageRoute(
        builder: (context) => StoreItemsScreen(items: selectedItems),
      ),
    );

    if (result == null || !mounted) return;

    // Create products from configured items
    final now = DateTime.now();
    for (final config in result) {
      final product = UserProduct(
        name: config.item.name,
        category: config.category,
        quantity: config.item.quantity.toDouble(),
        unit: config.item.unit,
        location: config.location,
        purchaseDate: now,
        expiryDate: config.expiryDate,
      );
      await productProvider.addProduct(product);
    }

    // Reload products to update home screen and badges
    await productProvider.loadProducts();

    // Delete items from shopping list (batch delete)
    await shoppingListProvider.deleteItems(selectedIds.toList());

    // Exit multi-select mode
    multiSelectProvider.exitMultiSelectMode();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.itemsStored(selectedIds.length)),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  Future<void> _handleBulkDeleteItems() async {
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.read<MultiSelectProvider>();
    final shoppingListProvider = context.read<ShoppingListProvider>();

    final selectedIds = multiSelectProvider.selectedProductIds;
    if (selectedIds.isEmpty) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteItems),
        content: Text(l10n.confirmDeleteItemsMessage(selectedIds.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Delete selected items (batch delete)
    await shoppingListProvider.deleteItems(selectedIds.toList());

    // Exit multi-select mode
    multiSelectProvider.exitMultiSelectMode();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.itemsDeleted(selectedIds.length)),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _handleLongPress(String itemId) {
    final multiSelectProvider = context.read<MultiSelectProvider>();
    if (!multiSelectProvider.isMultiSelectMode) {
      multiSelectProvider.enterMultiSelectMode(itemId);
    }
  }

  void _handleTap(String itemId) {
    final multiSelectProvider = context.read<MultiSelectProvider>();
    if (multiSelectProvider.isMultiSelectMode) {
      multiSelectProvider.toggleSelection(itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<MultiSelectProvider>(
      builder: (context, multiSelectProvider, _) {
        final isMultiSelectMode = multiSelectProvider.isMultiSelectMode;

        return Scaffold(
          appBar: isMultiSelectMode
              ? MultiSelectAppBar(
                  selectedCount: multiSelectProvider.selectedProductIds.length,
                  onExit: () => multiSelectProvider.exitMultiSelectMode(),
                )
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(l10n.shoppingList),
                  actions: [
                    Consumer<ShoppingListProvider>(
                      builder: (context, provider, _) {
                        if (provider.isEmpty) return const SizedBox.shrink();

                        return IconButton(
                          icon: const Icon(Icons.delete_sweep),
                          onPressed: _showClearListDialog,
                          tooltip: l10n.clearList,
                        );
                      },
                    ),
                  ],
                ),
          body: Column(
            children: [
              Expanded(
                child: Consumer<ShoppingListProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading && provider.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🛒', style: TextStyle(fontSize: 80)),
                            const SizedBox(height: 16),
                            Text(
                              l10n.emptyShoppingList,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.startAddingItems,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: provider.items.length,
                        onReorder: (oldIndex, newIndex) {
                          if (!isMultiSelectMode) {
                            provider.reorderItem(oldIndex, newIndex);
                          }
                        },
                        itemBuilder: (context, index) {
                          final item = provider.items[index];
                          final isSelected = multiSelectProvider.isSelected(item.id.toString());

                          return _ShoppingListItemTile(
                            key: ValueKey(item.id),
                            item: item,
                            index: index,
                            isSelected: isSelected,
                            isMultiSelectMode: isMultiSelectMode,
                            onDelete: () => _deleteItem(item),
                            onLongPress: () => _handleLongPress(item.id.toString()),
                            onTap: () => _handleTap(item.id.toString()),
                            onTogglePurchased: () => provider.togglePurchased(item.id),
                            onQuantityChanged: (qty) => provider.updateQuantity(item.id, qty),
                            onUnitChanged: (unit) => provider.updateUnit(item.id, unit),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              if (isMultiSelectMode)
                ShoppingListBottomBar(
                  onStore: _handleStore,
                  onDelete: _handleBulkDeleteItems,
                  allSelected: multiSelectProvider.selectedProductIds.length ==
                      context.read<ShoppingListProvider>().items.length,
                  onSelectAll: () {
                    final provider = context.read<ShoppingListProvider>();
                    for (final item in provider.items) {
                      if (!multiSelectProvider.isSelected(item.id)) {
                        multiSelectProvider.toggleSelection(item.id);
                      }
                    }
                  },
                  onDeselectAll: () {
                    multiSelectProvider.clearSelections();
                  },
                )
              else
                const BannerAdWidget(),
            ],
          ),
          floatingActionButton: isMultiSelectMode
              ? null
              : FloatingActionButton(
                  heroTag: 'shopping_list_fab',
                  onPressed: _showAddItemDialog,
                  child: const Icon(Icons.add, size: 32),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}

/// Shopping List Item Tile
class _ShoppingListItemTile extends StatelessWidget {
  final ShoppingListItem item;
  final int index;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final VoidCallback onTogglePurchased;
  final Function(double) onQuantityChanged;
  final Function(String) onUnitChanged;

  const _ShoppingListItemTile({
    required super.key,
    required this.item,
    required this.index,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onDelete,
    required this.onLongPress,
    required this.onTap,
    required this.onTogglePurchased,
    required this.onQuantityChanged,
    required this.onUnitChanged,
  });

  void _showQuantityEditDialog(BuildContext context) {
    final formattedQty = item.quantity == item.quantity.roundToDouble()
        ? item.quantity.toInt().toString()
        : item.quantity.toString();
    final controller = TextEditingController(text: formattedQty);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Số lượng'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            final qty = double.tryParse(value) ?? item.quantity;
            if (qty >= 0) {
              onQuantityChanged(qty);
            }
            Navigator.pop(dialogContext);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final qty = double.tryParse(controller.text) ?? item.quantity;
              if (qty >= 0) {
                onQuantityChanged(qty);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatQuantity(double qty) {
    if (qty == qty.roundToDouble()) {
      return qty.toInt().toString();
    }
    return qty.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final step = AppConstants.getQuantityStep(item.unit);

    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: AppTheme.errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      direction: isMultiSelectMode ? DismissDirection.none : DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (!isMultiSelectMode) {
          onDelete();
        }
        return false;
      },
      child: InkWell(
        onLongPress: onLongPress,
        onTap: isMultiSelectMode ? onTap : onTogglePurchased,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: isSelected ? 4 : 1,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                // Category icon
                if (!isMultiSelectMode) ...[
                  Text(
                    AppConstants.categoryIcons[item.category] ?? '📦',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                ],
                // Checkbox for multi-select mode
                if (isMultiSelectMode)
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onTap(),
                  ),
                // Item name
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null,
                          decoration: item.isPurchased
                              ? TextDecoration.lineThrough
                              : null,
                          decorationThickness: 2,
                        ),
                  ),
                ),
                // Quantity controls
                if (!isMultiSelectMode) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: item.quantity > 0
                          ? AppTheme.primaryColor
                          : Colors.grey[400],
                    ),
                    onPressed: item.quantity > 0
                        ? () {
                            final newQty = item.quantity - step;
                            onQuantityChanged(newQty < 0 ? 0 : newQty);
                          }
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 24,
                  ),
                  GestureDetector(
                    onTap: () => _showQuantityEditDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatQuantity(item.quantity),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => onQuantityChanged(item.quantity + step),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 24,
                  ),
                  const SizedBox(width: 4),
                  // Unit dropdown
                  DropdownButton<String>(
                    value: item.unit,
                    underline: const SizedBox(),
                    isDense: true,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                        ),
                    items: AppConstants.units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onUnitChanged(value);
                      }
                    },
                  ),
                ],
                // Drag handle
                if (!isMultiSelectMode)
                  ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.drag_handle, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
