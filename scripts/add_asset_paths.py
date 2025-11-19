#!/usr/bin/env python3
"""
Script to add assetPath to all premium icons in product_icons.dart
Maps icon IDs to their corresponding PNG files
"""

# Mapping: icon_id -> PNG file name (without .png extension)
ICON_MAPPINGS = {
    # Fruits
    'strawberry_diamond_3d': 'strawberry',
    'watermelon_star_3d': 'watermelon',
    'grapes_royal_3d': 'grapes',
    'mango_gold_3d': 'mango',
    'peach_premium_3d': 'peach',
    'pineapple_gold_3d': 'pineapple',
    'kiwi_sparkle_3d': 'kiwi',
    'avocado_premium_3d': 'avocado',
    'coconut_gold_3d': 'coconut',
    'cherry_diamond_3d': 'cherries',
    'blueberry_star_3d': 'blueberries',
    'lemon_gold_3d': 'lemon',
    'pear_premium_3d': 'pear',
    'tangerine_sparkle_3d': 'tangerine',
    'melon_royal_3d': 'melon',

    # Vegetables
    'tomato_gold_3d': 'tomato',
    'carrot_diamond_3d': 'carrot',
    'broccoli_star_3d': 'broccoli',
    'corn_gold_3d': 'corn',
    'potato_premium_3d': 'potato',
    'cucumber_sparkle_3d': 'cucumber',
    'pepper_royal_3d': 'bell_pepper',
    'eggplant_premium_3d': 'eggplant',
    'onion_gold_3d': 'onion',
    'garlic_sparkle_3d': 'garlic',
    'mushroom_premium_3d': 'mushroom',
    'pumpkin_gold_3d': 'pumpkin',
    'hot_pepper_fire_3d': 'hot_pepper',
    'lettuce_fresh_3d': 'lettuce',

    # Meat & Seafood
    'beef_premium_3d': 'beef',
    'pork_gold_3d': 'pork',
    'chicken_royal_3d': 'chicken',
    'fish_premium_3d': 'fish',
    'shrimp_gold_3d': 'shrimp',
    'crab_premium_3d': 'crab',
    'lobster_diamond_3d': 'lobster',
    'bacon_premium_3d': 'bacon',
    'sausage_gold_3d': 'sausage',

    # Eggs
    'egg_gold_3d': 'egg',
    'fried_egg_premium_3d': 'fried_egg',

    # Dairy
    'milk_premium_3d': 'milk',
    'cheese_gold_3d': 'cheese',
    'butter_premium_3d': 'butter',
    'yogurt_premium_3d': 'yogurt',
    'ice_cream_diamond_3d': 'ice_cream',

    # Dry Food
    'bread_premium_3d': 'bread',
    'baguette_gold_3d': 'baguette',
    'croissant_premium_3d': 'croissant',
    'rice_premium_3d': 'rice',
    'noodles_gold_3d': 'noodles',
    'cookie_premium_3d': 'cookie',
    'chocolate_diamond_3d': 'chocolate',
    'honey_gold_3d': 'honey',
    'popcorn_premium_3d': 'popcorn',
}

def main():
    file_path = '/home/user/fresh_keeper/lib/config/product_icons.dart'

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    modified_lines = []
    i = 0

    while i < len(lines):
        line = lines[i]
        modified_lines.append(line)

        # Check if this line contains an icon ID that needs assetPath
        for icon_id, file_name in ICON_MAPPINGS.items():
            if f"id: '{icon_id}'" in line:
                # Look ahead to find the emoji line
                j = i + 1
                emoji_line_index = None
                while j < len(lines) and j < i + 15:  # Look ahead max 15 lines
                    if 'emoji:' in lines[j]:
                        emoji_line_index = j
                        break
                    j += 1

                if emoji_line_index:
                    # Add all lines between current and emoji line
                    for k in range(i + 1, emoji_line_index + 1):
                        modified_lines.append(lines[k])

                    # Add assetPath line after emoji line
                    indent = '      '
                    asset_path_line = f"{indent}assetPath: 'assets/product_icons/3d/{file_name}.png',"
                    modified_lines.append(asset_path_line)

                    # Continue from after emoji line
                    i = emoji_line_index + 1
                    continue

        i += 1

    # Write back
    new_content = '\n'.join(modified_lines)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print(f"✅ Updated {len(ICON_MAPPINGS)} premium icons with assetPath")

if __name__ == '__main__':
    main()
