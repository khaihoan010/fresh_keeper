import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_localizations.dart';
import '../../../config/constants.dart';
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
    final nameViController = TextEditingController();
    final nameEnController = TextEditingController();
    String selectedCategory = 'vegetables';
    final shelfLifeController = TextEditingController(text: '7');

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.createProductTemplate),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameViController,
                  decoration: InputDecoration(
                    labelText: l10n.nameVi,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameEnController,
                  decoration: InputDecoration(
                    labelText: l10n.nameEn,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    border: const OutlineInputBorder(),
                  ),
                  items: AppConstants.categoryIds.map((id) {
                    final name = l10n.isVietnamese
                        ? AppConstants.categoryNamesVi[id] ?? id
                        : AppConstants.categoryNamesEn[id] ?? id;
                    return DropdownMenuItem(
                      value: id,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: shelfLifeController,
                  decoration: InputDecoration(
                    labelText: l10n.shelfLifeDays,
                    border: const OutlineInputBorder(),
                    suffixText: l10n.days,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                if (nameViController.text.trim().isNotEmpty) {
                  // TODO: Save template to database
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.templateCreated),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(l10n.create),
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
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
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
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _filteredTemplates.length,
                        itemBuilder: (context, index) {
                          final template = _filteredTemplates[index];
                          return _TemplateListTile(
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

/// Template List Tile Widget
class _TemplateListTile extends StatelessWidget {
  final ProductTemplate template;
  final VoidCallback onTap;

  const _TemplateListTile({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(
          AppConstants.categoryIcons[template.category] ?? '📦',
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(
          l10n.isVietnamese ? template.nameVi : template.nameEn,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: Text(
          l10n.isVietnamese
              ? AppConstants.categoryNamesVi[template.category] ?? template.category
              : AppConstants.categoryNamesEn[template.category] ?? template.category,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
