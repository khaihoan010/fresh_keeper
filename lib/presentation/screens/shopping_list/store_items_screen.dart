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
      _itemConfigs[index] = _itemConfigs[index].copyWith(location: location);
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
          TextButton(
            onPressed: _handleSave,
            child: Text(
              l10n.save,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item name
            Text(
              config.item.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Location selection
            Text(
              l10n.location,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.fridge),
                  selected: config.location == 'fridge',
                  onSelected: (selected) {
                    if (selected) onLocationChanged('fridge');
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.freezer),
                  selected: config.location == 'freezer',
                  onSelected: (selected) {
                    if (selected) onLocationChanged('freezer');
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.pantry),
                  selected: config.location == 'pantry',
                  onSelected: (selected) {
                    if (selected) onLocationChanged('pantry');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expiry date
            Text(
              l10n.expiryDate,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onDateTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(config.expiryDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Icon(Icons.calendar_today, color: AppTheme.primaryColor),
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
