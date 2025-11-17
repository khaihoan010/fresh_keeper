import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_localizations.dart';
import '../../../config/constants.dart';
import '../../../config/theme.dart';
import '../../../data/models/product_template.dart';
import '../../providers/product_provider.dart';
import '../../widgets/ads/banner_ad_widget.dart';

/// Category View for Bottom Navigation
/// Wrapper without Scaffold for use in IndexedStack
class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryScreen();
  }
}

/// Category Screen - Product Templates
/// Shows all product templates with search and FAB for creating custom templates
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<ProductTemplate> _templates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() => _isLoading = true);
    final provider = context.read<ProductProvider>();
    final templates = await provider.getAllTemplates();
    if (mounted) {
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
    }
  }

  List<ProductTemplate> get _filteredTemplates {
    if (_searchQuery.isEmpty) return _templates;
    return _templates.where((t) {
      final query = _searchQuery.toLowerCase();
      return t.nameVi.toLowerCase().contains(query) ||
          t.nameEn.toLowerCase().contains(query);
    }).toList();
  }

  void _showCreateTemplateDialog() {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    String selectedCategory = 'vegetables';
    final fridgeLifeController = TextEditingController();
    final freezerLifeController = TextEditingController();
    final pantryLifeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
          title: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 32),
                child: Text(
                  l10n.createCustomTemplate,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(dialogContext),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 22,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Template Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.templateName,
                    hintText: l10n.enterTemplateName,
                    prefixIcon: const Icon(Icons.label_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),

                // Category Selector
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  items: AppConstants.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat['id'],
                      child: Row(
                        children: [
                          Text(cat['icon']!, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Text(
                            l10n.isVietnamese ? cat['name_vi']! : cat['name_en']!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Shelf Life Section
                Text(
                  l10n.shelfLifeOptional,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                ),
                const SizedBox(height: 12),

                // Fridge Shelf Life
                TextField(
                  controller: fridgeLifeController,
                  decoration: InputDecoration(
                    labelText: l10n.fridgeShelfLife,
                    hintText: '7',
                    suffixText: l10n.days,
                    prefixIcon: const Icon(Icons.kitchen_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Freezer Shelf Life
                TextField(
                  controller: freezerLifeController,
                  decoration: InputDecoration(
                    labelText: l10n.freezerShelfLife,
                    hintText: '30',
                    suffixText: l10n.days,
                    prefixIcon: const Icon(Icons.ac_unit_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Pantry Shelf Life
                TextField(
                  controller: pantryLifeController,
                  decoration: InputDecoration(
                    labelText: l10n.pantryShelfLife,
                    hintText: '14',
                    suffixText: l10n.days,
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                icon: const Icon(Icons.save_outlined, size: 20),
                label: Text(
                  l10n.save,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseEnterProductName),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                // Create custom template
                final template = ProductTemplate(
                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  nameVi: name,
                  nameEn: name,
                  aliases: [],
                  category: selectedCategory,
                  shelfLifeRefrigerated: int.tryParse(fridgeLifeController.text),
                  shelfLifeFrozen: int.tryParse(freezerLifeController.text),
                  shelfLifePantry: int.tryParse(pantryLifeController.text),
                );

                // Save to database
                final provider = this.context.read<ProductProvider>();
                final result = await provider.saveCustomTemplate(template);

                if (mounted) {
                  Navigator.pop(dialogContext);

                  if (result) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.templateCreated),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                    // Reload templates to show the new one
                    _loadTemplates();
                  } else {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.isVietnamese
                            ? 'Không thể tạo mẫu'
                            : 'Cannot create template'),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                  }
                }
              },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplateDetail(ProductTemplate template) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.isVietnamese ? template.nameVi : template.nameEn,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (l10n.isVietnamese)
                            Text(
                              template.nameEn,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                            )
                          else
                            Text(
                              template.nameVi,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildInfoRow(
                      l10n.category,
                      l10n.isVietnamese
                          ? AppConstants.categoryNamesVi[template.category] ?? template.category
                          : AppConstants.categoryNamesEn[template.category] ?? template.category,
                      AppConstants.categoryIcons[template.category] ?? '📦',
                    ),
                    const SizedBox(height: 12),
                    if (template.shelfLifeRefrigerated != null)
                      _buildInfoRow(
                        l10n.fridgeShelfLife,
                        '${template.shelfLifeRefrigerated} ${l10n.days}',
                        '❄️',
                      ),
                    if (template.shelfLifeFrozen != null)
                      _buildInfoRow(
                        l10n.freezerShelfLife,
                        '${template.shelfLifeFrozen} ${l10n.days}',
                        '🧊',
                      ),
                    if (template.shelfLifePantry != null)
                      _buildInfoRow(
                        l10n.pantryShelfLife,
                        '${template.shelfLifePantry} ${l10n.days}',
                        '🏠',
                      ),
                    if (template.storageTips != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.storage,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(template.storageTips!),
                    ],
                    if (template.healthBenefits != null && template.healthBenefits!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.benefits,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ...template.healthBenefits!.map((benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Text('✅ '),
                                Expanded(child: Text(benefit)),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String icon) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.productTemplates),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchProducts,
                prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTemplates.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📦', style: TextStyle(fontSize: 80)),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty ? l10n.noProductsFound : l10n.noProducts,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12).copyWith(bottom: 80),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: _filteredTemplates.length,
                        itemBuilder: (context, index) {
                          final template = _filteredTemplates[index];
                          return _TemplateGridTile(
                            template: template,
                            onTap: () => _showTemplateDetail(template),
                          );
                        },
                      ),
          ),
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'category_fab',
        onPressed: _showCreateTemplateDialog,
        tooltip: l10n.createProductTemplate,
        child: const Icon(Icons.add_box_outlined, size: 28),
      ),
    );
  }
}

/// Template Grid Tile Widget - Compact card for 3-column grid
class _TemplateGridTile extends StatelessWidget {
  final ProductTemplate template;
  final VoidCallback onTap;

  const _TemplateGridTile({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 3,
      shadowColor: Colors.black38,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Column(
          children: [
            // Icon area - 2/3 of card height
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    AppConstants.categoryIcons[template.category] ?? '📦',
                    style: const TextStyle(fontSize: 42),
                  ),
                ),
              ),
            ),
            // Text area - 1/3 of card height
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Product name
                    Text(
                      l10n.isVietnamese ? template.nameVi : template.nameEn,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.1,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Category name
                    Text(
                      l10n.isVietnamese
                          ? AppConstants.categoryNamesVi[template.category] ?? template.category
                          : AppConstants.categoryNamesEn[template.category] ?? template.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
