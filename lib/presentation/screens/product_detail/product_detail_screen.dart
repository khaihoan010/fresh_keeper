import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../data/models/user_product.dart';
import '../../providers/product_provider.dart';

/// Product Detail Screen
/// Shows detailed product information with actions
class ProductDetailScreen extends StatefulWidget {
  final UserProduct product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late UserProduct _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: 100,
                    height: 100,
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
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    _product.name,
                    style: AppTheme.h1,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Category
                  Chip(
                    label: Text(categoryData['name_vi'] as String),
                  ),

                  const SizedBox(height: 16),

                  // Status Card
                  Container(
                    padding: const EdgeInsets.all(16),
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
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _product.daysRemainingText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thông tin', style: AppTheme.h2),
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

                  const SizedBox(height: 24),

                  // Metadata
                  Text('Metadata', style: AppTheme.h3),
                  const SizedBox(height: 8),
                  Card(
                    color: AppTheme.backgroundLight,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildMetadataRow(
                            'Tạo lúc',
                            DateFormat(AppConstants.dateTimeFormat).format(_product.createdAt),
                          ),
                          const Divider(height: 16),
                          _buildMetadataRow(
                            'Cập nhật',
                            DateFormat(AppConstants.dateTimeFormat).format(_product.updatedAt),
                          ),
                          const Divider(height: 16),
                          _buildMetadataRow(
                            'ID',
                            _product.id,
                          ),
                        ],
                      ),
                    ),
                  ),

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
            ),
          ],
        ),
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

  Widget _buildMetadataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTheme.body2,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.body2.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
