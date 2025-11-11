import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../data/models/user_product.dart';
import '../../../data/models/product_template.dart';
import '../../providers/product_provider.dart';
import '../../../services/nutrition_api_service.dart';
import '../../../data/repositories/product_repository.dart';

/// Add Product Screen
/// Form to add new products with smart search
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _searchController = TextEditingController();
  final _nutritionApiService = NutritionApiService();

  String _selectedCategory = 'vegetables';
  String _selectedUnit = 'kg';
  DateTime _purchaseDate = DateTime.now();
  DateTime? _expiryDate;
  List<ProductTemplate> _searchResults = [];
  bool _isSearching = false;
  bool _isSearchingApi = false;
  ProductTemplate? _selectedTemplate;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(String query) async {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _isSearchingApi = false;
      });
      return;
    }

    // Step 1: Search local database first
    setState(() {
      _isSearching = true;
      _isSearchingApi = false;
    });

    final provider = context.read<ProductProvider>();
    List<ProductTemplate> localResults = await provider.searchTemplates(query);

    setState(() {
      _searchResults = localResults;
      _isSearching = false;
    });

    // Step 2: If local results < 3, search API for more
    if (localResults.length < 3) {
      setState(() => _isSearchingApi = true);

      try {
        final apiResults = await _nutritionApiService.searchProducts(query);

        if (mounted && apiResults.isNotEmpty) {
          // Merge results and remove duplicates
          final allResults = [...localResults];
          for (final apiResult in apiResults) {
            // Check if already exists in local results
            final exists = allResults.any((local) =>
              local.nameVi.toLowerCase() == apiResult.nameVi.toLowerCase() ||
              local.nameEn.toLowerCase() == apiResult.nameEn.toLowerCase()
            );
            if (!exists) {
              allResults.add(apiResult);
            }
          }

          // Note: API results are not cached to database
          // They are used temporarily for this session only
          // The local database already has 110 comprehensive items

          setState(() {
            _searchResults = allResults;
          });
        }
      } catch (e) {
        debugPrint('⚠️ API search error: $e');
        // Continue with local results only
      } finally {
        if (mounted) {
          setState(() => _isSearchingApi = false);
        }
      }
    }
  }

  void _selectTemplate(ProductTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _nameController.text = template.nameVi;
      _selectedCategory = template.category;
      _searchResults = [];
      _searchController.clear();

      // Auto-calculate expiry date
      if (template.shelfLifeDays != null) {
        _expiryDate = _purchaseDate.add(Duration(days: template.shelfLifeDays!));
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isPurchaseDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPurchaseDate ? _purchaseDate : (_expiryDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPurchaseDate) {
          _purchaseDate = picked;
          // Recalculate expiry if template is selected
          if (_selectedTemplate?.shelfLifeDays != null) {
            _expiryDate = _purchaseDate.add(
              Duration(days: _selectedTemplate!.shelfLifeDays!),
            );
          }
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngày hết hạn'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final product = UserProduct(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      nameEn: _selectedTemplate?.nameEn,
      category: _selectedCategory,
      quantity: double.parse(_quantityController.text),
      unit: _selectedUnit,
      purchaseDate: _purchaseDate,
      expiryDate: _expiryDate!,
      status: ProductStatus.active,
      templateId: _selectedTemplate?.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final provider = context.read<ProductProvider>();
    final success = await provider.addProduct(product);

    // Hide loading
    if (mounted) Navigator.of(context).pop();

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Đã thêm ${product.name}'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Không thể thêm sản phẩm'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sản Phẩm'),
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: const Text(
              'Lưu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Smart Search
            _buildSearchSection(),

            const SizedBox(height: 24),

            // Product Name
            _buildTextField(
              controller: _nameController,
              label: 'Tên sản phẩm *',
              hint: 'Ví dụ: Cà chua',
              icon: Icons.shopping_basket_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên sản phẩm';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category
            _buildCategorySelector(),

            const SizedBox(height: 16),

            // Quantity and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _quantityController,
                    label: 'Số lượng *',
                    hint: '1',
                    icon: Icons.production_quantity_limits,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nhập số lượng';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Số không hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildUnitSelector(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Purchase Date
            _buildDateField(
              label: 'Ngày mua',
              date: _purchaseDate,
              onTap: () => _selectDate(context, true),
            ),

            const SizedBox(height: 16),

            // Expiry Date
            _buildDateField(
              label: 'Ngày hết hạn *',
              date: _expiryDate,
              onTap: () => _selectDate(context, false),
              isRequired: true,
            ),

            const SizedBox(height: 24),

            // Info card
            if (_selectedTemplate != null) _buildTemplateInfo(),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.check, size: 24),
                label: const Text(
                  'Thêm Sản Phẩm',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tìm kiếm nhanh',
              style: AppTheme.h3,
            ),
            const SizedBox(width: 8),
            if (_isSearchingApi)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Searching online...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm sản phẩm... (local + online)',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
          onChanged: _searchProducts,
        ),
        if (_searchResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final template = _searchResults[index];
                final isFromApi = template.id.startsWith('api_');

                return ListTile(
                  leading: Text(
                    AppConstants.categoryIcons[template.category] ?? '📦',
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(template.nameVi)),
                      if (isFromApi)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Text(
                            'ONLINE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    '${template.nameEn} • ${template.shelfLifeDays} ngày',
                    style: AppTheme.body2,
                  ),
                  trailing: template.hasNutrition
                      ? Icon(Icons.restaurant, size: 16, color: Colors.orange[700])
                      : null,
                  onTap: () => _selectTemplate(template),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Danh mục',
        prefixIcon: const Icon(Icons.category_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      items: AppConstants.categories.map((category) {
        return DropdownMenuItem(
          value: category['id'],
          child: Row(
            children: [
              Text(
                category['icon'] as String,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Text(category['name_vi'] as String),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedCategory = value);
        }
      },
    );
  }

  Widget _buildUnitSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      decoration: InputDecoration(
        labelText: 'Đơn vị',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      items: AppConstants.units.map((unit) {
        return DropdownMenuItem(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedUnit = value);
        }
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isRequired = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
        child: Text(
          date != null
              ? DateFormat(AppConstants.dateFormat).format(date)
              : isRequired
                  ? 'Chọn ngày'
                  : 'Không có',
          style: date != null ? AppTheme.body1 : AppTheme.body2,
        ),
      ),
    );
  }

  Widget _buildTemplateInfo() {
    final template = _selectedTemplate!;
    return Card(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thông tin sản phẩm',
                  style: AppTheme.h3.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (template.shelfLifeDays != null)
              _buildInfoRow(
                'Hạn sử dụng',
                '${template.shelfLifeDays} ngày',
              ),
            if (template.storageInstructions != null)
              _buildInfoRow(
                'Bảo quản',
                template.storageInstructions!,
              ),
            if (template.healthInfo != null)
              _buildInfoRow(
                'Lợi ích',
                template.healthInfo!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTheme.body2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.body2,
            ),
          ),
        ],
      ),
    );
  }
}
