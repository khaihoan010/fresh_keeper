#!/usr/bin/env python3
"""
Map Product Icons
Maps product templates to flat icons based on name matching
"""

import json
from pathlib import Path
from typing import Dict, List, Optional
import re

# Icon name to product name mapping (English)
ICON_MAPPINGS = {
    # Fruits
    'apple_green': ['green apple', 'granny smith'],
    'apple_red': ['apple', 'red apple'],
    'avocado': ['avocado'],
    'banana': ['banana'],
    'blueberries': ['blueberry', 'blueberries'],
    'cherries': ['cherry', 'cherries'],
    'coconut': ['coconut'],
    'grapes': ['grape', 'grapes'],
    'lemon': ['lemon'],
    'mango': ['mango'],
    'melon': ['melon', 'watermelon', 'cantaloupe'],
    'orange': ['orange'],
    'peach': ['peach'],
    'pear': ['pear'],
    'pineapple': ['pineapple'],
    'strawberry': ['strawberry', 'strawberries'],
    'tangerine': ['tangerine', 'mandarin'],

    # Vegetables
    'bell_pepper': ['bell pepper', 'sweet pepper'],
    'bell_pepper_green': ['green pepper', 'green bell pepper'],
    'bell_pepper_orange': ['orange pepper', 'orange bell pepper'],
    'bell_pepper_red': ['red pepper', 'red bell pepper'],
    'bell_pepper_yellow': ['yellow pepper', 'yellow bell pepper'],
    'broccoli': ['broccoli'],
    'cabbage': ['cabbage'],
    'carrot': ['carrot'],
    'cauliflower': ['cauliflower'],
    'celery': ['celery'],
    'corn': ['corn', 'maize'],
    'cucumber': ['cucumber'],
    'eggplant': ['eggplant', 'aubergine'],
    'garlic': ['garlic'],
    'ginger': ['ginger'],
    'leafy_greens': ['spinach', 'lettuce', 'kale', 'greens'],
    'lettuce': ['lettuce', 'salad'],
    'mushroom': ['mushroom'],
    'onion': ['onion'],
    'onion_red': ['red onion'],
    'potato': ['potato'],
    'pumpkin': ['pumpkin'],
    'radish': ['radish'],
    'sweet_potato': ['sweet potato', 'yam'],
    'tomato': ['tomato'],
    'zucchini': ['zucchini', 'courgette'],

    # Meat & Protein
    'bacon': ['bacon'],
    'beef': ['beef', 'steak'],
    'chicken': ['chicken'],
    'drumstick': ['drumstick', 'chicken leg'],
    'egg': ['egg'],
    'fish': ['fish'],
    'pork': ['pork'],
    'poultry_leg': ['turkey leg', 'poultry'],
    'sausage': ['sausage'],
    'shrimp': ['shrimp', 'prawn'],
    'steak': ['steak', 'beef steak'],

    # Dairy
    'baby_bottle': ['milk', 'baby formula'],
    'butter': ['butter'],
    'cheese': ['cheese'],
    'milk': ['milk', 'dairy milk'],
    'yogurt': ['yogurt', 'yoghurt'],

    # Grains & Bread
    'bagel': ['bagel'],
    'baguette': ['baguette', 'french bread'],
    'bread': ['bread'],
    'croissant': ['croissant'],
    'flatbread': ['flatbread', 'pita'],
    'pancakes': ['pancake', 'pancakes'],
    'pretzel': ['pretzel'],
    'rice': ['rice'],
    'roll': ['roll', 'bun'],
    'tortilla': ['tortilla', 'wrap'],
    'waffle': ['waffle'],
    'wheat': ['wheat'],

    # Prepared Foods
    'bento': ['bento', 'lunch box'],
    'burrito': ['burrito'],
    'curry': ['curry'],
    'dumplings': ['dumpling', 'dumplings', 'dim sum'],
    'falafel': ['falafel'],
    'french_fries': ['fries', 'french fries', 'chips'],
    'hamburger': ['hamburger', 'burger'],
    'hot_dog': ['hot dog', 'hotdog'],
    'noodles': ['noodle', 'noodles', 'pasta'],
    'pie': ['pie'],
    'pizza': ['pizza'],
    'popcorn': ['popcorn'],
    'ramen': ['ramen'],
    'salad': ['salad'],
    'sandwich': ['sandwich'],
    'spaghetti': ['spaghetti', 'pasta'],
    'sushi': ['sushi'],
    'taco': ['taco'],
    'tamale': ['tamale'],

    # Desserts & Sweets
    'birthday_cake': ['birthday cake', 'cake'],
    'candy': ['candy', 'sweet'],
    'chocolate': ['chocolate'],
    'cookie': ['cookie', 'biscuit'],
    'cupcake': ['cupcake'],
    'custard': ['custard', 'pudding'],
    'donut': ['donut', 'doughnut'],
    'honey': ['honey'],
    'ice_cream': ['ice cream', 'gelato'],
    'lollipop': ['lollipop', 'candy'],
    'pie': ['pie', 'tart'],
    'shortcake': ['shortcake'],

    # Beverages
    'beer': ['beer', 'ale', 'lager'],
    'beverage_box': ['juice box', 'drink box'],
    'bubble_tea': ['bubble tea', 'boba'],
    'champagne': ['champagne'],
    'cocktail': ['cocktail', 'mixed drink'],
    'coffee': ['coffee'],
    'mate': ['mate', 'yerba mate'],
    'sake': ['sake', 'rice wine'],
    'tea': ['tea'],
    'teacup': ['tea cup', 'teacup'],
    'tropical_drink': ['tropical drink', 'cocktail'],
    'wine_glass': ['wine'],

    # Condiments & Seasonings
    'basil': ['basil'],
    'bay_leaf': ['bay leaf'],
    'chili': ['chili', 'chilli'],
    'cilantro': ['cilantro', 'coriander'],
    'cinnamon': ['cinnamon'],
    'cumin': ['cumin'],
    'hot_pepper': ['hot pepper', 'chili pepper'],
    'ketchup': ['ketchup', 'catsup'],
    'mint': ['mint'],
    'olive_oil': ['olive oil', 'oil'],
    'oregano': ['oregano'],
    'parsley': ['parsley'],
    'rosemary': ['rosemary'],
    'salt': ['salt'],
    'soy_sauce': ['soy sauce'],
    'thyme': ['thyme'],
    'vanilla': ['vanilla'],

    # Other
    'beans': ['bean', 'beans'],
    'jar': ['jar', 'preserves', 'jam'],
    'nuts': ['nut', 'nuts', 'peanut', 'almond'],
    'peanuts': ['peanut', 'peanuts'],
    'popcorn': ['popcorn'],
    'seeds': ['seed', 'seeds'],
    'tofu': ['tofu'],
}

