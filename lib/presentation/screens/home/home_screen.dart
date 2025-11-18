import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../../data/models/product_template.dart';
import '../../providers/product_provider.dart';
import '../../providers/shopping_list_provider.dart';
import '../../providers/multi_select_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';
import '../../widgets/multi_select/multi_select_app_bar.dart';
import '../../widgets/multi_select/multi_select_bottom_bar.dart';
import '../../widgets/multi_select/location_selector_dialog.dart';
import '../expiring_soon/expiring_soon_screen.dart';
import '../settings/settings_screen.dart';
import '../shopping_list/shopping_list_screen.dart';
import '../category/category_screen.dart';

/// Home Screen with Bottom Navigation
/// Container for all main tabs: All Items, Expiring Soon, Shopping List, Settings
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.watch<MultiSelectProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          AllItemsView(),
          ExpiringSoonView(),
          CategoryView(),
          ShoppingListView(),
          SettingsView(),
        ],
      ),
      floatingActionButton: (_currentIndex == 0 && !multiSelectProvider.isMultiSelectMode)
          ? FloatingActionButton(
              heroTag: 'home_fab',
              onPressed: () {
                // Add product for Home tab
                Navigator.pushNamed(context, AppRoutes.addProduct).then((added) {
                  if (added == true) {
                    context.read<ProductProvider>().refresh();
                  }
                });
              },
              child: const Icon(Icons.add, size: 32),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: multiSelectProvider.isMultiSelectMode
          ? null
          : BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.warning_amber_outlined),
                if (context.watch<ProductProvider>().expiringSoonCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${context.watch<ProductProvider>().expiringSoonCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.warning_amber),
            label: l10n.expiringSoon,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            activeIcon: const Icon(Icons.category),
            label: l10n.category,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            activeIcon: const Icon(Icons.shopping_cart),
            label: l10n.shoppingList,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

/// All Items View
/// Shows all products with filter, sort, and search
class AllItemsView extends StatefulWidget {
  const AllItemsView({super.key});

  @override
  State<AllItemsView> createState() => _AllItemsViewState();
}

class _AllItemsViewState extends State<AllItemsView> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final _searchController = TextEditingController();
  List<UserProduct> _displayedProducts = [];
  bool _isSearching = false;
  bool _isSearchExpanded = false;
  late TabController _tabController;
  String _selectedLocation = 'fridge';
  ProductProvider? _provider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Load products from database when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _provider = context.read<ProductProvider>();
      _provider!.addListener(_onProviderChanged);
      await _provider!.loadProducts();

      // Apply location filter after loading
      _applyLocationFilter();
      if (mounted) {
        setState(() {}); // Trigger rebuild to show products
      }
    });
  }

  void _onProviderChanged() {
    if (mounted && _searchController.text.isEmpty) {
      _applyLocationFilter();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onProviderChanged);
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    setState(() {
      switch (_tabController.index) {
        case 0:
          _selectedLocation = 'fridge';
          break;
        case 1:
          _selectedLocation = 'freezer';
          break;
        case 2:
          _selectedLocation = 'pantry';
          break;
      }
      _applyLocationFilter();
    });
  }

  void _applyLocationFilter() {
    final provider = context.read<ProductProvider>();
    final allProducts = provider.filteredProducts.isEmpty
        ? provider.products
        : provider.filteredProducts;

    _displayedProducts = allProducts
        .where((p) => p.location?.toLowerCase() == _selectedLocation)
        .toList();
  }

  Future<void> _handleSearch(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _isSearching = false;
        _applyLocationFilter();
      });
      return;
    }

    setState(() => _isSearching = true);

    final provider = context.read<ProductProvider>();
    final results = await provider.searchProducts(query);

    setState(() {
      // Apply location filter to search results
      if (_selectedLocation == 'all') {
        _displayedProducts = results;
      } else {
        _displayedProducts = results
            .where((p) => p.location?.toLowerCase() == _selectedLocation)
            .toList();
      }
      _isSearching = false;
    });
  }

  Future<void> _handleRefresh() async {
    final provider = context.read<ProductProvider>();
    await provider.refresh();
    setState(() {
      _applyLocationFilter();
      _searchController.clear();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => const _FilterSheet(),
    ).then((_) {
      // Update displayed products after filter changes
      if (_searchController.text.isEmpty) {
        setState(() {
          _applyLocationFilter();
        });
      }
    });
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => const _SortSheet(),
    ).then((_) {
      // Update displayed products after sort changes
      if (_searchController.text.isEmpty) {
        setState(() {
          _applyLocationFilter();
        });
      }
    });
  }

  Future<void> _deleteProduct(UserProduct product) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteProduct(product.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = context.read<ProductProvider>();
      final success = await provider.deleteProduct(product.id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productDeleted(product.name)),
            backgroundColor: AppTheme.successColor,
          ),
        );
        setState(() {
          _applyLocationFilter();
        });
      }
    }
  }

  Future<void> _markAsUsed(UserProduct product) async {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<ProductProvider>();
    final success = await provider.markAsUsed(product.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.productMarkedAsUsed(product.name)),
          backgroundColor: AppTheme.successColor,
        ),
      );
      setState(() {
        _applyLocationFilter();
      });
    }
  }

  Future<void> _handleBulkDelete() async {
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.read<MultiSelectProvider>();
    final selectedCount = multiSelectProvider.selectedCount;

    if (selectedCount == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteMultiple(selectedCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final productProvider = context.read<ProductProvider>();
      final selectedIds = multiSelectProvider.selectedProductIds.toList();

      int successCount = 0;
      for (final id in selectedIds) {
        final success = await productProvider.deleteProduct(id);
        if (success) successCount++;
      }

      if (mounted) {
        multiSelectProvider.exitMultiSelectMode();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productsDeleted(successCount)),
            backgroundColor: AppTheme.successColor,
          ),
        );

        setState(() {
          _applyLocationFilter();
        });
      }
    }
  }

  Future<void> _handleBulkMove() async {
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.read<MultiSelectProvider>();
    final productProvider = context.read<ProductProvider>();
    final shoppingListProvider = context.read<ShoppingListProvider>();

    if (multiSelectProvider.selectedCount == 0) return;

    // Get selected products
    final selectedProducts = multiSelectProvider.getSelectedProducts(_displayedProducts);
    if (selectedProducts.isEmpty) return;

    // Determine which locations to exclude (locations where all selected products are from)
    final Set<String> currentLocations = selectedProducts
        .map((p) => p.location?.toLowerCase() ?? '')
        .where((loc) => loc.isNotEmpty)
        .toSet();

    // Show location selector (exclude current if all products are from same location)
    final destination = await showDialog<String>(
      context: context,
      builder: (context) => LocationSelectorDialog(
        title: l10n.moveToLocation,
        excludeLocations: currentLocations.length == 1 ? currentLocations : {},
      ),
    );

    if (destination == null || !mounted) return;

    // Handle move
    if (destination == 'shopping_list') {
      // Add products to shopping list with nutrition data preserved
      int addedCount = 0;
      for (final product in selectedProducts) {
        // Look up template if product has templateId
        ProductTemplate? template;
        if (product.productTemplateId != null) {
          template = await productProvider.getProductTemplate(product.productTemplateId!);
        }

        // Add to shopping list with nutrition data
        final success = await shoppingListProvider.addItemFromUserProduct(product, template);
        if (success) addedCount++;
      }

      // Delete original products from inventory
      for (final product in selectedProducts) {
        await productProvider.deleteProduct(product.id);
      }

      if (mounted) {
        multiSelectProvider.exitMultiSelectMode();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productsMovedToShoppingList(addedCount)),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 4),
          ),
        );

        setState(() {
          _applyLocationFilter();
        });
      }
    } else {
      // Move products to selected location
      int movedCount = 0;
      for (final product in selectedProducts) {
        final updatedProduct = product.copyWith(location: destination);
        final success = await productProvider.updateProduct(updatedProduct);
        if (success) movedCount++;
      }

      if (mounted) {
        multiSelectProvider.exitMultiSelectMode();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productsMoved(movedCount, _getLocationName(l10n, destination))),
            backgroundColor: AppTheme.successColor,
          ),
        );

        setState(() {
          _applyLocationFilter();
        });
      }
    }
  }

  String _getLocationName(AppLocalizations l10n, String location) {
    switch (location) {
      case 'fridge':
        return l10n.fridge;
      case 'freezer':
        return l10n.freezer;
      case 'pantry':
        return l10n.pantry;
      default:
        return location;
    }
  }

  Future<void> _handleBulkCopy() async {
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.read<MultiSelectProvider>();
    final productProvider = context.read<ProductProvider>();
    final shoppingListProvider = context.read<ShoppingListProvider>();

    if (multiSelectProvider.selectedCount == 0) return;

    // Get selected products
    final selectedProducts = multiSelectProvider.getSelectedProducts(_displayedProducts);
    if (selectedProducts.isEmpty) return;

    // Show location selector (no exclusions for copy)
    final destination = await showDialog<String>(
      context: context,
      builder: (context) => LocationSelectorDialog(
        title: l10n.copyToLocation,
        excludeLocations: {},
      ),
    );

    if (destination == null || !mounted) return;

    // Handle copy
    if (destination == 'shopping_list') {
      // Add products to shopping list with nutrition data preserved
      int addedCount = 0;
      for (final product in selectedProducts) {
        // Look up template if product has templateId
        ProductTemplate? template;
        if (product.productTemplateId != null) {
          template = await productProvider.getProductTemplate(product.productTemplateId!);
        }

        // Add to shopping list with nutrition data
        final success = await shoppingListProvider.addItemFromUserProduct(product, template);
        if (success) addedCount++;
      }

      if (mounted) {
        multiSelectProvider.exitMultiSelectMode();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productsAddedToShoppingList(addedCount)),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } else {
      // Copy products to selected location (keep original)
      int copiedCount = 0;
      for (final product in selectedProducts) {
        // Create new product (duplicate) - keep original expiry date
        // User can edit the expiry date manually if needed
        final copiedProduct = UserProduct(
          name: product.name,
          category: product.category,
          quantity: product.quantity,
          unit: product.unit,
          location: destination,
          purchaseDate: product.purchaseDate,
          expiryDate: product.expiryDate, // Keep original expiry date
          notes: product.notes,
          templateId: product.productTemplateId,
        );
        final success = await productProvider.addProduct(copiedProduct);
        if (success) copiedCount++;
      }

      if (mounted) {
        multiSelectProvider.exitMultiSelectMode();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productsCopied(copiedCount, _getLocationName(l10n, destination))),
            backgroundColor: AppTheme.successColor,
          ),
        );

        setState(() {
          _applyLocationFilter();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final l10n = AppLocalizations.of(context);
    final multiSelectProvider = context.watch<MultiSelectProvider>();

    return Scaffold(
      appBar: multiSelectProvider.isMultiSelectMode
          ? MultiSelectAppBar(
              selectedCount: multiSelectProvider.selectedCount,
              onExit: () {
                multiSelectProvider.exitMultiSelectMode();
              },
            )
          : AppBar(
        automaticallyImplyLeading: false,
        title: _isSearchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchProduct,
                  border: InputBorder.none,
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _handleSearch('');
                              },
                            )
                          : null,
                ),
                onChanged: _handleSearch,
              )
            : Row(
                children: [
                  const Text('🧊', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
        actions: _isSearchExpanded
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = false;
                      _searchController.clear();
                      _handleSearch('');
                    });
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = true;
                    });
                  },
                ),
              ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Location Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(icon: const Icon(Icons.kitchen_outlined), text: l10n.fridge),
                Tab(icon: const Icon(Icons.ac_unit_outlined), text: l10n.freezer),
                Tab(icon: const Icon(Icons.inventory_2_outlined), text: l10n.pantry),
              ],
            ),
          ),

          // Filter/Sort Toolbar
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Filter Button
                      OutlinedButton.icon(
                        onPressed: _showFilterSheet,
                        icon: const Icon(Icons.filter_list, size: 18),
                        label: Text(
                          provider.selectedCategory == 'all'
                              ? l10n.all
                              : (l10n.isVietnamese
                                  ? (AppConstants.categories.firstWhere(
                                      (c) => c['id'] == provider.selectedCategory,
                                      orElse: () => {'name_vi': 'Tất cả'},
                                    )['name_vi'] as String)
                                  : (AppConstants.categories.firstWhere(
                                      (c) => c['id'] == provider.selectedCategory,
                                      orElse: () => {'name_en': 'All'},
                                    )['name_en'] as String)),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Sort Button
                      OutlinedButton.icon(
                        onPressed: _showSortSheet,
                        icon: const Icon(Icons.sort, size: 18),
                        label: Text(provider.sortBy.getLocalizedName(l10n)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Product Count
                      Text(
                        l10n.productsCount(_displayedProducts.length),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Products List
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && _displayedProducts.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_displayedProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📦', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? l10n.noProductsFound
                              : l10n.noProducts,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchController.text.isNotEmpty
                              ? l10n.tryDifferentKeyword
                              : l10n.addFirstProduct,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = _displayedProducts[index];
                      return _ProductCard(
                        product: product,
                        onTap: _handleRefresh,
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.editProduct,
                            arguments: product,
                          ).then((edited) {
                            if (edited == true) {
                              _handleRefresh();
                            }
                          });
                        },
                        onDelete: () => _deleteProduct(product),
                        onMarkUsed: () => _markAsUsed(product),
                        isMultiSelectMode: multiSelectProvider.isMultiSelectMode,
                        isSelected: multiSelectProvider.isSelected(product.id),
                        onLongPress: () {
                          multiSelectProvider.enterMultiSelectMode(product.id);
                        },
                        onSelectToggle: () {
                          multiSelectProvider.toggleSelection(product.id);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const BannerAdWidget(),
            ],
          ),
          // Multi-Select Bottom Bar
          if (multiSelectProvider.isMultiSelectMode)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MultiSelectBottomBar(
                onMove: _handleBulkMove,
                onCopy: _handleBulkCopy,
                onDelete: _handleBulkDelete,
              ),
            ),
        ],
      ),
    );
  }
}

