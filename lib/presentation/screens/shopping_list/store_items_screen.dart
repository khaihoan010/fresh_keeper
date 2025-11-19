import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_localizations.dart';
import '../../../config/constants.dart';
import '../../../config/product_icons.dart';
import '../../../config/theme.dart';
import '../../../data/models/shopping_list_item.dart';
import '../../widgets/product_icon_widget.dart';

/// Store Items Screen
/// Full screen to configure storage details for each shopping list item
class StoreItemsScreen extends StatefulWidget {
  final List<ShoppingListItem> items;

  const StoreItemsScreen({
    super.key,
    required this.items,
  });

  @override
  State<StoreItemsScreen> createState() => _StoreItemsScreenState();
}

class _StoreItemsScreenState extends State<StoreItemsScreen> {
  late List<StoreItemConfig> _itemConfigs;

  @override
  void initState() {
    super.initState();
    // Initialize config for each item with default values
    // Use category from shopping list item to preserve user's selection
    _itemConfigs = widget.items
        .map((item) => StoreItemConfig(
              item: item,
              location: 'fridge',
              category: item.category,
              expiryDate: DateTime.now().add(const Duration(days: 7)),
            ))
        .toList();
  }

  void _updateLocation(int index, String location) {
    setState(() {
      final config = _itemConfigs[index];
      // Adjust default expiry date based on location
      final newExpiryDate = switch (location) {
        'fridge' => DateTime.now().add(const Duration(days: 7)),
        'freezer' => DateTime.now().add(const Duration(days: 30)),
        'pantry' => DateTime.now().add(const Duration(days: 14)),
        _ => config.expiryDate,
      };
      _itemConfigs[index] = config.copyWith(
        location: location,
        expiryDate: newExpiryDate,
      );
    });
  }

  void _updateCategory(int index, String category) {
    setState(() {
      _itemConfigs[index] = _itemConfigs[index].copyWith(category: category);
    });
  }

  Future<void> _selectExpiryDate(int index) async {
    final l10n = AppLocalizations.of(context);
    final currentDate = _itemConfigs[index].expiryDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: l10n.selectExpiryDate,
    );

    if (pickedDate != null) {
      setState(() {
        _itemConfigs[index] = _itemConfigs[index].copyWith(expiryDate: pickedDate);
      });
    }
  }

  void _handleSave() {
    Navigator.pop(context, _itemConfigs);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.storeItems),
        actions: [
          TextButton.icon(
            onPressed: _handleSave,
            icon: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              l10n.save,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header info
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.storeItemsInfo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _itemConfigs.length,
              itemBuilder: (context, index) {
                final config = _itemConfigs[index];
                return _StoreItemCard(
                  config: config,
                  onLocationChanged: (location) => _updateLocation(index, location),
                  onCategoryChanged: (category) => _updateCategory(index, category),
                  onDateTap: () => _selectExpiryDate(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Store Item Configuration - Made public for use in shopping_list_screen
class StoreItemConfig {
  final ShoppingListItem item;
  final String location;
  final String category;
  final DateTime expiryDate;

  StoreItemConfig({
    required this.item,
    required this.location,
    required this.category,
    required this.expiryDate,
  });

  StoreItemConfig copyWith({
    ShoppingListItem? item,
    String? location,
    String? category,
    DateTime? expiryDate,
  }) {
    return StoreItemConfig(
      item: item ?? this.item,
      location: location ?? this.location,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}

/// Store Item Card Widget
class _StoreItemCard extends StatefulWidget {
  final StoreItemConfig config;
  final Function(String) onLocationChanged;
  final Function(String) onCategoryChanged;
  final VoidCallback onDateTap;

  const _StoreItemCard({
    required this.config,
    required this.onLocationChanged,
    required this.onCategoryChanged,
    required this.onDateTap,
  });

  @override
  State<_StoreItemCard> createState() => _StoreItemCardState();
}

class _StoreItemCardState extends State<_StoreItemCard> {
  String _categorySearchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Use device locale for date format
    final dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item header with icon and quantity
            Row(
              children: [
                // Category icon or custom icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _buildItemIcon(),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.config.item.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.config.item.quantity} ${widget.config.item.unit}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category selection
            Text(
              l10n.category,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _buildCategorySelector(context, l10n),
            const SizedBox(height: 20),

            // Location selection
            Text(
              l10n.location,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _LocationButton(
                    icon: Icons.kitchen_outlined,
                    label: l10n.fridge,
                    isSelected: widget.config.location == 'fridge',
                    onTap: () => widget.onLocationChanged('fridge'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LocationButton(
                    icon: Icons.ac_unit_outlined,
                    label: l10n.freezer,
                    isSelected: widget.config.location == 'freezer',
                    onTap: () => widget.onLocationChanged('freezer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LocationButton(
                    icon: Icons.inventory_2_outlined,
                    label: l10n.pantry,
                    isSelected: widget.config.location == 'pantry',
                    onTap: () => widget.onLocationChanged('pantry'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Expiry date
            Text(
              l10n.expiryDate,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: widget.onDateTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          dateFormat.format(widget.config.expiryDate),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      _getDaysRemaining(widget.config.expiryDate, l10n),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
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

  Widget _buildCategorySelector(BuildContext context, AppLocalizations l10n) {
    final selectedCat = AppConstants.categories.firstWhere(
      (c) => c['id'] == widget.config.category,
      orElse: () => AppConstants.categories.first,
    );

    return InkWell(
      onTap: () => _showCategoryPicker(context, l10n),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              selectedCat['icon']!,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.isVietnamese ? selectedCat['name_vi']! : selectedCat['name_en']!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredCategories = AppConstants.categories.where((cat) {
            if (_categorySearchQuery.isEmpty) return true;
            final query = _categorySearchQuery.toLowerCase();
            return cat['name_vi']!.toLowerCase().contains(query) ||
                cat['name_en']!.toLowerCase().contains(query);
          }).toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.selectCategory,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search field
                TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchProducts,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onChanged: (value) {
                    setModalState(() => _categorySearchQuery = value);
                  },
                ),
                const SizedBox(height: 12),
                // Category list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final cat = filteredCategories[index];
                      final isSelected = cat['id'] == widget.config.category;
                      return ListTile(
                        leading: Text(
                          cat['icon']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(
                          l10n.isVietnamese ? cat['name_vi']! : cat['name_en']!,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: AppTheme.primaryColor)
                            : null,
                        onTap: () {
                          widget.onCategoryChanged(cat['id']!);
                          Navigator.pop(context);
                          setState(() => _categorySearchQuery = '');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDaysRemaining(DateTime expiryDate, AppLocalizations l10n) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    return l10n.daysRemaining(days);
  }

  /// Build item icon widget with support for custom icons
  Widget _buildItemIcon() {
    // Check for custom icon first
    if (widget.config.item.customIconId != null) {
      final icon = ProductIcons.getIconById(widget.config.item.customIconId);
      if (icon != null) {
        return ProductIconWidget(
          icon: icon,
          size: 24,
        );
      }
    }
    // Fallback to category icon (emoji text)
    return Text(
      AppConstants.categoryIcons[widget.config.category] ?? '🛒',
      style: const TextStyle(fontSize: 24),
    );
  }
}

/// Location Button Widget
class _LocationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
