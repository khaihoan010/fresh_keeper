#!/usr/bin/env python3
"""
Icon Organizer Script for Fresh Keeper
Organizes and renames icon files for the app

Usage:
  1. Download icons to: scripts/downloads/flat/ and scripts/downloads/3d/
  2. Run: python3 scripts/icon_organizer.py
  3. Icons will be organized in: assets/product_icons/
"""

import os
import shutil
import json
from pathlib import Path
from typing import Dict, List

# Category mapping (Vietnamese -> English ID)
CATEGORIES = {
    'rau_cu_qua': 'vegetables',
    'trai_cay': 'fruits',
    'thit': 'meat',
    'trung': 'eggs',
    'sua': 'dairy',
    'do_kho': 'dry_food',
    'do_dong_lanh': 'frozen',
    'gia_vi': 'condiments',
    'khac': 'other',
}

# Vietnamese to English mapping for common food items
FOOD_NAME_MAPPING = {
    # Vegetables (Rau củ quả)
    'ca_chua': 'tomato',
    'ca_rot': 'carrot',
    'cu_cai': 'radish',
    'bap_cai': 'cabbage',
    'rau_muong': 'water_spinach',
    'rau_cai': 'lettuce',
    'hanh_tay': 'onion',
    'toi': 'garlic',
    'khoai_tay': 'potato',
    'khoai_lang': 'sweet_potato',
    'bi_do': 'pumpkin',
    'dau_cove': 'zucchini',
    'ot': 'pepper',
    'dua_chuot': 'cucumber',
    'bong_cai_xanh': 'broccoli',
    'bong_cai_trang': 'cauliflower',
    'dau_ha_lan': 'peas',
    'dau_dua': 'string_beans',
    'rau_den': 'spinach',
    'nam': 'mushroom',
    'bi_xanh': 'zucchini',
    'su_hao': 'kohlrabi',
    'hanh_la': 'green_onion',

    # Fruits (Trái cây)
    'tao': 'apple',
    'chuoi': 'banana',
    'cam': 'orange',
    'quyt': 'tangerine',
    'chanh': 'lemon',
    'dua_hau': 'watermelon',
    'dua_luoi': 'melon',
    'nho': 'grapes',
    'dau_tay': 'strawberry',
    'viet_quat': 'blueberries',
    'cherry': 'cherries',
    'dao': 'peach',
    'le': 'pear',
    'mang_cut': 'mangosteen',
    'thanh_long': 'dragon_fruit',
    'sau_rieng': 'durian',
    'mit': 'jackfruit',
    'dua': 'pineapple',
    'xoai': 'mango',
    'chom_chom': 'rambutan',
    'buoi': 'pomelo',
    'kiwi': 'kiwi',
    'oi': 'guava',
    'nhan': 'longan',
    'vai': 'lychee',
    'chuoi': 'banana',
    'du_du': 'papaya',
    'khom': 'pineapple',

    # Meat (Thịt)
    'thit_bo': 'beef',
    'thit_heo': 'pork',
    'thit_ga': 'chicken',
    'thit_vit': 'duck',
    'thit_cuu': 'lamb',
    'thit_de': 'goat',
    'bacon': 'bacon',
    'gio_cha': 'ham',
    'xuong_song': 'ribs',

    # Eggs (Trứng)
    'trung_ga': 'chicken_egg',
    'trung_vit': 'duck_egg',
    'trung_cut': 'quail_egg',

    # Dairy (Sữa)
    'sua_tuoi': 'fresh_milk',
    'sua_chua': 'yogurt',
    'pho_mai': 'cheese',
    'bo': 'butter',
    'kem': 'cream',
    'sua_dac': 'condensed_milk',

    # Dry Food (Đồ khô)
    'gao': 'rice',
    'mi': 'noodles',
    'banh_mi': 'bread',
    'bot_mi': 'flour',
    'duong': 'sugar',
    'muoi': 'salt',
    'dau': 'beans',
    'hat': 'nuts',
    'nho_kho': 'raisins',

    # Frozen (Đồ đông lạnh)
    'ca_dong_lanh': 'frozen_fish',
    'tom_dong_lanh': 'frozen_shrimp',
    'kem': 'ice_cream',
    'rau_dong_lanh': 'frozen_vegetables',

    # Condiments (Gia vị)
    'nuoc_tuong': 'soy_sauce',
    'nuoc_mam': 'fish_sauce',
    'dau_an': 'cooking_oil',
    'giam': 'vinegar',
    'tuong_ot': 'chili_sauce',
    'tieu': 'pepper',
    'bot_ngu_vi_huong': 'five_spice',
    'me': 'tamarind',
}

def ensure_directories():
    """Create necessary directories"""
    dirs = [
        'scripts/downloads/flat',
        'scripts/downloads/3d',
        'assets/product_icons/flat',
        'assets/product_icons/3d',
    ]
    for dir_path in dirs:
        Path(dir_path).mkdir(parents=True, exist_ok=True)

