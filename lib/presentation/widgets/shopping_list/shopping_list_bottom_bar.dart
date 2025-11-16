import 'package:flutter/material.dart';

import '../../../config/app_localizations.dart';

/// Shopping List Multi-Select Bottom Action Bar
/// Shows Store and Delete actions for selected items
class ShoppingListBottomBar extends StatelessWidget {
  final VoidCallback onStore;
  final VoidCallback onDelete;
  final VoidCallback? onSelectAll;

  const ShoppingListBottomBar({
    super.key,
    required this.onStore,
    required this.onDelete,
    this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.inventory_outlined,
                label: l10n.store,
                onPressed: onStore,
              ),
              if (onSelectAll != null)
                _ActionButton(
                  icon: Icons.select_all,
                  label: l10n.selectAll,
                  onPressed: onSelectAll!,
                ),
              _ActionButton(
                icon: Icons.delete_outline,
                label: l10n.delete,
                onPressed: onDelete,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: effectiveColor, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
