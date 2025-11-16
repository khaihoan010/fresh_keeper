import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_localizations.dart';
import '../../../config/constants.dart';
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
/// Shows all categories with product counts
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.category),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                final categoryStats = provider.categoryStats;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: AppConstants.categoryIds.length,
                  itemBuilder: (context, index) {
                    final categoryId = AppConstants.categoryIds[index];
                    final categoryName = l10n.isVietnamese
                        ? AppConstants.categoryNamesVi[categoryId] ?? categoryId
                        : AppConstants.categoryNamesEn[categoryId] ?? categoryId;
                    final categoryIcon = AppConstants.categoryIcons[categoryId] ?? '📦';
                    final productCount = categoryStats[categoryId] ?? 0;

                    return _CategoryTile(
                      icon: categoryIcon,
                      name: categoryName,
                      productCount: productCount,
                      onTap: () => _showCategoryProducts(
                        context,
                        categoryId,
                        categoryName,
                        provider,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  void _showCategoryProducts(
    BuildContext context,
    String categoryId,
    String categoryName,
    ProductProvider provider,
  ) {
    final l10n = AppLocalizations.of(context);
    final products = provider.products.where((p) => p.category == categoryId).toList();

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noProductsInCategory),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: product.getStatusColor().withOpacity(0.2),
                        child: Text(
                          AppConstants.categoryIcons[product.category] ?? '📦',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                        '${product.quantity} ${product.unit} - ${product.daysRemainingText}',
                      ),
                      trailing: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: product.getStatusColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Category Tile Widget
class _CategoryTile extends StatelessWidget {
  final String icon;
  final String name;
  final int productCount;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.name,
    required this.productCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(
          icon,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$productCount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