def organize_icons(icon_type: str):
    """
    Organize icons from downloads to assets
    icon_type: 'flat' or '3d'
    """
    source_dir = Path(f'scripts/downloads/{icon_type}')
    dest_dir = Path(f'assets/product_icons/{icon_type}')

    if not source_dir.exists():
        print(f"❌ Source directory not found: {source_dir}")
        return

    organized_count = 0

    # Get all image files
    image_extensions = ['.svg', '.png', '.jpg', '.jpeg'] if icon_type == 'flat' else ['.png', '.jpg', '.jpeg']

    for file_path in source_dir.rglob('*'):
        if file_path.suffix.lower() in image_extensions:
            # Convert filename to standard format
            original_name = file_path.stem
            clean_name = original_name.lower().replace(' ', '_').replace('-', '_')

            # Map Vietnamese names to English if found
            english_name = FOOD_NAME_MAPPING.get(clean_name, clean_name)

            # Determine extension
            if icon_type == 'flat':
                new_ext = '.svg' if file_path.suffix.lower() == '.svg' else '.png'
            else:
                new_ext = '.png'

            new_filename = f"{english_name}{new_ext}"
            dest_path = dest_dir / new_filename

            # Copy file
            try:
                shutil.copy2(file_path, dest_path)
                print(f"✅ Copied: {file_path.name} -> {new_filename}")
                organized_count += 1
            except Exception as e:
                print(f"❌ Error copying {file_path.name}: {e}")

    print(f"\n📦 Organized {organized_count} {icon_type} icons")

def generate_manifest():
    """Generate a manifest of all icons for easy config generation"""
    manifest = {
        'flat': {},
        '3d': {}
    }

    for icon_type in ['flat', '3d']:
        icon_dir = Path(f'assets/product_icons/{icon_type}')
        if icon_dir.exists():
            for file_path in sorted(icon_dir.iterdir()):
                if file_path.is_file():
                    name = file_path.stem
                    manifest[icon_type][name] = {
                        'filename': file_path.name,
                        'path': str(file_path),
                        'category': guess_category(name)
                    }

    # Save manifest
    manifest_path = Path('scripts/icon_manifest.json')
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)

    print(f"\n📋 Generated manifest: {manifest_path}")
    print(f"   - Flat icons: {len(manifest['flat'])}")
    print(f"   - 3D icons: {len(manifest['3d'])}")

def guess_category(name: str) -> str:
    """Guess category based on icon name"""
    name_lower = name.lower()

    # Fruits
    fruits = ['apple', 'banana', 'orange', 'lemon', 'grape', 'berry', 'melon',
              'peach', 'pear', 'mango', 'cherry', 'kiwi', 'pineapple', 'watermelon',
              'strawberry', 'blueberry', 'dragon_fruit', 'durian', 'pomelo']
    if any(fruit in name_lower for fruit in fruits):
        return 'fruits'

    # Vegetables
    vegetables = ['tomato', 'carrot', 'cabbage', 'lettuce', 'onion', 'garlic',
                  'potato', 'spinach', 'broccoli', 'pepper', 'cucumber', 'radish',
                  'cauliflower', 'peas', 'mushroom', 'pumpkin', 'zucchini']
    if any(veg in name_lower for veg in vegetables):
        return 'vegetables'

    # Meat
    meats = ['beef', 'pork', 'chicken', 'duck', 'lamb', 'meat', 'bacon', 'ham', 'sausage']
    if any(meat in name_lower for meat in meats):
        return 'meat'

    # Eggs
    if 'egg' in name_lower:
        return 'eggs'

    # Dairy
    dairy = ['milk', 'cheese', 'butter', 'yogurt', 'cream']
    if any(d in name_lower for d in dairy):
        return 'dairy'

    # Frozen
    if 'frozen' in name_lower or 'ice' in name_lower:
        return 'frozen'

    # Condiments
    condiments = ['sauce', 'oil', 'vinegar', 'salt', 'pepper', 'spice']
    if any(c in name_lower for c in condiments):
        return 'condiments'

    # Dry food
    dry_food = ['rice', 'bread', 'flour', 'sugar', 'noodle', 'pasta', 'bean', 'nut']
    if any(d in name_lower for d in dry_food):
        return 'dry_food'

    return 'other'

def main():
    print("🎨 Fresh Keeper Icon Organizer")
    print("=" * 50)

    ensure_directories()

    print("\n📥 Step 1: Organizing icons...")
    organize_icons('flat')
    organize_icons('3d')

    print("\n📋 Step 2: Generating manifest...")
    generate_manifest()

    print("\n✅ Done!")
    print("\nNext steps:")
    print("1. Review: scripts/icon_manifest.json")
    print("2. Run: python3 scripts/generate_icon_config.py")
    print("3. Copy generated code to: lib/config/product_icons.dart")

if __name__ == '__main__':
    main()
