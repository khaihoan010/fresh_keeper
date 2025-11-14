import 'package:flutter/material.dart';

import '../../../config/app_localizations.dart';

/// Multi-Select App Bar
/// Shows selection count and exit button
class MultiSelectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onExit;

  const MultiSelectAppBar({
    super.key,
    required this.selectedCount,
    required this.onExit,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onExit,
      ),
      title: Text(l10n.selectedCount(selectedCount)),
      automaticallyImplyLeading: false,
    );
  }
}
