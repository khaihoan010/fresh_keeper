import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_localizations.dart';
import '../../../config/theme.dart';

/// Store Items Dialog Result
class StoreItemsResult {
  final String location;
  final DateTime? expiryDate;

  StoreItemsResult({
    required this.location,
    this.expiryDate,
  });
}

/// Dialog for storing shopping list items to inventory
/// User selects location and optionally sets expiration date
class StoreItemsDialog extends StatefulWidget {
  final int itemCount;

  const StoreItemsDialog({
    super.key,
    required this.itemCount,
  });

  @override
  State<StoreItemsDialog> createState() => _StoreItemsDialogState();
}

class _StoreItemsDialogState extends State<StoreItemsDialog> {
  String _selectedLocation = 'fridge';
  DateTime? _expiryDate;

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = _expiryDate ?? now.add(const Duration(days: 7));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _expiryDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.storeItems),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storeItemsMessage(widget.itemCount),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Location selection
          Text(
            l10n.selectLocation,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.kitchen_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(l10n.fridge),
                  ],
                ),
                selected: _selectedLocation == 'fridge',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedLocation = 'fridge');
                },
              ),
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.ac_unit_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(l10n.freezer),
                  ],
                ),
                selected: _selectedLocation == 'freezer',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedLocation = 'freezer');
                },
              ),
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(l10n.pantry),
                  ],
                ),
                selected: _selectedLocation == 'pantry',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedLocation = 'pantry');
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Expiration date
          Text(
            '${l10n.expiryDate} (${l10n.optional})',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _expiryDate != null
                        ? DateFormat('dd/MM/yyyy').format(_expiryDate!)
                        : l10n.selectDate,
                    style: TextStyle(
                      color: _expiryDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  if (_expiryDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() => _expiryDate = null);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              StoreItemsResult(
                location: _selectedLocation,
                expiryDate: _expiryDate,
              ),
            );
          },
          child: Text(l10n.store),
        ),
      ],
    );
  }
}
