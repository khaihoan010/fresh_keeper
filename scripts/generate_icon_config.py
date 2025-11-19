#!/usr/bin/env python3
"""
Icon Config Generator for Fresh Keeper
Generates Dart code for product_icons.dart from icon manifest

Usage:
  1. Run icon_organizer.py first to create manifest
  2. Run: python3 scripts/generate_icon_config.py
  3. Output: scripts/generated_icons.dart (copy to lib/config/product_icons.dart)
"""

import json
from pathlib import Path
from typing import Dict, List

# Vietnamese names for common items
VIETNAMESE_NAMES = {
    # Fruits
    'apple': 'Táo',
    'apple_red': 'Táo đỏ',
    'apple_green': 'Táo xanh',
    'banana': 'Chuối',
    'orange': 'Cam',
    'tangerine': 'Quýt',
    'lemon': 'Chanh',
    'watermelon': 'Dưa hấu',
    'melon': 'Dưa lưới',
    'grapes': 'Nho',
    'strawberry': 'Dâu tây',
    'blueberries': 'Việt quất',
    'cherries': 'Cherry',
    'peach': 'Đào',
    'pear': 'Lê',
    'mango': 'Xoài',
    'pineapple': 'Dứa',
    'kiwi': 'Kiwi',
    'dragon_fruit': 'Thanh long',
    'durian': 'Sầu riêng',
    'pomelo': 'Bưởi',
    'guava': 'Ổi',
    'lychee': 'Vải',
    'longan': 'Nhãn',
    'papaya': 'Đu đủ',
    'mangosteen': 'Măng cụt',
    'rambutan': 'Chôm chôm',

    # Vegetables
    'tomato': 'Cà chua',
    'carrot': 'Cà rốt',
    'cabbage': 'Bắp cải',
    'lettuce': 'Rau xà lách',
    'onion': 'Hành tây',
    'garlic': 'Tỏi',
    'potato': 'Khoai tây',
    'sweet_potato': 'Khoai lang',
    'spinach': 'Rau dền',
    'broccoli': 'Bông cải xanh',
    'cauliflower': 'Bông cải trắng',
    'pepper': 'Ớt',
    'bell_pepper': 'Ớt chuông',
    'cucumber': 'Dưa chuột',
    'radish': 'Củ cải',
    'peas': 'Đậu Hà Lan',
    'mushroom': 'Nấm',
    'pumpkin': 'Bí đỏ',
    'zucchini': 'Bí xanh',
    'eggplant': 'Cà tím',
    'corn': 'Ngô',
    'green_onion': 'Hành lá',
    'ginger': 'Gừng',
    'chili': 'Ớt',
    'celery': 'Cần tây',
    'asparagus': 'Măng tây',
    'bean_sprouts': 'Giá đỗ',
    'bok_choy': 'Cải thìa',
    'water_spinach': 'Rau muống',

    # Meat
    'beef': 'Thịt bò',
    'pork': 'Thịt heo',
    'chicken': 'Thịt gà',
    'duck': 'Thịt vịt',
    'lamb': 'Thịt cừu',
    'bacon': 'Thịt xông khói',
    'ham': 'Giăm bông',
    'sausage': 'Xúc xích',
    'ribs': 'Sườn',
    'ground_beef': 'Thịt bò xay',
    'chicken_breast': 'Ức gà',
    'chicken_wings': 'Cánh gà',
    'fish': 'Cá',
    'salmon': 'Cá hồi',
    'shrimp': 'Tôm',
    'crab': 'Cua',
    'squid': 'Mực',

    # Eggs
    'chicken_egg': 'Trứng gà',
    'duck_egg': 'Trứng vịt',
    'quail_egg': 'Trứng cút',
    'egg': 'Trứng',

    # Dairy
    'milk': 'Sữa',
    'fresh_milk': 'Sữa tươi',
    'yogurt': 'Sữa chua',
    'cheese': 'Phô mai',
    'butter': 'Bơ',
    'cream': 'Kem',
    'condensed_milk': 'Sữa đặc',
    'ice_cream': 'Kem',

    # Dry Food
    'rice': 'Gạo',
    'bread': 'Bánh mì',
    'flour': 'Bột mì',
    'sugar': 'Đường',
    'noodles': 'Mì',
    'pasta': 'Mì ống',
    'beans': 'Đậu',
    'nuts': 'Hạt',
    'almonds': 'Hạnh nhân',
    'peanuts': 'Đậu phộng',
    'cashews': 'Hạt điều',
    'cereal': 'Ngũ cốc',
    'oats': 'Yến mạch',
    'cookies': 'Bánh quy',
    'crackers': 'Bánh cracker',

    # Frozen
    'frozen_vegetables': 'Rau đông lạnh',
    'frozen_fish': 'Cá đông lạnh',
    'frozen_shrimp': 'Tôm đông lạnh',
    'frozen_meat': 'Thịt đông lạnh',

    # Condiments
    'soy_sauce': 'Nước tương',
    'fish_sauce': 'Nước mắm',
    'cooking_oil': 'Dầu ăn',
    'olive_oil': 'Dầu oliu',
    'vinegar': 'Giấm',
    'chili_sauce': 'Tương ớt',
    'ketchup': 'Tương cà',
    'mayonnaise': 'Sốt mayonnaise',
    'mustard': 'Mù tạt',
    'pepper': 'Tiêu',
    'salt': 'Muối',
    'five_spice': 'Ngũ vị hương',
    'cinnamon': 'Quế',
    'cumin': 'Thì là',
}

