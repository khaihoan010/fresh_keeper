import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_localizations.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/models/user_product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';

/// Category View for Bottom Navigation
/// Wrapper without Scaffold for use in IndexedStack
class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryScreen();
  }
}

/// Category Screen
/// Shows all products with search and FAB for creating templates
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateTemplateDialog() {
    final l10n = AppLocalizations.of(context);
    final nameViController = TextEditingController();
    final nameEnController = TextEditingController();
    String selectedCategory = 'vegetables';
    final shelfLifeController = TextEditingController(text: '7');

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.createProductTemplate),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameViController,
                  decoration: InputDecoration(
                    labelText: l10n.nameVi,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameEnController,
                  decoration: InputDecoration(
                    labelText: l10n.nameEn,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    border: const OutlineInputBorder(),
                  ),
                  items: AppConstants.categoryIds.map((id) {
                    final name = l10n.isVietnamese
                        ? AppConstants.categoryNamesVi[id] ?? id
                        : AppConstants.categoryNamesEn[id] ?? id;
                    return DropdownMenuItem(
                      value: id,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: shelfLifeController,
                  decoration: InputDecoration(
                    labelText: l10n.shelfLifeDays,
                    border: const OutlineInputBorder(),
                    suffixText: l10n.days,
                  ),
                  keyboardType: TextInputType.number,
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
                if (nameViController.text.trim().isNotEmpty) {
                  // TODO: Save template to database
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.templateCreated),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(l10n.create),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.allProducts),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchProducts,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                var products = provider.products;

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  products = products.where((p) {
                    return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();
                }

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📦', style: TextStyle(fontSize: 80)),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty ? l10n.noProductsFound : l10n.noProducts,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductListTile(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: product,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTemplateDialog,
        tooltip: l10n.createProductTemplate,
        child: const Icon(Icons.add_box_outlined, size: 28),
      ),
    );
  }
}

/// Product List Tile Widget
class _ProductListTile extends StatelessWidget {
  final UserProduct product;
  final VoidCallback onTap;

  const _ProductListTile({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final daysText = product.isExpired
        ? l10n.daysOverdue(-product.daysUntilExpiry)
        : l10n.daysRemaining(product.daysUntilExpiry);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(
          AppConstants.categoryIcons[product.category] ?? '📦',
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.quantity} ${product.unit} • ${product.location ?? 'fridge'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              daysText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: product.getStatusColor(),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: product.getStatusColor(),
            shape: BoxShape.circle,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
