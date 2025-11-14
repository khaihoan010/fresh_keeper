import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/shopping_list_item.dart';
import '../../../data/models/user_product.dart';
import '../../providers/shopping_list_provider.dart';
import '../../providers/multi_select_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';
import '../../widgets/multi_select/multi_select_app_bar.dart';
import '../../widgets/shopping_list/shopping_list_bottom_bar.dart';
import '../../widgets/shopping_list/store_items_dialog.dart';

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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addItem),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.enterItemName,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _addItem(value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (_textController.text.trim().isNotEmpty) {
                _addItem(_textController.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  Future<void> _addItem(String name) async {
    final provider = context.read<ShoppingListProvider>();
    final l10n = AppLocalizations.of(context);

    final success = await provider.addItem(name);

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

    // Show dialog to get location and expiry date
    final result = await showDialog<StoreItemsResult>(
      context: context,
      builder: (context) => StoreItemsDialog(
        itemCount: selectedIds.length,
      ),
    );

    if (result == null || !mounted) return;

    // Get selected items
    final selectedItems = shoppingListProvider.items
        .where((item) => selectedIds.contains(item.id.toString()))
        .toList();

    // Create products from shopping list items
    final now = DateTime.now();
    final products = selectedItems.map((item) {
      return UserProduct(
        name: item.name,
        category: 'other',
        quantity: 1,
        unit: 'pcs',
        location: result.location,
        purchaseDate: now,
        expiryDate: result.expiryDate ?? now.add(const Duration(days: 7)),
      );
    }).toList();

    // Add products to inventory
    for (final product in products) {
      await productProvider.addProduct(product);
    }

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
                            isSelected: isSelected,
                            isMultiSelectMode: isMultiSelectMode,
                            onDelete: () => _deleteItem(item),
                            onLongPress: () => _handleLongPress(item.id.toString()),
                            onTap: () => _handleTap(item.id.toString()),
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
                )
              else
                const BannerAdWidget(),
            ],
          ),
          floatingActionButton: isMultiSelectMode
              ? null
              : FloatingActionButton(
                  onPressed: _showAddItemDialog,
                  child: const Icon(Icons.add, size: 32),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}

/// Shopping List Item Tile
class _ShoppingListItemTile extends StatelessWidget {
  final ShoppingListItem item;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  const _ShoppingListItemTile({
    required super.key,
    required this.item,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onDelete,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        onTap: isMultiSelectMode ? onTap : null,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: isSelected ? 4 : 1,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: ListTile(
            leading: isMultiSelectMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (_) => onTap(),
                  )
                : const Icon(Icons.drag_handle, color: Colors.grey),
            title: Text(
              item.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
            ),
            trailing: isMultiSelectMode
                ? null
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    color: Theme.of(context).colorScheme.error,
                  ),
          ),
        ),
      ),
    );
  }
}
