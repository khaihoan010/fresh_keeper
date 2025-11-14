import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../providers/product_provider.dart';

/// Dashboard Screen
/// Shows overview of products and quick stats
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('📊', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              l10n.dashboard,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductProvider>().refresh(),
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.refresh(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Stats Cards
                _buildStatsSection(provider),

                const SizedBox(height: 24),

                // Primary CTA
                _buildAddProductButton(),

                const SizedBox(height: 24),

                // Quick Access
                _buildQuickAccessSection(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsSection(ProductProvider provider) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickStats,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.inventory_2_outlined,
                title: l10n.totalProducts,
                value: provider.totalCount.toString(),
                color: AppTheme.primaryColor,
                onTap: () => Navigator.pushNamed(context, AppRoutes.allItems),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.warning_amber_outlined,
                title: l10n.expiringItems,
                value: provider.expiringSoonCount.toString(),
                color: provider.expiringSoonCount > 0
                    ? AppTheme.errorColor
                    : AppTheme.successColor,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.expiringSoon),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddProductButton() {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        icon: const Icon(Icons.add, size: 28),
        label: Text(l10n.addProduct, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(ProductProvider provider) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentlyAdded,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.allItems);
              },
              child: Text('${l10n.viewAll} →'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.recentProducts.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Text('📦', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noRecentProducts,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...provider.recentProducts.take(5).map((product) {
            final l10n = AppLocalizations.of(context);
            final daysText = product.isExpired
                ? l10n.daysOverdue(-product.daysUntilExpiry)
                : l10n.daysRemaining(product.daysUntilExpiry);

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(
                  AppConstants.categoryIcons[product.category] ?? '📦',
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  '$daysText • ${product.quantity} ${product.unit}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: product.getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: product,
                  );
                },
              ),
            );
          }),
      ],
    );
  }
}
