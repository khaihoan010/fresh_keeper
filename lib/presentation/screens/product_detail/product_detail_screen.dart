import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
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
    _loadProductTemplate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProductTemplate() async {
    if (_product.productTemplateId != null) {
      final repository = context.read<ProductRepository>();
      final template = await repository.getProductTemplate(_product.productTemplateId!);
      if (mounted) {
        setState(() {
          _productTemplate = template;
        });
      }
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sản phẩm?'),
        content: Text('Bạn có chắc muốn xóa "${_product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Xóa'),
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
            content: Text('✅ Đã xóa ${_product.name}'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    }
  }

  Future<void> _markAsUsed() async {
    final provider = context.read<ProductProvider>();
    final success = await provider.markAsUsed(_product.id);

    if (success && mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Đã đánh dấu "${_product.name}" là đã dùng'),
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
    final categoryData = AppConstants.categories.firstWhere(
      (c) => c['id'] == _product.category,
      orElse: () => {
        'name_vi': 'Khác',
        'icon': '📦',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sản Phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editProduct,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_used',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    SizedBox(width: 12),
                    Text('Đánh dấu đã dùng'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppTheme.errorColor),
                    SizedBox(width: 12),
                    Text(
                      'Xóa sản phẩm',
                      style: TextStyle(color: AppTheme.errorColor),
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
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _product.getStatusColor().withOpacity(0.2),
                  Colors.white,
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
                    color: Colors.white,
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
                  style: AppTheme.h1.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // Category
                Chip(
                  label: Text(
                    categoryData['name_vi'] as String,
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
                            ? 'ĐÃ HẾT HẠN'
                            : '${_product.daysUntilExpiry} NGÀY',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _product.daysRemainingText,
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

          // Tab Bar
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
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Thông Tin'),
                Tab(text: 'Dinh Dưỡng'),
                Tab(text: 'Sức Khỏe'),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildNutritionTab(),
                _buildHealthTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: Information
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin cơ bản', style: AppTheme.h2),
          const SizedBox(height: 16),

          // Quantity
          _buildInfoCard(
            icon: Icons.production_quantity_limits,
            label: 'Số lượng',
            value: '${_product.quantity} ${_product.unit}',
          ),

          // Purchase Date
          _buildInfoCard(
            icon: Icons.shopping_cart_outlined,
            label: 'Ngày mua',
            value: DateFormat(AppConstants.dateFormat).format(_product.purchaseDate),
          ),

          // Expiry Date
          _buildInfoCard(
            icon: Icons.event_busy,
            label: 'Ngày hết hạn',
            value: DateFormat(AppConstants.dateFormat).format(_product.expiryDate),
            valueColor: _product.getStatusColor(),
          ),

          // Storage Location
          if (_product.location != null)
            _buildInfoCard(
              icon: Icons.place_outlined,
              label: 'Vị trí',
              value: _product.location!,
            ),

          // Notes
          if (_product.notes != null) ...[
            const SizedBox(height: 24),
            Text('Ghi chú', style: AppTheme.h2),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.note_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _product.notes!,
                        style: AppTheme.body1,
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
            Text('💡 Mẹo bảo quản', style: AppTheme.h2),
            const SizedBox(height: 12),
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _productTemplate!.storageTips!,
                  style: AppTheme.body1,
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
              label: const Text(
                'Đánh Dấu Đã Dùng',
                style: TextStyle(fontSize: 18),
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
              label: const Text(
                'Xóa Sản Phẩm',
                style: TextStyle(fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: const BorderSide(color: AppTheme.errorColor),
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
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Chưa có thông tin dinh dưỡng',
                style: AppTheme.h2.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Thông tin dinh dưỡng sẽ được cập nhật sau',
                style: AppTheme.body2,
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
            '🍎 Giá Trị Dinh Dưỡng (${nutritionData.servingSize})',
            style: AppTheme.h2,
          ),
          const SizedBox(height: 16),

          // Main Nutrients
          if (nutritionData.calories != null)
            _buildNutrientRow(
              'Calories',
              '${nutritionData.calories!.toStringAsFixed(0)} kcal',
              nutritionData.calories! / 2000,
            ),

          if (nutritionData.protein != null)
            _buildNutrientRow(
              'Protein',
              '${nutritionData.protein!.toStringAsFixed(1)}g',
              nutritionData.protein! / 50,
            ),

          if (nutritionData.carbohydrates != null)
            _buildNutrientRow(
              'Carbohydrates',
              '${nutritionData.carbohydrates!.toStringAsFixed(1)}g',
              nutritionData.carbohydrates! / 300,
            ),

          if (nutritionData.fat != null)
            _buildNutrientRow(
              'Fat',
              '${nutritionData.fat!.toStringAsFixed(1)}g',
              nutritionData.fat! / 70,
            ),

          if (nutritionData.fiber != null)
            _buildNutrientRow(
              'Fiber',
              '${nutritionData.fiber!.toStringAsFixed(1)}g',
              nutritionData.fiber! / 25,
            ),

          if (nutritionData.sugar != null)
            _buildNutrientRow(
              'Sugar',
              '${nutritionData.sugar!.toStringAsFixed(1)}g',
              nutritionData.sugar! / 50,
              isWarning: nutritionData.sugar! > 10,
            ),

          // Vitamins
          if (nutritionData.vitamins != null && nutritionData.vitamins!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Vitamin', style: AppTheme.h3),
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
                            style: AppTheme.body1,
                          ),
                          Text(
                            '${entry.value.toStringAsFixed(1)} ${_getVitaminUnit(entry.key)}',
                            style: AppTheme.body1.copyWith(
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
            Text('Khoáng chất', style: AppTheme.h3),
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
                            style: AppTheme.body1,
                          ),
                          Text(
                            '${entry.value.toStringAsFixed(1)} mg',
                            style: AppTheme.body1.copyWith(
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
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Chưa có thông tin sức khỏe',
                style: AppTheme.h2.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Thông tin sức khỏe sẽ được cập nhật sau',
                style: AppTheme.body2,
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
            Text('✅ Lợi Ích Sức Khỏe', style: AppTheme.h2),
            const SizedBox(height: 12),
            Card(
              color: Colors.green[50],
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
                              style: AppTheme.body1,
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
            Text('⚠️ Lưu Ý', style: AppTheme.h2),
            const SizedBox(height: 12),
            Card(
              color: Colors.orange[50],
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
                              style: AppTheme.body1,
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
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.body2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTheme.h3.copyWith(
                      fontSize: 16,
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
                style: AppTheme.body1.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                value,
                style: AppTheme.body1,
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
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isWarning ? Colors.orange : AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percent%',
                style: AppTheme.body2.copyWith(
                  color: isWarning ? Colors.orange : null,
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
