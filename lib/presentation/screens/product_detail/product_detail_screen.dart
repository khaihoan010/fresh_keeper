import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../../data/models/product_template.dart';
import '../../../data/models/nutrition_data.dart';
import '../../providers/product_provider.dart';
import '../../../data/repositories/product_repository.dart';

/// Product Detail Screen
/// Shows detailed product information with tabs for nutrition and health info
class ProductDetailScreen extends StatefulWidget {
  final UserProduct product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late UserProduct _product;
  late TabController _tabController;
  ProductTemplate? _productTemplate;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _tabController = TabController(length: 3, vsync: this);

    // Load template after first frame is rendered and Provider tree is ready
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && _product.productTemplateId != null) {
        _loadProductTemplate();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProductTemplate() async {
    if (_product.productTemplateId != null) {
      debugPrint('🔍 Loading template for ID: ${_product.productTemplateId}');
      final repository = context.read<ProductRepository>();
      final template = await repository.getProductTemplate(_product.productTemplateId!);

      if (template != null) {
        debugPrint('✅ Template loaded: ${template.nameVi}');
        debugPrint('📊 Has nutrition data: ${template.nutritionData != null}');
        if (template.nutritionData != null) {
          debugPrint('📊 Nutrition hasData: ${template.nutritionData!.hasData}');
          debugPrint('📊 Nutrition details: ${template.nutritionData}');
        } else {
          debugPrint('⚠️ Nutrition data is NULL');
        }
      } else {
        debugPrint('❌ Template not found for ID: ${_product.productTemplateId}');
      }

      if (mounted) {
        setState(() {
          _productTemplate = template;
        });
      }
    } else {
      debugPrint('⚠️ Product has no templateId');
    }
  }

  Future<void> _deleteProduct() async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteProduct(_product.name)),
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
      final success = await provider.deleteProduct(_product.id);

      if (success && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productDeleted(_product.name)),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    }
  }

  Future<void> _markAsUsed() async {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<ProductProvider>();
    final success = await provider.markAsUsed(_product.id);

    if (success && mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.productMarkedAsUsed(_product.name)),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _editProduct() {
    Navigator.pushNamed(
      context,
      AppRoutes.editProduct,
      arguments: _product,
    ).then((edited) {
      if (edited == true && mounted) {
        // Reload product
        final provider = context.read<ProductProvider>();
        final updated = provider.getProductById(_product.id);
        if (updated != null) {
          setState(() => _product = updated);
          _loadProductTemplate();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoryData = AppConstants.categories.firstWhere(
      (c) => c['id'] == _product.category,
      orElse: () => {
        'name_vi': 'Khác',
        'icon': '📦',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editProduct,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_used',
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline),
                    const SizedBox(width: 12),
                    Text(l10n.markUsed),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.deleteProduct,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'mark_used') {
                _markAsUsed();
              } else if (value == 'delete') {
                _deleteProduct();
              }
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header Card as Sliver
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _product.getStatusColor().withOpacity(0.2),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          categoryData['icon'] as String,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      _product.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    // Category
                    Chip(
                      label: Text(
                        categoryData[l10n.isVietnamese ? 'name_vi' : 'name_en'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),

                    const SizedBox(height: 12),

                    // Status Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _product.getStatusColor(),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _product.isExpired
                                ? l10n.expired.toUpperCase()
                                : '${_product.daysUntilExpiry} ${l10n.days.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _product.isExpired
                                ? l10n.daysOverdue(-_product.daysUntilExpiry)
                                : l10n.daysRemaining(_product.daysUntilExpiry),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar as Pinned Sliver
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: [
                    Tab(text: l10n.information),
                    Tab(text: l10n.nutrition),
                    Tab(text: l10n.health),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(),
            _buildNutritionTab(),
            _buildHealthTab(),
          ],
        ),
      ),
    );
  }

  // Tab 1: Information
  Widget _buildInfoTab() {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.basicInfo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Quantity
          _buildInfoCard(
            icon: Icons.production_quantity_limits,
            label: l10n.quantity,
            value: '${_product.quantity} ${_product.unit}',
          ),

          // Purchase Date
          _buildInfoCard(
            icon: Icons.shopping_cart_outlined,
            label: l10n.purchaseDate,
            value: DateFormat(AppConstants.dateFormat).format(_product.purchaseDate),
          ),

          // Expiry Date
          _buildInfoCard(
            icon: Icons.event_busy,
            label: l10n.expiryDate,
            value: DateFormat(AppConstants.dateFormat).format(_product.expiryDate),
            valueColor: _product.getStatusColor(),
          ),

          // Storage Location
          if (_product.location != null)
            _buildInfoCard(
              icon: Icons.place_outlined,
              label: l10n.location,
              value: _product.location!,
            ),

          // Notes
          if (_product.notes != null) ...[
            const SizedBox(height: 24),
            Text(
              l10n.notes,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.note_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _product.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Storage Tips
          if (_productTemplate?.storageTips != null) ...[
            const SizedBox(height: 24),
            Text(
              l10n.storageTips,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                  : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _productTemplate!.storageTips!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Actions
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _markAsUsed,
              icon: const Icon(Icons.check, size: 24),
              label: Text(
                l10n.markAsUsed,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _deleteProduct,
              icon: const Icon(Icons.delete_outline, size: 24),
              label: Text(
                l10n.deleteProduct,
                style: const TextStyle(fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Tab 2: Nutrition
  Widget _buildNutritionTab() {
    final l10n = AppLocalizations.of(context);
    final nutritionData = _productTemplate?.nutritionData;

    if (nutritionData == null || !nutritionData.hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noNutritionData,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.noNutritionInfoYet,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🍎 ${l10n.nutritionValue} (${nutritionData.servingSize ?? l10n.servingSize})',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Main Nutrients
          if (nutritionData.calories != null)
            _buildNutrientRow(
              l10n.calories,
              '${nutritionData.calories!.toStringAsFixed(0)} kcal',
              nutritionData.calories! / 2000,
            ),

          if (nutritionData.protein != null)
            _buildNutrientRow(
              l10n.protein,
              '${nutritionData.protein!.toStringAsFixed(1)}g',
              nutritionData.protein! / 50,
            ),

          if (nutritionData.carbohydrates != null)
            _buildNutrientRow(
              l10n.carbohydrates,
              '${nutritionData.carbohydrates!.toStringAsFixed(1)}g',
              nutritionData.carbohydrates! / 300,
            ),

          if (nutritionData.fat != null)
            _buildNutrientRow(
              l10n.fat,
              '${nutritionData.fat!.toStringAsFixed(1)}g',
              nutritionData.fat! / 70,
            ),

          if (nutritionData.fiber != null)
            _buildNutrientRow(
              l10n.fiber,
              '${nutritionData.fiber!.toStringAsFixed(1)}g',
              nutritionData.fiber! / 25,
            ),

          if (nutritionData.sugar != null)
            _buildNutrientRow(
              l10n.sugar,
              '${nutritionData.sugar!.toStringAsFixed(1)}g',
              nutritionData.sugar! / 50,
              isWarning: nutritionData.sugar! > 10,
            ),

          // Vitamins
          if (nutritionData.vitamins != null && nutritionData.vitamins!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.vitamins,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: nutritionData.vitamins!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatNutrientName(entry.key),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${entry.value.toStringAsFixed(1)} ${_getVitaminUnit(entry.key)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],

          // Minerals
          if (nutritionData.minerals != null && nutritionData.minerals!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.minerals,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: nutritionData.minerals!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatNutrientName(entry.key),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${entry.value.toStringAsFixed(1)} mg',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Tab 3: Health Info
  Widget _buildHealthTab() {
    final l10n = AppLocalizations.of(context);
    final hasHealthBenefits = _productTemplate?.healthBenefits != null &&
        _productTemplate!.healthBenefits!.isNotEmpty;
    final hasHealthWarnings = _productTemplate?.healthWarnings != null &&
        _productTemplate!.healthWarnings!.isNotEmpty;

    if (!hasHealthBenefits && !hasHealthWarnings) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noHealthData,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.noNutritionInfoYet,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Benefits
          if (hasHealthBenefits) ...[
            Text(
              l10n.healthBenefits,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                  : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _productTemplate!.healthBenefits!.map((benefit) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              benefit,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],

          // Health Warnings
          if (hasHealthWarnings) ...[
            const SizedBox(height: 24),
            Text(
              l10n.healthWarnings,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
                  : Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _productTemplate!.healthWarnings!.map((warning) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              warning,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(
    String name,
    String value,
    double percentage, {
    bool isWarning = false,
  }) {
    final percent = (percentage * 100).clamp(0, 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage.clamp(0, 1),
                    minHeight: 8,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isWarning
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isWarning ? Theme.of(context).colorScheme.error : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNutrientName(String key) {
    final map = {
      'vitamin_a': 'Vitamin A',
      'vitamin_c': 'Vitamin C',
      'vitamin_d': 'Vitamin D',
      'vitamin_e': 'Vitamin E',
      'vitamin_k': 'Vitamin K',
      'vitamin_b6': 'Vitamin B6',
      'vitamin_b12': 'Vitamin B12',
      'thiamin': 'Thiamin (B1)',
      'niacin': 'Niacin (B3)',
      'folate': 'Folate',
      'calcium': 'Canxi',
      'iron': 'Sắt',
      'potassium': 'Kali',
      'sodium': 'Natri',
      'magnesium': 'Magie',
      'zinc': 'Kẽm',
      'selenium': 'Selen',
      'phosphorus': 'Phốt pho',
      'manganese': 'Mangan',
    };
    return map[key] ?? key;
  }

  String _getVitaminUnit(String key) {
    if (key.contains('vitamin_a')) return 'IU';
    return 'mg';
  }
}

/// Delegate for sticky TabBar in NestedScrollView
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