# Emoji mapping
EMOJI_MAPPING = {
    'apple': '🍎',
    'banana': '🍌',
    'orange': '🍊',
    'lemon': '🍋',
    'watermelon': '🍉',
    'grapes': '🍇',
    'strawberry': '🍓',
    'cherries': '🍒',
    'peach': '🍑',
    'pear': '🍐',
    'pineapple': '🍍',
    'mango': '🥭',
    'kiwi': '🥝',
    'tomato': '🍅',
    'eggplant': '🍆',
    'carrot': '🥕',
    'corn': '🌽',
    'broccoli': '🥦',
    'cucumber': '🥒',
    'mushroom': '🍄',
    'peanuts': '🥜',
    'bread': '🍞',
    'cheese': '🧀',
    'meat': '🥩',
    'chicken': '🍗',
    'bacon': '🥓',
    'egg': '🥚',
    'milk': '🥛',
    'butter': '🧈',
    'ice_cream': '🍨',
    'salt': '🧂',
    'fish': '🐟',
    'shrimp': '🦐',
    'crab': '🦀',
    'squid': '🦑',
}

def to_title_case(name: str) -> str:
    """Convert snake_case to Title Case"""
    return ' '.join(word.capitalize() for word in name.split('_'))

def get_emoji(name: str) -> str:
    """Get emoji for item"""
    # Try exact match first
    if name in EMOJI_MAPPING:
        return EMOJI_MAPPING[name]

    # Try partial match
    for key, emoji in EMOJI_MAPPING.items():
        if key in name or name in key:
            return emoji

    # Default by category
    return '📦'

def generate_icon_entry(icon_id: str, icon_data: Dict, tier: str, order: int) -> str:
    """Generate Dart code for a single icon"""
    english_name = to_title_case(icon_id)
    vietnamese_name = VIETNAMESE_NAMES.get(icon_id, english_name)
    category = icon_data['category']
    filename = icon_data['filename']
    emoji = get_emoji(icon_id)

    # Determine asset path based on tier
    if tier == 'free':
        asset_path = f'assets/product_icons/flat/{filename}'
    else:
        asset_path = f'assets/product_icons/3d/{filename}'

    # Format tags
    tags = [icon_id.replace('_', ' '), vietnamese_name.lower()]
    if icon_id != english_name.lower().replace(' ', '_'):
        tags.append(english_name.lower())

    tags_str = ', '.join(f"'{tag}'" for tag in tags)

    code = f"""    ProductIcon(
      id: '{icon_id}',
      name: '{english_name}',
      nameVi: '{vietnamese_name}',
      category: '{category}',
      tier: IconTier.{tier},
      emoji: '{emoji}',
      assetPath: '{asset_path}',
      displayOrder: {order},
      tags: [{tags_str}],
    ),"""

    return code

