import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';

/// Expiring Soon View for Bottom Navigation
/// Wrapper without Scaffold for use in IndexedStack
class ExpiringSoonView extends StatelessWidget {
  const ExpiringSoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExpiringSoonScreen();
  }
}

/// Expiring Soon Screen
/// Displays products grouped by expiry urgency
class ExpiringSoonScreen extends StatefulWidget {
  const ExpiringSoonScreen({super.key});

  @override
  State<ExpiringSoonScreen> createState() => _ExpiringSoonScreenState();
}

class _ExpiringSoonScreenState extends State<ExpiringSoonScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLocation = 'fridge';
  final _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  List<UserProduct> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadExpiringSoon();
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
          _selectedLocation = 'fridge';
          break;
        case 1:
          _selectedLocation = 'freezer';
          break;
        case 2:
          _selectedLocation = 'pantry';
          break;
      }
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<ProductProvider>().refresh();
    _handleSearch(_searchController.text);
  }

  void _handleSearch(String query) {
    final provider = context.read<ProductProvider>();

    if (query.trim().isEmpty) {
      setState(() {
        _filteredProducts = [];
      });
      return;
    }

    setState(() {
      final searchLower = query.toLowerCase();
      _filteredProducts = provider.expiringSoon
          .where((p) => p.name.toLowerCase().contains(searchLower))
          .toList();
    });
  }

  List<UserProduct> _filterByLocation(List<UserProduct> products) {
    return products
        .where((p) => p.location?.toLowerCase() == _selectedLocation)
        .toList();
  }

  Map<String, List<UserProduct>> _groupProductsByUrgency(
    List<UserProduct> products,
  ) {
    final Map<String, List<UserProduct>> grouped = {
      'expired': [],
      'today': [],
      'urgent': [], // 1-2 days
      'soon': [], // 3-7 days
    };

    // Filter by location first
    final filteredProducts = _filterByLocation(products);

    for (final product in filteredProducts) {
      if (product.isExpired) {
        grouped['expired']!.add(product);
      } else if (product.daysUntilExpiry == 0) {
        grouped['today']!.add(product);
      } else if (product.daysUntilExpiry <= 2) {
        grouped['urgent']!.add(product);
      } else if (product.daysUntilExpiry <= 7) {
        grouped['soon']!.add(product);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchProduct,
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
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
            : Text(l10n.expiringSoon),
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
      body: Column(
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

          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.expiringSoon.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Use filtered products if search is active
                final productsToDisplay = _filteredProducts.isNotEmpty || _searchController.text.isNotEmpty
                    ? _filteredProducts
                    : provider.expiringSoon;

                if (productsToDisplay.isEmpty && _searchController.text.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noProductsFound,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.tryDifferentKeyword,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }

                if (provider.expiringSoon.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: AppTheme.successColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.greatNews,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.successColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noExpiringItems,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final grouped = _groupProductsByUrgency(productsToDisplay);
                final filteredProducts = _filterByLocation(productsToDisplay);

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Expired
                      if (grouped['expired']!.isNotEmpty) ...[
                        _buildSectionHeader(
                          l10n.expiredItems,
                          grouped['expired']!.length,
                          AppTheme.errorColor,
                        ),
                        ...grouped['expired']!.map((product) => _buildProductCard(
                              context,
                              product,
                              AppTheme.errorColor,
                            )),
                        const SizedBox(height: 16),
                      ],

                      // Today
                      if (grouped['today']!.isNotEmpty) ...[
                        _buildSectionHeader(
                          l10n.expiringToday2,
                          grouped['today']!.length,
                          AppTheme.errorColor,
                        ),
                        ...grouped['today']!.map((product) => _buildProductCard(
                              context,
                              product,
                              AppTheme.errorColor,
                            )),
                        const SizedBox(height: 16),
                      ],

                      // Urgent (1-2 days)
                      if (grouped['urgent']!.isNotEmpty) ...[
                        _buildSectionHeader(
                          l10n.urgentDays,
                          grouped['urgent']!.length,
                          AppTheme.errorColor,
                        ),
                        ...grouped['urgent']!.map((product) => _buildProductCard(
                              context,
                              product,
                              AppTheme.errorColor,
                            )),
                        const SizedBox(height: 16),
                      ],

                      // Soon (3-7 days)
                      if (grouped['soon']!.isNotEmpty) ...[
                        _buildSectionHeader(
                          l10n.useSoonDays,
                          grouped['soon']!.length,
                          AppTheme.warningColor,
                        ),
                        ...grouped['soon']!.map((product) => _buildProductCard(
                              context,
                              product,
                              AppTheme.warningColor,
                            )),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    UserProduct product,
    Color accentColor,
  ) {
    return _ExpiringSoonProductCard(
      product: product,
      accentColor: accentColor,
      onRefresh: _handleRefresh,
    );
  }

  Widget _buildDaysBadge(UserProduct product, Color accentColor) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: accentColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.isExpired ? '!' : '${product.daysUntilExpiry}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (!product.isExpired)
              Text(
                l10n.days,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Expiring Soon Product Card with Quantity Controls
class _ExpiringSoonProductCard extends StatefulWidget {
  final UserProduct product;
  final Color accentColor;
  final VoidCallback onRefresh;

  const _ExpiringSoonProductCard({
    required this.product,
    required this.accentColor,
    required this.onRefresh,
  });

  @override
  State<_ExpiringSoonProductCard> createState() => _ExpiringSoonProductCardState();
}

class _ExpiringSoonProductCardState extends State<_ExpiringSoonProductCard> {
  late double _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.product.quantity;
  }

  @override
  void didUpdateWidget(_ExpiringSoonProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync quantity when product data changes from provider
    if (oldWidget.product.id == widget.product.id &&
        oldWidget.product.quantity != widget.product.quantity) {
      _currentQuantity = widget.product.quantity;
    }
  }

  double _getQuantityStep(String unit) {
    switch (unit.toLowerCase()) {
      case 'kg':
      case 'lít':
        return 0.1;
      case 'g':
        return 5.0;
      case 'ml':
        return 10.0;
      case 'cái':
      case 'quả':
      case 'bó':
      case 'gói':
      case 'hộp':
      case 'chai':
      case 'lon':
      case 'túi':
      default:
        return 1.0;
    }
  }

  void _increaseQuantity() async {
    setState(() {
      final step = _getQuantityStep(widget.product.unit);
      _currentQuantity += step;
    });
    await _updateProductQuantity();
  }

  void _decreaseQuantity() async {
    setState(() {
      final step = _getQuantityStep(widget.product.unit);
      if (_currentQuantity > step) {
        _currentQuantity -= step;
      }
    });
    await _updateProductQuantity();
  }

  Future<void> _updateProductQuantity() async {
    final updatedProduct = widget.product.copyWith(quantity: _currentQuantity);
    await context.read<ProductProvider>().updateProduct(updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final daysText = widget.product.isExpired
        ? l10n.daysOverdue(-widget.product.daysUntilExpiry)
        : l10n.daysRemaining(widget.product.daysUntilExpiry);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // Create updated product with current quantity before navigating
          final updatedProduct = widget.product.copyWith(quantity: _currentQuantity);
          Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: updatedProduct,
          ).then((_) {
            // Reload data when returning from details
            widget.onRefresh();
          });
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
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
                        color: widget.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Quantity Controls
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrease button
                    InkWell(
                      onTap: _decreaseQuantity,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Quantity display
                    Text(
                      '${_currentQuantity % 1 == 0 ? _currentQuantity.toInt() : _currentQuantity.toStringAsFixed(1)} ${widget.product.unit}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Increase button
                    InkWell(
                      onTap: _increaseQuantity,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
