import '../data/models/product_icon.dart';

/// Product Icons Configuration
/// Fluent UI Emoji style icons for products
class ProductIcons {
  // ============================================================================
  // FREE ICONS - Available to all users
  // ============================================================================

  static const List<ProductIcon> freeIcons = [
    // FRUITS - Free
    ProductIcon(
      id: 'apple_basic',
      name: 'Apple',
      nameVi: 'Táo',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍎',
      displayOrder: 1,
      tags: ['apple', 'táo', 'fruit', 'trái cây'],
    ),
    ProductIcon(
      id: 'green_apple',
      name: 'Green Apple',
      nameVi: 'Táo xanh',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍏',
      displayOrder: 2,
      tags: ['apple', 'táo', 'green', 'xanh'],
    ),
    ProductIcon(
      id: 'banana',
      name: 'Banana',
      nameVi: 'Chuối',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍌',
      displayOrder: 3,
      tags: ['banana', 'chuối'],
    ),
    ProductIcon(
      id: 'orange',
      name: 'Orange',
      nameVi: 'Cam',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍊',
      displayOrder: 4,
      tags: ['orange', 'cam'],
    ),
    ProductIcon(
      id: 'lemon',
      name: 'Lemon',
      nameVi: 'Chanh',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍋',
      displayOrder: 5,
      tags: ['lemon', 'chanh'],
    ),
    ProductIcon(
      id: 'watermelon',
      name: 'Watermelon',
      nameVi: 'Dưa hấu',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍉',
      displayOrder: 6,
      tags: ['watermelon', 'dưa hấu'],
    ),
    ProductIcon(
      id: 'grapes',
      name: 'Grapes',
      nameVi: 'Nho',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍇',
      displayOrder: 7,
      tags: ['grapes', 'nho'],
    ),
    ProductIcon(
      id: 'strawberry',
      name: 'Strawberry',
      nameVi: 'Dâu tây',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍓',
      displayOrder: 8,
      tags: ['strawberry', 'dâu'],
    ),
    ProductIcon(
      id: 'peach',
      name: 'Peach',
      nameVi: 'Đào',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍑',
      displayOrder: 9,
      tags: ['peach', 'đào'],
    ),
    ProductIcon(
      id: 'pineapple',
      name: 'Pineapple',
      nameVi: 'Dứa',
      category: 'fruits',
      tier: IconTier.free,
      emoji: '🍍',
      displayOrder: 10,
      tags: ['pineapple', 'dứa', 'thơm'],
    ),

    // VEGETABLES - Free
    ProductIcon(
      id: 'tomato',
      name: 'Tomato',
      nameVi: 'Cà chua',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🍅',
      displayOrder: 1,
      tags: ['tomato', 'cà chua'],
    ),
    ProductIcon(
      id: 'carrot',
      name: 'Carrot',
      nameVi: 'Cà rốt',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🥕',
      displayOrder: 2,
      tags: ['carrot', 'cà rốt'],
    ),
    ProductIcon(
      id: 'broccoli',
      name: 'Broccoli',
      nameVi: 'Bông cải xanh',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🥦',
      displayOrder: 3,
      tags: ['broccoli', 'bông cải'],
    ),
    ProductIcon(
      id: 'corn',
      name: 'Corn',
      nameVi: 'Ngô',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🌽',
      displayOrder: 4,
      tags: ['corn', 'ngô'],
    ),
    ProductIcon(
      id: 'potato',
      name: 'Potato',
      nameVi: 'Khoai tây',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🥔',
      displayOrder: 5,
      tags: ['potato', 'khoai tây'],
    ),
    ProductIcon(
      id: 'cucumber',
      name: 'Cucumber',
      nameVi: 'Dưa chuột',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🥒',
      displayOrder: 6,
      tags: ['cucumber', 'dưa chuột'],
    ),
    ProductIcon(
      id: 'lettuce',
      name: 'Lettuce',
      nameVi: 'Rau diếp',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🥬',
      displayOrder: 7,
      tags: ['lettuce', 'salad', 'rau diếp'],
    ),
    ProductIcon(
      id: 'pepper',
      name: 'Bell Pepper',
      nameVi: 'Ớt chuông',
      category: 'vegetables',
      tier: IconTier.free,
      emoji: '🫑',
      displayOrder: 8,
      tags: ['pepper', 'ớt chuông'],
    ),

    // MEAT - Free
    ProductIcon(
      id: 'meat',
      name: 'Meat',
      nameVi: 'Thịt',
      category: 'meat',
      tier: IconTier.free,
      emoji: '🥩',
      displayOrder: 1,
      tags: ['meat', 'thịt', 'beef', 'bò'],
    ),
    ProductIcon(
      id: 'chicken',
      name: 'Chicken',
      nameVi: 'Gà',
      category: 'meat',
      tier: IconTier.free,
      emoji: '🍗',
      displayOrder: 2,
      tags: ['chicken', 'gà', 'poultry'],
    ),
    ProductIcon(
      id: 'bacon',
      name: 'Bacon',
      nameVi: 'Thịt xông khói',
      category: 'meat',
      tier: IconTier.free,
      emoji: '🥓',
      displayOrder: 3,
      tags: ['bacon', 'thịt xông khói', 'pork', 'heo'],
    ),

    // EGGS - Free
    ProductIcon(
      id: 'egg',
      name: 'Egg',
      nameVi: 'Trứng',
      category: 'eggs',
      tier: IconTier.free,
      emoji: '🥚',
      displayOrder: 1,
      tags: ['egg', 'trứng'],
    ),

    // DAIRY - Free
    ProductIcon(
      id: 'milk',
      name: 'Milk',
      nameVi: 'Sữa',
      category: 'dairy',
      tier: IconTier.free,
      emoji: '🥛',
      displayOrder: 1,
      tags: ['milk', 'sữa'],
    ),
    ProductIcon(
      id: 'cheese',
      name: 'Cheese',
      nameVi: 'Phô mai',
      category: 'dairy',
      tier: IconTier.free,
      emoji: '🧀',
      displayOrder: 2,
      tags: ['cheese', 'phô mai'],
    ),
    ProductIcon(
      id: 'butter',
      name: 'Butter',
      nameVi: 'Bơ',
      category: 'dairy',
      tier: IconTier.free,
      emoji: '🧈',
      displayOrder: 3,
      tags: ['butter', 'bơ'],
    ),

    // DRY FOOD - Free
    ProductIcon(
      id: 'bread',
      name: 'Bread',
      nameVi: 'Bánh mì',
      category: 'dry_food',
      tier: IconTier.free,
      emoji: '🍞',
      displayOrder: 1,
      tags: ['bread', 'bánh mì'],
    ),
    ProductIcon(
      id: 'rice',
      name: 'Rice',
      nameVi: 'Cơm',
      category: 'dry_food',
      tier: IconTier.free,
      emoji: '🍚',
      displayOrder: 2,
      tags: ['rice', 'cơm', 'gạo'],
    ),
  ];

