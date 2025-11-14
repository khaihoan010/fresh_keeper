import 'package:flutter/material.dart';

import '../../../config/app_localizations.dart';
import '../../../config/theme.dart';

/// Dialog for selecting destination location
/// Used for Move and Copy operations
class LocationSelectorDialog extends StatelessWidget {
  final String title;
  final Set<String> excludeLocations; // Locations to hide from options
  final bool showShoppingList;

  const LocationSelectorDialog({
    super.key,
    required this.title,
    this.excludeLocations = const {},
    this.showShoppingList = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fridge
          if (!excludeLocations.contains('fridge'))
            ListTile(
              leading: const Icon(Icons.kitchen_outlined),
              title: Text(l10n.fridge),
              onTap: () => Navigator.pop(context, 'fridge'),
            ),

          // Freezer
          if (!excludeLocations.contains('freezer'))
            ListTile(
              leading: const Icon(Icons.ac_unit_outlined),
              title: Text(l10n.freezer),
              onTap: () => Navigator.pop(context, 'freezer'),
            ),

          // Pantry
          if (!excludeLocations.contains('pantry'))
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(l10n.pantry),
              onTap: () => Navigator.pop(context, 'pantry'),
            ),

          // Shopping List
          if (showShoppingList) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: Text(l10n.shoppingList),
              onTap: () => Navigator.pop(context, 'shopping_list'),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