# Category default icons
CATEGORY_ICONS = {
    'fruits': 'apple_red',
    'vegetables': 'carrot',
    'meat': 'beef',
    'seafood': 'fish',
    'dairy': 'milk',
    'eggs': 'egg',
    'grains': 'bread',
    'beverages': 'beverage_box',
    'snacks': 'cookie',
    'condiments': 'ketchup',
    'frozen_foods': 'ice_cream',
    'canned_goods': 'jar',
    'dry_food': 'bread',
    'other': 'amphora',
}


def normalize_text(text: str) -> str:
    """Normalize text for comparison"""
    return re.sub(r'[^a-z0-9\s]', '', text.lower().strip())


def find_matching_icon(product_name: str, category: str) -> Optional[str]:
    """Find matching icon ID for a product"""
    normalized_name = normalize_text(product_name)

    # Try exact matches first
    for icon_id, keywords in ICON_MAPPINGS.items():
        for keyword in keywords:
            if normalize_text(keyword) == normalized_name:
                return icon_id

    # Try partial matches
    for icon_id, keywords in ICON_MAPPINGS.items():
        for keyword in keywords:
            normalized_keyword = normalize_text(keyword)
            if normalized_keyword in normalized_name or normalized_name in normalized_keyword:
                return icon_id

    # Fallback to category default
    return CATEGORY_ICONS.get(category, 'amphora')


def map_product_icons():
    """Map all products to their matching icons"""

    # Load products
    products_path = Path('assets/data/products_sample.json')
    with open(products_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    products = data.get('products', [])

    # Statistics
    stats = {
        'total': len(products),
        'exact_match': 0,
        'partial_match': 0,
        'category_default': 0,
        'updated': 0,
    }

    # Map icons
    for product in products:
        name_en = product.get('name_en', '')
        name_vi = product.get('name_vi', '')
        category = product.get('category', 'other')

        # Try English name first
        icon_id = find_matching_icon(name_en, category)

        # If not found, try Vietnamese name
        if icon_id == CATEGORY_ICONS.get(category, 'amphora'):
            icon_id_vi = find_matching_icon(name_vi, category)
            if icon_id_vi != CATEGORY_ICONS.get(category, 'amphora'):
                icon_id = icon_id_vi

        # Add iconId to product
        product['iconId'] = icon_id
        stats['updated'] += 1

        # Track match type
        if icon_id in [icon for icon, keywords in ICON_MAPPINGS.items()
                       if any(normalize_text(kw) == normalize_text(name_en) for kw in keywords)]:
            stats['exact_match'] += 1
        elif icon_id in [icon for icon, keywords in ICON_MAPPINGS.items()
                         if any(normalize_text(kw) in normalize_text(name_en) or
                               normalize_text(name_en) in normalize_text(kw) for kw in keywords)]:
            stats['partial_match'] += 1
        else:
            stats['category_default'] += 1

    # Save updated data
    output_path = Path('assets/data/products_sample.json')
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    # Print statistics
    print("✅ Product icons mapped successfully!")
    print(f"\n📊 Statistics:")
    print(f"   Total products: {stats['total']}")
    print(f"   Exact matches: {stats['exact_match']}")
    print(f"   Partial matches: {stats['partial_match']}")
    print(f"   Category defaults: {stats['category_default']}")
    print(f"   Updated: {stats['updated']}")
    print(f"\n💾 Saved to: {output_path}")

    # Show some examples
    print(f"\n📝 Sample mappings:")
    for i, product in enumerate(products[:10]):
        print(f"   {product['name_en']:20} → {product['iconId']}")


if __name__ == '__main__':
    map_product_icons()