/// Product Card with swipe actions
class _ProductCard extends StatefulWidget {
  final UserProduct product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkUsed;
  final bool isMultiSelectMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onSelectToggle;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkUsed,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onSelectToggle,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  late double _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.product.quantity;
  }

  @override
  void didUpdateWidget(_ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync quantity when product data changes from provider
    if (oldWidget.product.id == widget.product.id &&
        oldWidget.product.quantity != widget.product.quantity) {
      _currentQuantity = widget.product.quantity;
    }
  }

  double _getQuantityStep(String unit) {
    return AppConstants.getQuantityStep(unit);
  }

  void _increaseQuantity() async {
    setState(() {
      final step = _getQuantityStep(widget.product.unit);
      _currentQuantity += step;
      // Round to avoid floating point precision issues
      _currentQuantity = double.parse(_currentQuantity.toStringAsFixed(2));
    });
    await _updateProductQuantity();
  }

  void _decreaseQuantity() async {
    setState(() {
      final step = _getQuantityStep(widget.product.unit);
      if (_currentQuantity > 0) {
        final newQty = _currentQuantity - step;
        _currentQuantity = newQty < 0 ? 0 : newQty;
        // Round to avoid floating point precision issues
        _currentQuantity = double.parse(_currentQuantity.toStringAsFixed(2));
      }
    });
    await _updateProductQuantity();
  }

  Future<void> _updateProductQuantity() async {
    final updatedProduct = widget.product.copyWith(quantity: _currentQuantity);
    await context.read<ProductProvider>().updateProduct(updatedProduct);
  }

  Future<void> _updateProductUnit(String newUnit) async {
    final updatedProduct = widget.product.copyWith(unit: newUnit);
    await context.read<ProductProvider>().updateProduct(updatedProduct);
  }

  void _showQuantityEditDialog() {
    final l10n = AppLocalizations.of(context);
    final formattedQty = _currentQuantity == _currentQuantity.roundToDouble()
        ? _currentQuantity.toInt().toString()
        : _currentQuantity.toString();
    final controller = TextEditingController(text: formattedQty);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: const BoxConstraints(maxHeight: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.isVietnamese ? 'Chỉnh sửa số lượng' : 'Edit Quantity',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: l10n.isVietnamese ? 'Số lượng' : 'Quantity',
                      labelStyle: const TextStyle(fontSize: 13),
                      hintText: '1',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.numbers, size: 20),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      final qty = double.tryParse(value) ?? _currentQuantity;
                      if (qty >= 0) {
                        setState(() {
                          _currentQuantity = qty;
                        });
                        _updateProductQuantity();
                      }
                      Navigator.pop(dialogContext);
                    },
                  ),
                ),
              ),

              // Save button (full-width at bottom)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      final qty = double.tryParse(controller.text) ?? _currentQuantity;
                      if (qty >= 0) {
                        setState(() {
                          _currentQuantity = qty;
                        });
                        _updateProductQuantity();
                      }
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      l10n.isVietnamese ? 'Lưu' : 'Save',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
    final l10n = AppLocalizations.of(context);
    final daysText = widget.product.isExpired
        ? l10n.daysOverdue(-widget.product.daysUntilExpiry)
        : l10n.daysRemaining(widget.product.daysUntilExpiry);

    return Dismissible(
      key: Key(widget.product.id),
      direction: widget.isMultiSelectMode ? DismissDirection.none : DismissDirection.horizontal,
      background: Container(
        color: AppTheme.primaryColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.check, color: Colors.white, size: 32),
      ),
      secondaryBackground: Container(
        color: AppTheme.errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onMarkUsed();
          return false;
        } else {
          widget.onDelete();
          return false;
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () {
            if (widget.isMultiSelectMode) {
              widget.onSelectToggle();
            } else {
              // Create updated product with current quantity before navigating
              final updatedProduct = widget.product.copyWith(quantity: _currentQuantity);
              Navigator.pushNamed(
                context,
                AppRoutes.productDetail,
                arguments: updatedProduct,
              ).then((_) {
                // Reload data when returning from details
                widget.onTap();
              });
            }
          },
          onLongPress: widget.isMultiSelectMode ? null : widget.onLongPress,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Checkbox for multi-select mode
                if (widget.isMultiSelectMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      widget.isSelected
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: widget.isSelected
                          ? AppTheme.primaryColor
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                      size: 24,
                    ),
                  ),

                // Icon
                Text(
                  AppConstants.categoryIcons[widget.product.category] ?? '📦',
                  style: const TextStyle(fontSize: 36),
                ),

                const SizedBox(width: 12),

                // Info (Name + Days)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        daysText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: widget.product.getStatusColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity Controls (hidden in multi-select mode)
                if (!widget.isMultiSelectMode) ...[
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decrease button
                      IconButton(
                        onPressed: _decreaseQuantity,
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: AppTheme.primaryColor,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                      ),

                      const SizedBox(width: 4),

                      // Quantity display (tappable)
                      GestureDetector(
                        onTap: _showQuantityEditDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatQuantity(_currentQuantity),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      // Increase button
                      IconButton(
                        onPressed: _increaseQuantity,
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: AppTheme.primaryColor,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                      ),

                      const SizedBox(width: 4),

                      // Unit dropdown
                      DropdownButton<String>(
                        value: widget.product.unit,
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
                            _updateProductUnit(value);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter Bottom Sheet
class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.filterByCategory, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // All categories
                  FilterChip(
                    label: Text(l10n.all),
                    selected: provider.selectedCategory == 'all',
                    onSelected: (_) {
                      provider.setCategory('all');
                      Navigator.pop(context);
                    },
                  ),
                  // Individual categories
                  ...AppConstants.categories.map((category) {
                    final id = category['id'] as String;
                    final name = l10n.isVietnamese
                        ? (category['name_vi'] as String)
                        : (category['name_en'] as String);
                    final icon = category['icon'] as String;
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(name),
                        ],
                      ),
                      selected: provider.selectedCategory == id,
                      onSelected: (_) {
                        provider.setCategory(id);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

/// Sort Bottom Sheet
class _SortSheet extends StatelessWidget {
  const _SortSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.sortBy, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ...SortOption.values.map((option) {
                return RadioListTile<SortOption>(
                  title: Text(option.getLocalizedName(l10n)),
                  value: option,
                  groupValue: provider.sortBy,
                  onChanged: (value) {
                    if (value != null) {
                      provider.setSortOption(value);
                      Navigator.pop(context);
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

/// Product Actions Bottom Sheet
class _ProductActionsSheet extends StatelessWidget {
  final UserProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkUsed;

  const _ProductActionsSheet({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkUsed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.edit),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(l10n.markAsUsed),
            onTap: () {
              Navigator.pop(context);
              onMarkUsed();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
            title: Text(l10n.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
