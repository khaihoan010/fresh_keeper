import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_localizations.dart';
import '../../config/product_icons.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../data/models/product_icon.dart';
import '../providers/subscription_provider.dart';

/// Icon Picker Dialog
/// Allows users to select custom icons for products
/// Premium icons require subscription
class IconPickerDialog extends StatefulWidget {
  final String? currentIconId;
  final String category;

  const IconPickerDialog({
    super.key,
    this.currentIconId,
    required this.category,
  });

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  IconTier _selectedTier = IconTier.free;
  String? _selectedIconId;

  @override
  void initState() {
    super.initState();
    _selectedIconId = widget.currentIconId;
  }

  List<ProductIcon> _getIconsForTier() {
    if (_selectedTier == IconTier.free) {
      return ProductIcons.getFreeIconsByCategory(widget.category);
    } else {
      return ProductIcons.getPremiumIconsByCategory(widget.category);
    }
  }

  void _onIconTap(ProductIcon icon, bool isPremiumUser) {
    if (icon.tier == IconTier.premium && !isPremiumUser) {
      _showPremiumUpgradeDialog();
    } else {
      setState(() => _selectedIconId = icon.id);
    }
  }

  void _showPremiumUpgradeDialog() {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade400],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.isVietnamese ? 'Nâng cấp Premium' : 'Upgrade to Premium',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.isVietnamese
                            ? 'Mở khóa các tính năng cao cấp:'
                            : 'Unlock premium features:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem('✨', l10n.isVietnamese
                          ? '500+ biểu tượng Premium'
                          : '500+ Premium Icons'),
                      _buildFeatureItem('🎬', l10n.isVietnamese
                          ? 'Biểu tượng động (sắp ra mắt)'
                          : 'Animated Icons (coming soon)'),
                      _buildFeatureItem('🎨', l10n.isVietnamese
                          ? 'Tùy chỉnh biểu tượng cho từng sản phẩm'
                          : 'Custom icon for each product'),
                      _buildFeatureItem('🚫', l10n.isVietnamese
                          ? 'Trải nghiệm không quảng cáo'
                          : 'Ad-Free Experience'),
                      _buildFeatureItem('☁️', l10n.isVietnamese
                          ? 'Sao lưu đám mây (sắp ra mắt)'
                          : 'Cloud Backup (coming soon)'),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.discount, color: Colors.green.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.isVietnamese
                                        ? 'Chỉ 69.000đ/tháng'
                                        : 'Only \$2.99/month',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  Text(
                                    l10n.isVietnamese
                                        ? 'Hoặc 599.000đ/năm (tiết kiệm 30%)'
                                        : 'Or \$19.99/year (save 30%)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.premium);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          l10n.isVietnamese ? 'Nâng cấp ngay' : 'Upgrade Now',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.isVietnamese ? 'Để sau' : 'Maybe Later',
                        style: const TextStyle(fontSize: 14),
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

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscriptionProvider = context.watch<SubscriptionProvider>();
    final isPremiumUser = subscriptionProvider.isPremium;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.isVietnamese ? 'Chọn biểu tượng' : 'Choose Icon',
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
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Tier Tabs (Free / Premium)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTierTab(
                      tier: IconTier.free,
                      label: l10n.isVietnamese ? 'Miễn phí' : 'Free',
                      icon: Icons.check_circle,
                      count: ProductIcons.getFreeIconsByCategory(widget.category).length,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTierTab(
                      tier: IconTier.premium,
                      label: 'Premium',
                      icon: Icons.workspace_premium,
                      count: ProductIcons.getPremiumIconsByCategory(widget.category).length,
                      isPremium: true,
                    ),
                  ),
                ],
              ),
            ),

            // Icon Grid
            Expanded(
              child: _buildIconGrid(isPremiumUser),
            ),

            // Apply Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context, _selectedIconId),
                  child: Text(
                    l10n.isVietnamese ? 'Áp dụng' : 'Apply',
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
    );
  }

  Widget _buildTierTab({
    required IconTier tier,
    required String label,
    required IconData icon,
    required int count,
    bool isPremium = false,
  }) {
    final isSelected = _selectedTier == tier;

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tier),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isPremium ? Colors.amber.shade50 : AppTheme.primaryColor.withOpacity(0.1))
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? (isPremium ? Colors.amber : AppTheme.primaryColor)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (isPremium ? Colors.amber.shade700 : AppTheme.primaryColor)
                  : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? (isPremium ? Colors.amber.shade700 : AppTheme.primaryColor)
                    : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '($count)',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGrid(bool isPremiumUser) {
    final icons = _getIconsForTier();

    if (icons.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).isVietnamese
              ? 'Không có biểu tượng nào'
              : 'No icons available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final icon = icons[index];
        return _buildIconItem(icon, isPremiumUser);
      },
    );
  }

  Widget _buildIconItem(ProductIcon icon, bool isPremiumUser) {
    final isLocked = icon.tier == IconTier.premium && !isPremiumUser;
    final isSelected = _selectedIconId == icon.id;

    return GestureDetector(
      onTap: () => _onIconTap(icon, isPremiumUser),
      child: Stack(
        children: [
          // Icon container
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isLocked ? Colors.grey[100] : Colors.white,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                icon.emoji,
                style: TextStyle(
                  fontSize: 32,
                  color: isLocked ? Colors.grey[400] : null,
                ),
              ),
            ),
          ),

          // Premium badge
          if (icon.tier == IconTier.premium)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.workspace_premium,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),

          // Lock overlay
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

          // Selected indicator
          if (isSelected && !isLocked)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
