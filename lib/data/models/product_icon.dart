/// Product Icon Model
/// Represents a custom icon for products
/// Supports both emoji and SVG assets

enum IconTier { free, premium }

class ProductIcon {
  final String id;
  final String name;
  final String nameVi;
  final String category;
  final IconTier tier;
  final String emoji;           // Emoji character fallback: '🍎', '🥕', etc
  final String? assetPath;      // SVG asset path: 'assets/product_icons/flat/apple.svg'
  final bool isAnimated;        // Future: for Lottie animations
  final int displayOrder;
  final List<String> tags;      // Search tags

  const ProductIcon({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.category,
    required this.tier,
    required this.emoji,
    this.assetPath,              // Optional: use SVG if provided, emoji if null
    this.isAnimated = false,
    this.displayOrder = 0,
    this.tags = const [],
  });

  /// Check if this icon uses SVG asset
  bool get hasSvgAsset => assetPath != null && assetPath!.isNotEmpty;

  /// Check if this icon matches search query
  bool matchesSearch(String query, {bool isVietnamese = false}) {
    final lowerQuery = query.toLowerCase();
    final searchName = isVietnamese ? nameVi : name;

    return searchName.toLowerCase().contains(lowerQuery) ||
           tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  @override
  String toString() => 'ProductIcon($id, ${hasSvgAsset ? assetPath : emoji}, tier: $tier)';
}
