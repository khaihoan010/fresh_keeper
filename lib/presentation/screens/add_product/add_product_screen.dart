import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../../data/models/user_product.dart';
import '../../../data/models/product_template.dart';
import '../../providers/product_provider.dart';
import '../../../services/nutrition_api_service.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/data_sources/local/product_local_data_source.dart';

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

    // Step 1: Search local database first (PRIORITY - local results come first)
    setState(() {
      _isSearching = true;
      _isSearchingApi = false;
    });

    final provider = context.read<ProductProvider>();
    List<ProductTemplate> localResults = await provider.searchTemplates(query);

    setState(() {
      _searchResults = localResults.take(10).toList(); // Limit to 10
      _isSearching = false;
    });

    // Step 2: If local results < 5, search API for more
    if (localResults.length < 5) {
      setState(() => _isSearchingApi = true);

      try {
        final apiResults = await _nutritionApiService.searchProducts(query);

        if (mounted && apiResults.isNotEmpty) {
          // Merge: LOCAL FIRST (current _searchResults), then ONLINE
          // Use _searchResults instead of localResults to preserve what's currently displayed
          final allResults = [..._searchResults]; // Current displayed results FIRST

          for (final apiResult in apiResults) {
            // Check if already exists in current results
            final exists = allResults.any((existing) =>
              existing.nameVi.toLowerCase() == apiResult.nameVi.toLowerCase() ||
              existing.nameEn.toLowerCase() == apiResult.nameEn.toLowerCase()
            );
            if (!exists) {
              allResults.add(apiResult); // Online results AFTER local
            }
          }

          // Limit to 10 results maximum
          final limitedResults = allResults.take(10).toList();

          // Cache API results to database for future use
          await _cacheApiResults(apiResults);

          setState(() {
            _searchResults = limitedResults;
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

  /// Cache API results to local database for offline use
  Future<void> _cacheApiResults(List<ProductTemplate> templates) async {
    if (templates.isEmpty) return;

    try {
      final dataSource = await ProductLocalDataSource.create();
      int cachedCount = 0;

      for (final template in templates) {
        // Check if template already exists in database
        final existing = await dataSource.getTemplateById(template.id);

        if (existing == null) {
          // Template doesn't exist, insert it
          await dataSource.insertTemplate(template);
          cachedCount++;
          debugPrint('✅ Cached: ${template.nameVi} (${template.id})');
        }
      }

      if (cachedCount > 0) {
        debugPrint('📦 Cached $cachedCount new product(s) from API');
      }
    } catch (e) {
      debugPrint('⚠️ Caching error: $e');
      // Don't throw error - caching is not critical
    }
  }

  /// Open barcode scanner and fetch product by barcode
  Future<void> _scanBarcode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );

    if (result != null && mounted) {
      final l10n = AppLocalizations.of(context);

      // Show loading indicator
      setState(() => _isSearchingApi = true);

      try {
        debugPrint('📷 Scanning barcode: $result');

        // Fetch product from API using barcode
        final product = await _nutritionApiService.getProductByBarcode(result);

        if (product != null && mounted) {
          // Cache the product
          await _cacheApiResults([product]);

          // Auto-fill form with product data
          _selectTemplate(product);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.barcodeFound(product.nameVi)),
              backgroundColor: AppTheme.successColor,
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.barcodeNotFound),
              backgroundColor: AppTheme.warningColor,
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ Barcode scan error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.barcodeScanError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
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
          data: Theme.of(context),
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
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectExpiryDate),
          backgroundColor: Theme.of(context).colorScheme.error,
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
            content: Text(l10n.productAddedSuccess(product.name)),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? l10n.cannotAddProduct),
            backgroundColor: Theme.of(context).colorScheme.error,
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
        title: Text(l10n.addProduct),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: l10n.scanBarcode,
            onPressed: _scanBarcode,
          ),
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
            // Smart Search
            _buildSearchSection(),

            const SizedBox(height: 24),

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
                        return l10n.enterQuantityHint;
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
                label: Text(
                  l10n.addProduct,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.quickSearch,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            if (_isSearchingApi)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.searchingOnline,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            hintText: l10n.searchProductsLocalOnline,
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
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400, // Maximum height for 10 results with scrolling
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(), // Enable scrolling
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
                              color: Theme.of(context).colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              l10n.online,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      '${template.nameEn} • ${l10n.daysUnit(template.shelfLifeDays ?? 0)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: template.hasNutrition
                        ? Icon(
                            Icons.restaurant,
                            size: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        : null,
                    onTap: () => _selectTemplate(template),
                  );
                },
              ),
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
              Text(
                l10n.isVietnamese
                    ? (category['name_vi'] as String)
                    : (category['name_en'] as String),
              ),
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

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isRequired = false,
  }) {
    final l10n = AppLocalizations.of(context);

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
                  ? l10n.selectDate
                  : l10n.none,
          style: date != null
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildTemplateInfo() {
    final l10n = AppLocalizations.of(context);
    final template = _selectedTemplate!;

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.productInformation,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (template.shelfLifeDays != null)
              _buildInfoRow(
                l10n.shelfLife,
                l10n.daysUnit(template.shelfLifeDays!),
              ),
            if (template.storageInstructions != null)
              _buildInfoRow(
                l10n.storage,
                template.storageInstructions!,
              ),
            if (template.healthInfo != null)
              _buildInfoRow(
                l10n.benefits,
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barcode Scanner Screen
/// Full-screen barcode scanner with camera preview
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null && code.isNotEmpty) {
      setState(() => _isProcessing = true);
      Navigator.pop(context, code);
    }
  }

  void _toggleTorch() {
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
    cameraController.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanBarcode),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: _toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onBarcodeDetect,
          ),
          // Scanning overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      l10n.positionBarcodeInFrame,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
