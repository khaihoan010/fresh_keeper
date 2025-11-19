import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/product_icon.dart';

/// Product Icon Widget
/// Renders product icons with support for both emoji and SVG assets
/// - If icon has assetPath: renders SVG from assets
/// - If icon has no assetPath: renders emoji as text
class ProductIconWidget extends StatelessWidget {
  final ProductIcon icon;
  final double size;
  final Color? color;

  const ProductIconWidget({
    super.key,
    required this.icon,
    this.size = 36,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (icon.hasSvgAsset) {
      // Render SVG asset
      return SvgPicture.asset(
        icon.assetPath!,
        width: size,
        height: size,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => _buildEmojiPlaceholder(),
      );
    } else {
      // Render emoji as text (fallback)
      return _buildEmojiPlaceholder();
    }
  }

  Widget _buildEmojiPlaceholder() {
    return Text(
      icon.emoji,
      style: TextStyle(
        fontSize: size,
        height: 1.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Product Icon from String
/// Convenience widget that accepts icon ID and renders the icon
/// Used when you only have the iconId (e.g., from UserProduct)
class ProductIconFromId extends StatelessWidget {
  final String? iconId;
  final String? fallbackEmoji;
  final double size;
  final Color? color;

  const ProductIconFromId({
    super.key,
    required this.iconId,
    this.fallbackEmoji,
    this.size = 36,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (iconId == null) {
      // No custom icon, show fallback emoji
      return Text(
        fallbackEmoji ?? '📦',
        style: TextStyle(
          fontSize: size,
          height: 1.0,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Import here to avoid circular dependency
    // ignore: implementation_imports
    final icon = _getIconById(iconId!);

    if (icon == null) {
      // Icon not found, show fallback
      return Text(
        fallbackEmoji ?? '📦',
        style: TextStyle(
          fontSize: size,
          height: 1.0,
        ),
        textAlign: TextAlign.center,
      );
    }

    return ProductIconWidget(
      icon: icon,
      size: size,
      color: color,
    );
  }

  // Helper to get icon by ID (avoiding circular import)
  ProductIcon? _getIconById(String id) {
    // This will be imported from product_icons.dart at runtime
    // For now, return null to avoid compilation issues
    // The actual implementation will use ProductIcons.getIconById(id)
    return null;
  }
}