def generate_config():
    """Generate complete Dart configuration"""
    manifest_path = Path('scripts/icon_manifest.json')

    if not manifest_path.exists():
        print("❌ Manifest not found. Run icon_organizer.py first!")
        return

    with open(manifest_path, 'r', encoding='utf-8') as f:
        manifest = json.load(f)

    # Generate code
    output = []
    output.append("import '../data/models/product_icon.dart';")
    output.append("")
    output.append("/// Product Icons Configuration")
    output.append("/// Auto-generated icon library")
    output.append("class ProductIcons {")
    output.append("  // " + "=" * 76)
    output.append("  // FREE ICONS - Available to all users (Flat/SVG style)")
    output.append("  // " + "=" * 76)
    output.append("")
    output.append("  static const List<ProductIcon> freeIcons = [")

    # Generate free icons
    flat_icons = manifest.get('flat', {})
    for order, (icon_id, icon_data) in enumerate(sorted(flat_icons.items()), start=1):
        output.append(generate_icon_entry(icon_id, icon_data, 'free', order))

    output.append("  ];")
    output.append("")
    output.append("  // " + "=" * 76)
    output.append("  // PREMIUM ICONS - VIP members only (3D/PNG style)")
    output.append("  // " + "=" * 76)
    output.append("")
    output.append("  static const List<ProductIcon> premiumIcons = [")

    # Generate premium icons
    premium_icons = manifest.get('3d', {})
    for order, (icon_id, icon_data) in enumerate(sorted(premium_icons.items()), start=1):
        output.append(generate_icon_entry(icon_id, icon_data, 'premium', order))

    output.append("  ];")
    output.append("")

    # Add helper methods
    output.append("""  // Helper methods
  static List<ProductIcon> get allIcons => [...freeIcons, ...premiumIcons];

  /// Get total count of free icons
  static int get freeIconCount => freeIcons.length;

  /// Get total count of premium icons
  static int get premiumIconCount => premiumIcons.length;

  static ProductIcon? getIconById(String? id) {
    if (id == null) return null;
    try {
      return allIcons.firstWhere((icon) => icon.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ProductIcon> getIconsByCategory(String category, {bool premiumOnly = false}) {
    final icons = premiumOnly ? premiumIcons : allIcons;
    return icons.where((icon) => icon.category == category).toList();
  }

  static List<ProductIcon> searchIcons(String query, {bool isVietnamese = false}) {
    final lowerQuery = query.toLowerCase();
    return allIcons.where((icon) => icon.matchesSearch(lowerQuery, isVietnamese: isVietnamese)).toList();
  }

  static List<ProductIcon> get freeIconsByDisplayOrder {
    final icons = List<ProductIcon>.from(freeIcons);
    icons.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return icons;
  }

  static List<ProductIcon> get premiumIconsByDisplayOrder {
    final icons = List<ProductIcon>.from(premiumIcons);
    icons.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return icons;
  }
}
""")

    # Write output
    output_path = Path('scripts/generated_icons.dart')
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(output))

    print(f"✅ Generated: {output_path}")
    print(f"   - Free icons: {len(flat_icons)}")
    print(f"   - Premium icons: {len(premium_icons)}")
    print(f"   - Total: {len(flat_icons) + len(premium_icons)}")
    print("\n📋 Next step:")
    print(f"   Copy content from {output_path} to lib/config/product_icons.dart")

if __name__ == '__main__':
    generate_config()
