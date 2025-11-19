#!/usr/bin/env python3
import re

# Read the file
with open('/home/user/fresh_keeper/lib/config/product_icons.dart', 'r') as f:
    content = f.read()

# Icon ID to file name mapping (extract base name from _xxx_3d pattern)
def get_file_name(icon_id):
    """Extract base file name from icon ID"""
    # Remove _3d suffix
    base = icon_id.replace('_3d', '')

    # Special mappings
    special = {
        'strawberry_diamond': 'strawberry',
        'watermelon_star': 'watermelon',
        'grapes_royal': 'grapes',
        'mango_gold': 'mango',
        'peach_premium': 'peach',
        'pineapple_gold': 'pineapple',
        'kiwi_sparkle': 'kiwi',
        'avocado_premium': 'avocado',
        'coconut_gold': 'coconut',
        'cherry_diamond': 'cherries',
        'blueberry_star': 'blueberries',
        'lemon_gold': 'lemon',
        'pear_premium': 'pear',
        'tangerine_sparkle': 'tangerine',
        'melon_royal': 'melon',
        'papaya_premium': 'papaya',

        'tomato_gold': 'tomato',
        'carrot_diamond': 'carrot',
        'broccoli_star': 'broccoli',
        'corn_gold': 'corn',
        'potato_premium': 'potato',
        'cucumber_sparkle': 'cucumber',
        'pepper_royal': 'bell_pepper',
        'eggplant_premium': 'eggplant',
        'mushroom_gold': 'mushroom',
        'lettuce_premium': 'lettuce',
        'onion_gold': 'onion',
        'garlic_premium': 'garlic',
        'hot_pepper_fire': 'hot_pepper',
        'pumpkin_gold': 'pumpkin',
        'cauliflower_premium': 'cauliflower',
        'cabbage_fresh': 'cabbage',

        'wagyu_beef': 'beef',
        'premium_beef': 'beef',
        'premium_chicken': 'chicken',
        'royal_chicken': 'chicken',
        'premium_fish': 'fish',
        'gold_fish': 'fish',
        'diamond_shrimp': 'shrimp',
        'premium_shrimp': 'shrimp',
        'gold_crab': 'crab',
        'diamond_lobster': 'lobster',
        'premium_bacon': 'bacon',
        'gold_sausage': 'sausage',
        'premium_ham': 'ham',
        'royal_turkey': 'turkey',
        'premium_pork': 'pork',
        'squid_premium': 'squid',
        'oyster_premium': 'oyster',

        'egg_gold': 'egg',
        'fried_egg_premium': 'fried_egg',

        'milk_premium': 'milk',
        'cheese_gold': 'cheese',
        'butter_premium': 'butter',
        'yogurt_premium': 'yogurt',
        'ice_cream_diamond': 'ice_cream',
        'cream_premium': 'cream',

        'bread_premium': 'bread',
        'baguette_gold': 'baguette',
        'croissant_premium': 'croissant',
        'bagel_premium': 'bagel',
        'pretzel_gold': 'pretzel',
        'rice_premium': 'rice',
        'rice_ball_gold': 'rice_ball',
        'rice_cracker_premium': 'rice_cracker',
        'noodles_gold': 'noodles',
        'spaghetti_premium': 'spaghetti',
        'cookie_premium': 'cookie',
        'cracker_gold': 'cracker',
        'peanuts_premium': 'peanuts',
        'chestnut_gold': 'chestnut',
        'beans_premium': 'beans',
        'cereal_premium': 'cereal',
        'popcorn_gold': 'popcorn',
        'chocolate_diamond': 'chocolate',
        'candy_premium': 'candy',
        'honey_gold': 'honey',
    }

    if base in special:
        return special[base]

    # Default: return base name
    return base

# Find all premium icons and add assetPath if missing
lines = content.split('\n')
new_lines = []
i = 0

while i < len(lines):
    new_lines.append(lines[i])

    # Check if this is a premium icon ProductIcon declaration
    if "id: '" in lines[i] and '_3d' in lines[i]:
        # Extract icon ID
        match = re.search(r"id: '([^']+)'", lines[i])
        if match:
            icon_id = match.group(1)

            # Look ahead to check if assetPath already exists
            has_asset_path = False
            emoji_line_idx = None

            for j in range(i + 1, min(i + 20, len(lines))):
                if 'assetPath:' in lines[j]:
                    has_asset_path = True
                    break
                if 'emoji:' in lines[j]:
                    emoji_line_idx = j
                if lines[j].strip().startswith('ProductIcon('):
                    break  # Next icon started

            # If no assetPath and we found emoji line, add it
            if not has_asset_path and emoji_line_idx:
                file_name = get_file_name(icon_id)

                # Copy lines up to and including emoji line
                for j in range(i + 1, emoji_line_idx + 1):
                    new_lines.append(lines[j])

                # Add assetPath line
                indent = '      '
                asset_line = f"{indent}assetPath: 'assets/product_icons/3d/{file_name}.png',"
                new_lines.append(asset_line)

                # Skip to after emoji line
                i = emoji_line_idx + 1
                continue

    i += 1

# Write back
with open('/home/user/fresh_keeper/lib/config/product_icons.dart', 'w') as f:
    f.write('\n'.join(new_lines))

print("✅ Added assetPath to all premium icons!")
