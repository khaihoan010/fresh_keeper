import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../../utils/date_utils.dart';
import '../../providers/product_provider.dart';

/// Edit Product Screen
/// Form to edit existing products
class EditProductScreen extends StatefulWidget {
  final UserProduct product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late String _selectedCategory;
  late String _selectedUnit;
  late String _selectedLocation;
  late DateTime _purchaseDate;
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
    _notesController = TextEditingController(text: widget.product.notes ?? '');

    _selectedCategory = widget.product.category;
    _selectedUnit = widget.product.unit;
    _selectedLocation = widget.product.location ?? 'fridge';
    _purchaseDate = widget.product.purchaseDate;
    _expiryDate = widget.product.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPurchaseDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPurchaseDate ? _purchaseDate : _expiryDate,
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
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // Normalize dates to midnight for consistent storage
    final normalizedPurchaseDate = normalizeDate(_purchaseDate);
    final normalizedExpiryDate = normalizeDate(_expiryDate);

    final updatedProduct = widget.product.copyWith(
      name: _nameController.text.trim(),
      category: _selectedCategory,
      quantity: double.parse(_quantityController.text),
      unit: _selectedUnit,
      purchaseDate: normalizedPurchaseDate,
      expiryDate: normalizedExpiryDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      location: _selectedLocation,
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
    final success = await provider.updateProduct(updatedProduct);

    // Hide loading
    if (mounted) Navigator.of(context).pop();

    if (success) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productUpdated(updatedProduct.name)),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } else {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? l10n.cannotUpdateProduct),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProduct),
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: Text(
              l10n.save,
              style: const TextStyle(
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
            // Product Name
            _buildTextField(
              controller: _nameController,
              label: '${l10n.productName} *',
              hint: l10n.exampleTomato,
              icon: Icons.shopping_basket_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterProductName;
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category
            _buildCategorySelector(),

            const SizedBox(height: 16),

            // Location
            _buildLocationSelector(),

            const SizedBox(height: 16),

            // Quantity and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _quantityController,
                    label: '${l10n.quantity} *',
                    hint: '1',
                    icon: Icons.production_quantity_limits,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.enterQuantity;
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return l10n.invalidNumber;
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
              label: l10n.purchaseDate,
              date: _purchaseDate,
              onTap: () => _selectDate(context, true),
            ),

            const SizedBox(height: 16),

            // Expiry Date
            _buildDateField(
              label: '${l10n.expiryDate} *',
              date: _expiryDate,
              onTap: () => _selectDate(context, false),
              isRequired: true,
            ),

            const SizedBox(height: 16),

            // Notes
            _buildTextField(
              controller: _notesController,
              label: l10n.notes,
              hint: l10n.addNotes,
              icon: Icons.note_outlined,
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save, size: 24),
                label: Text(
                  l10n.saveChanges,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
    final l10n = AppLocalizations.of(context);

    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: l10n.category,
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
              Text(category[l10n.isVietnamese ? 'name_vi' : 'name_en'] as String),
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
    final l10n = AppLocalizations.of(context);

    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      decoration: InputDecoration(
        labelText: l10n.unit,
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

  Widget _buildLocationSelector() {
    final l10n = AppLocalizations.of(context);

    final locations = [
      {'value': 'fridge', 'label': l10n.fridge, 'icon': Icons.kitchen_outlined},
      {'value': 'freezer', 'label': l10n.freezer, 'icon': Icons.ac_unit_outlined},
      {'value': 'pantry', 'label': l10n.pantry, 'icon': Icons.inventory_2_outlined},
    ];

    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      decoration: InputDecoration(
        labelText: l10n.location,
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      items: locations.map((location) {
        return DropdownMenuItem(
          value: location['value'] as String,
          child: Row(
            children: [
              Icon(
                location['icon'] as IconData,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 12),
              Text(location['label'] as String),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedLocation = value);
        }
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
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
          DateFormat(AppConstants.dateFormat).format(date),
          style: AppTheme.body1,
        ),
      ),
    );
  }
}
