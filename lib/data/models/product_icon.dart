/// Product Icon Model
/// Represents a custom icon for products

enum IconTier { free, premium }

class ProductIcon {
  final String id;
  final String name;
  final String nameVi;
  final String category;
  final IconTier tier;
  final String emoji;           // Emoji character: '🍎', '🥕', etc
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
    this.isAnimated = false,
    this.displayOrder = 0,
    this.tags = const [],
  });

  /// Check if this icon matches search query
  bool matchesSearch(String query, {bool isVietnamese = false}) {
    final lowerQuery = query.toLowerCase();
    final searchName = isVietnamese ? nameVi : name;

    return searchName.toLowerCase().contains(lowerQuery) ||
           tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  @override
  String toString() => 'ProductIcon($id, $emoji, tier: $tier)';
}
