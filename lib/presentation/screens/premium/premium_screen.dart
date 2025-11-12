import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../../config/app_localizations.dart';
import '../../../config/theme.dart';
import '../../providers/subscription_provider.dart';

/// Premium Subscription Screen
/// Displays premium benefits and purchase options
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          if (subscriptionProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (subscriptionProvider.isPremium) {
            return _buildAlreadyPremiumView(context, l10n);
          }

          return _buildUpgradeView(context, l10n, subscriptionProvider);
        },
      ),
    );
  }

  Widget _buildAlreadyPremiumView(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bạn là thành viên Premium!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Cảm ơn bạn đã ủng hộ Fresh Keeper',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildBenefitsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeView(
    BuildContext context,
    AppLocalizations l10n,
    SubscriptionProvider subscriptionProvider,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fresh Keeper Premium',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Trải nghiệm không giới hạn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Benefits
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lợi ích của Premium:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildBenefitsList(context),
                const SizedBox(height: 32),

                // Plans
                if (subscriptionProvider.products.isNotEmpty) ...[
                  Text(
                    'Chọn gói phù hợp:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...subscriptionProvider.products.map(
                    (product) => _buildProductCard(
                      context,
                      product,
                      subscriptionProvider,
                    ),
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Các gói đăng ký sẽ sớm có mặt trên App Store và Google Play',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Restore purchases button
                TextButton.icon(
                  onPressed: () async {
                    await subscriptionProvider.restorePurchases();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            subscriptionProvider.isPremium
                                ? 'Đã khôi phục gói Premium!'
                                : 'Không tìm thấy gói đăng ký nào',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Khôi phục gói đã mua'),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList(BuildContext context) {
    final benefits = [
      {
        'icon': Icons.block,
        'title': 'Không quảng cáo',
        'subtitle': 'Tắt hoàn toàn banner và popup ads',
      },
      {
        'icon': Icons.cloud_upload,
        'title': 'Sao lưu đám mây',
        'subtitle': 'Đồng bộ dữ liệu qua nhiều thiết bị',
      },
      {
        'icon': Icons.palette,
        'title': 'Themes độc quyền',
        'subtitle': 'Truy cập các giao diện đặc biệt',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Hỗ trợ ưu tiên',
        'subtitle': 'Được hỗ trợ nhanh chóng',
      },
    ];

    return Column(
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  benefit['icon'] as IconData,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit['subtitle'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductDetails product,
    SubscriptionProvider subscriptionProvider,
  ) {
    // Determine if this is the best value plan
    final isYearly = product.id.contains('yearly');
    final isLifetime = product.id.contains('lifetime');
    final isBestValue = isYearly || isLifetime;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isBestValue ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isBestValue
            ? const BorderSide(color: Color(0xFFFFD700), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: subscriptionProvider.isLoading
            ? null
            : () => _handlePurchase(context, product, subscriptionProvider),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title.replaceAll('(Fresh Keeper)', '').trim(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.price,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isBestValue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tốt nhất',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (isYearly) ...[
                const SizedBox(height: 8),
                Text(
                  '🎉 Tiết kiệm 32% so với gói tháng',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePurchase(
    BuildContext context,
    ProductDetails product,
    SubscriptionProvider subscriptionProvider,
  ) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận nâng cấp'),
        content: Text(
          'Bạn có chắc muốn nâng cấp lên Premium với gói ${product.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Purchase
    await subscriptionProvider.purchaseProduct(product);
  }
}
