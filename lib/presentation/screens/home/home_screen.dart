import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';

/// Home Screen / All Items
/// Primary screen showing all products with filter, sort, and search
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<UserProduct> _displayedProducts = [];
  bool _isSearching = false;
  int _currentIndex = 0;
  late TabController _tabController;
  String _selectedLocation = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      // Load all products initially (filteredProducts returns empty if no filter/sort)
      _displayedProducts = provider.filteredProducts.isEmpty
          ? provider.products
          : provider.filteredProducts;
      _applyLocationFilter();
      setState(() {}); // Trigger rebuild to show products
    });
  }

  @override
  void dispose() {
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
          _selectedLocation = 'all';
          break;
        case 1:
          _selectedLocation = 'fridge';
          break;
        case 2:
          _selectedLocation = 'freezer';
          break;
        case 3:
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

    if (_selectedLocation == 'all') {
      _displayedProducts = allProducts;
    } else {
      _displayedProducts = allProducts
          .where((p) => p.location?.toLowerCase() == _selectedLocation)
          .toList();
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text('🧊', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortSheet,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchProduct,
                prefixIcon: const Icon(Icons.search),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),

          // Location Tabs
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              tabs: [
                Tab(text: l10n.allLocations),
                Tab(icon: const Icon(Icons.kitchen_outlined), text: l10n.fridge),
                Tab(icon: const Icon(Icons.ac_unit_outlined), text: l10n.freezer),
                Tab(icon: const Icon(Icons.inventory_2_outlined), text: l10n.pantry),
              ],
            ),
          ),

          // Filter/Sort Info
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    if (provider.selectedCategory != 'all') ...[
                      Chip(
                        label: Text(
                          l10n.isVietnamese
                              ? (AppConstants.categories.firstWhere(
                                  (c) => c['id'] == provider.selectedCategory,
                                  orElse: () => {'name_vi': 'Tất cả'},
                                )['name_vi'] as String)
                              : (AppConstants.categories.firstWhere(
                                  (c) => c['id'] == provider.selectedCategory,
                                  orElse: () => {'name_en': 'All'},
                                )['name_en'] as String),
                        ),
                        onDeleted: () {
                          provider.setCategory('all');
                          if (_searchController.text.isEmpty) {
                            setState(() {
                              _displayedProducts = provider.filteredProducts.isEmpty
                                  ? provider.products
                                  : provider.filteredProducts;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      l10n.productsCount(_displayedProducts.length),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      provider.sortBy.getLocalizedName(l10n),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1),

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
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: product,
                          );
                        },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct).then((added) {
            if (added == true) {
              _handleRefresh();
            }
          });
        },
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _navigateToTab(index);
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
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        // Already on home (all items)
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.expiringSoon);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
    }
  }
}

/// Product Card with swipe actions
class _ProductCard extends StatelessWidget {
  final UserProduct product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkUsed;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id),
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
          // Mark as used
          onMarkUsed();
          return false;
        } else {
          // Delete
          onDelete();
          return false;
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Text(
                  AppConstants.categoryIcons[product.category] ?? '📦',
                  style: const TextStyle(fontSize: 40),
                ),

                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.quantity} ${product.unit}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Builder(
                            builder: (context) {
                              final l10n = AppLocalizations.of(context);
                              final daysText = product.isExpired
                                  ? l10n.daysOverdue(-product.daysUntilExpiry)
                                  : l10n.daysRemaining(product.daysUntilExpiry);
                              return Text(
                                daysText,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: product.getStatusColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status indicator
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: product.getStatusColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${product.daysUntilExpiry}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: product.getStatusColor(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // More button
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => _ProductActionsSheet(
                        product: product,
                        onEdit: onEdit,
                        onDelete: onDelete,
                        onMarkUsed: onMarkUsed,
                      ),
                    );
                  },
                ),
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