  // ============================================================================
  // PREMIUM ICONS - Require premium subscription
  // ============================================================================

  static const List<ProductIcon> premiumIcons = [
    // FRUITS - Premium (with sparkle/special effects)
    ProductIcon(
      id: 'apple_gold',
      name: '✨ Golden Apple',
      nameVi: '✨ Táo vàng',
      category: 'fruits',
      tier: IconTier.premium,
      emoji: '✨🍎',
      displayOrder: 100,
      tags: ['apple', 'táo', 'premium', 'gold'],
    ),
    ProductIcon(
      id: 'banana_premium',
      name: '✨ Premium Banana',
      nameVi: '✨ Chuối cao cấp',
      category: 'fruits',
      tier: IconTier.premium,
      emoji: '🌟🍌',
      displayOrder: 101,
      tags: ['banana', 'chuối', 'premium'],
    ),
    ProductIcon(
      id: 'orange_sparkle',
      name: '✨ Sparkling Orange',
      nameVi: '✨ Cam lấp lánh',
      category: 'fruits',
      tier: IconTier.premium,
      emoji: '💫🍊',
      displayOrder: 102,
      tags: ['orange', 'cam', 'premium'],
    ),
    ProductIcon(
      id: 'strawberry_diamond',
      name: '💎 Diamond Strawberry',
      nameVi: '💎 Dâu kim cương',
      category: 'fruits',
      tier: IconTier.premium,
      emoji: '💎🍓',
      displayOrder: 103,
      tags: ['strawberry', 'dâu', 'premium', 'diamond'],
    ),
    ProductIcon(
      id: 'watermelon_star',
      name: '⭐ Star Watermelon',
      nameVi: '⭐ Dưa hấu ngôi sao',
      category: 'fruits',
      tier: IconTier.premium,
      emoji: '⭐🍉',
      displayOrder: 104,
      tags: ['watermelon', 'dưa hấu', 'premium'],
    ),

    // VEGETABLES - Premium
    ProductIcon(
      id: 'tomato_gold',
      name: '✨ Golden Tomato',
      nameVi: '✨ Cà chua vàng',
      category: 'vegetables',
      tier: IconTier.premium,
      emoji: '✨🍅',
      displayOrder: 100,
      tags: ['tomato', 'cà chua', 'premium'],
    ),
    ProductIcon(
      id: 'carrot_premium',
      name: '🌟 Premium Carrot',
      nameVi: '🌟 Cà rốt cao cấp',
      category: 'vegetables',
      tier: IconTier.premium,
      emoji: '🌟🥕',
      displayOrder: 101,
      tags: ['carrot', 'cà rốt', 'premium'],
    ),
    ProductIcon(
      id: 'broccoli_star',
      name: '⭐ Star Broccoli',
      nameVi: '⭐ Bông cải ngôi sao',
      category: 'vegetables',
      tier: IconTier.premium,
      emoji: '⭐🥦',
      displayOrder: 102,
      tags: ['broccoli', 'bông cải', 'premium'],
    ),

    // MEAT - Premium
    ProductIcon(
      id: 'meat_wagyu',
      name: '👑 Wagyu Beef',
      nameVi: '👑 Thịt bò Wagyu',
      category: 'meat',
      tier: IconTier.premium,
      emoji: '👑🥩',
      displayOrder: 100,
      tags: ['meat', 'thịt', 'wagyu', 'premium', 'beef'],
    ),
    ProductIcon(
      id: 'chicken_premium',
      name: '✨ Premium Chicken',
      nameVi: '✨ Gà cao cấp',
      category: 'meat',
      tier: IconTier.premium,
      emoji: '✨🍗',
      displayOrder: 101,
      tags: ['chicken', 'gà', 'premium'],
    ),

    // DAIRY - Premium
    ProductIcon(
      id: 'milk_organic',
      name: '🌿 Organic Milk',
      nameVi: '🌿 Sữa hữu cơ',
      category: 'dairy',
      tier: IconTier.premium,
      emoji: '🌿🥛',
      displayOrder: 100,
      tags: ['milk', 'sữa', 'organic', 'premium'],
    ),
    ProductIcon(
      id: 'cheese_gold',
      name: '✨ Golden Cheese',
      nameVi: '✨ Phô mai vàng',
      category: 'dairy',
      tier: IconTier.premium,
      emoji: '✨🧀',
      displayOrder: 101,
      tags: ['cheese', 'phô mai', 'premium'],
    ),
  ];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get all icons (free + premium)
  static List<ProductIcon> getAllIcons() {
    return [...freeIcons, ...premiumIcons];
  }

  /// Get icons by category
  static List<ProductIcon> getIconsByCategory(String category) {
    final allIcons = getAllIcons();
    return allIcons
        .where((icon) => icon.category == category)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Get free icons by category
  static List<ProductIcon> getFreeIconsByCategory(String category) {
    return freeIcons
        .where((icon) => icon.category == category)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Get premium icons by category
  static List<ProductIcon> getPremiumIconsByCategory(String category) {
    return premiumIcons
        .where((icon) => icon.category == category)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Get icon by ID
  static ProductIcon? getIconById(String? id) {
    if (id == null) return null;
    try {
      return getAllIcons().firstWhere((icon) => icon.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search icons
  static List<ProductIcon> searchIcons(String query, String category, {bool isVietnamese = false}) {
    if (query.isEmpty) {
      return getIconsByCategory(category);
    }

    return getAllIcons()
        .where((icon) =>
            icon.category == category &&
            icon.matchesSearch(query, isVietnamese: isVietnamese))
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Get total count of free icons
  static int get freeIconCount => freeIcons.length;

  /// Get total count of premium icons
  static int get premiumIconCount => premiumIcons.length;
}
