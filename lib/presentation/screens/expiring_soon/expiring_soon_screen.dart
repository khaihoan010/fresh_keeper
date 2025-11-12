import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';

/// Expiring Soon Screen
/// Displays products grouped by expiry urgency
class ExpiringSoonScreen extends StatefulWidget {
  const ExpiringSoonScreen({super.key});

  @override
  State<ExpiringSoonScreen> createState() => _ExpiringSoonScreenState();
}

class _ExpiringSoonScreenState extends State<ExpiringSoonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadExpiringSoon();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<ProductProvider>().refresh();
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

    for (final product in products) {
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
        title: Text(l10n.expiringSoon),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.expiringSoon.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
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

                final grouped = _groupProductsByUrgency(provider.expiringSoon);

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Summary Card
                      _buildSummaryCard(provider.expiringSoon.length),

                      const SizedBox(height: 24),

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

  Widget _buildSummaryCard(int count) {
    final l10n = AppLocalizations.of(context);

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainerHigh
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warningColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.productsExpiringSoon,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.useSoonToAvoidWaste,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: product,
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Center(
                  child: Text(
                    AppConstants.categoryIcons[product.category] ?? '📦',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),

              const SizedBox(width: 12),

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
                          Icons.event_busy,
                          size: 14,
                          color: accentColor,
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
                                color: accentColor,
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

              // Days badge
              _buildDaysBadge(product, accentColor),

              const SizedBox(width: 4),

              // Arrow
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
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
