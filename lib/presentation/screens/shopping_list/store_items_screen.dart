import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_localizations.dart';
import '../../../config/theme.dart';
import '../../../data/models/shopping_list_item.dart';

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
  late List<_StoreItemConfig> _itemConfigs;

  @override
  void initState() {
    super.initState();
    // Initialize config for each item with default values
    _itemConfigs = widget.items
        .map((item) => _StoreItemConfig(
              item: item,
              location: 'fridge',
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

/// Store Item Configuration
class _StoreItemConfig {
  final ShoppingListItem item;
  final String location;
  final DateTime expiryDate;

  _StoreItemConfig({
    required this.item,
    required this.location,
    required this.expiryDate,
  });

  _StoreItemConfig copyWith({
    ShoppingListItem? item,
    String? location,
    DateTime? expiryDate,
  }) {
    return _StoreItemConfig(
      item: item ?? this.item,
      location: location ?? this.location,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}

/// Store Item Card Widget
class _StoreItemCard extends StatelessWidget {
  final _StoreItemConfig config;
  final Function(String) onLocationChanged;
  final VoidCallback onDateTap;

  const _StoreItemCard({
    required this.config,
    required this.onLocationChanged,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

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
                // Icon placeholder (could be category-based in future)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🛒', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.item.name,
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
                          '${config.item.quantity} ${config.item.unit}',
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
                    isSelected: config.location == 'fridge',
                    onTap: () => onLocationChanged('fridge'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LocationButton(
                    icon: Icons.ac_unit_outlined,
                    label: l10n.freezer,
                    isSelected: config.location == 'freezer',
                    onTap: () => onLocationChanged('freezer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LocationButton(
                    icon: Icons.inventory_2_outlined,
                    label: l10n.pantry,
                    isSelected: config.location == 'pantry',
                    onTap: () => onLocationChanged('pantry'),
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
              onTap: onDateTap,
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
                          dateFormat.format(config.expiryDate),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      _getDaysRemaining(config.expiryDate, l10n),
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

  String _getDaysRemaining(DateTime expiryDate, AppLocalizations l10n) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    return l10n.daysRemaining(days);
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
