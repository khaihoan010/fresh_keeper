import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_localizations.dart';
import '../../../config/theme.dart';
import '../../providers/subscription_provider.dart';

/// Premium Badge Widget
/// Displays a premium badge for VIP users
class PremiumBadgeWidget extends StatelessWidget {
  final bool showText;
  final double size;

  const PremiumBadgeWidget({
    super.key,
    this.showText = true,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (!subscriptionProvider.isPremium) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // Gradient background
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: showText ? 12 : 6,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700), // Gold
                    Color(0xFFFFA500), // Orange
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: size,
                    color: Colors.white,
                  ),
                  if (showText) ...[
                    const SizedBox(width: 6),
                    Text(
                      l10n.premium,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Dark overlay for dark mode
            if (Theme.of(context).brightness == Brightness.dark)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Premium Button Widget
/// Button to upgrade to premium
class PremiumUpgradeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool compact;

  const PremiumUpgradeButton({
    super.key,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        // Don't show if already premium
        if (subscriptionProvider.isPremium) {
          return const SizedBox.shrink();
        }

        if (compact) {
          return TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.workspace_premium, size: 20),
            label: Text(l10n.upgradeToPremium),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFD700),
              backgroundColor: const Color(0xFFFFD700).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        }

        return Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700), // Gold
                    Color(0xFFFFA500), // Orange
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.workspace_premium, size: 24),
                label: Text(
                  l10n.upgradeToPremium,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ),
              ),
            ),
            // Dark overlay for dark mode
            if (Theme.of(context).brightness == Brightness.dark)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
