#!/bin/bash
#
# Auto Download Icons from Microsoft Fluent Emoji
# Source: https://github.com/microsoft/fluentui-emoji
# License: MIT
#

set -e  # Exit on error

echo "🎨 Fresh Keeper - Fluent Icon Downloader"
echo "=========================================="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMP_DIR="/tmp/fluent-emoji-download"
FLUENT_REPO="https://github.com/microsoft/fluentui-emoji.git"
FLAT_DIR="$SCRIPT_DIR/downloads/flat"
TD_DIR="$SCRIPT_DIR/downloads/3d"

# Create directories
echo "📁 Creating directories..."
mkdir -p "$FLAT_DIR"
mkdir -p "$TD_DIR"

# Clone repository if not exists
if [ ! -d "$TEMP_DIR" ]; then
    echo "📥 Cloning Fluent Emoji repository..."
    git clone --depth 1 "$FLUENT_REPO" "$TEMP_DIR"
else
    echo "✅ Fluent Emoji repository already exists"
fi

ASSETS_DIR="$TEMP_DIR/assets"

# Helper function to copy icons
copy_icon() {
    local name=$1
    local fluent_name=$2
    local flat_file=$3
    local td_file=$4

    if [ -f "$ASSETS_DIR/$fluent_name/Flat/$flat_file" ]; then
        cp "$ASSETS_DIR/$fluent_name/Flat/$flat_file" "$FLAT_DIR/${name}.svg" 2>/dev/null || \
        cp "$ASSETS_DIR/$fluent_name/Flat/$flat_file" "$FLAT_DIR/${name}.png" 2>/dev/null || \
        echo "⚠️  Warning: Could not copy flat icon for $name"
    else
        echo "⚠️  Not found: $fluent_name/Flat/$flat_file"
    fi

    if [ -f "$ASSETS_DIR/$fluent_name/3D/$td_file" ]; then
        cp "$ASSETS_DIR/$fluent_name/3D/$td_file" "$TD_DIR/${name}.png"
    else
        echo "⚠️  Not found: $fluent_name/3D/$td_file"
    fi
}

echo ""
echo "🍎 Copying FRUITS icons..."
copy_icon "apple_red" "Red apple" "red_apple_flat.svg" "red_apple_3d.png"
copy_icon "apple_green" "Green apple" "green_apple_flat.svg" "green_apple_3d.png"
copy_icon "banana" "Banana" "banana_flat.svg" "banana_3d.png"
copy_icon "orange" "Tangerine" "tangerine_flat.svg" "tangerine_3d.png"
copy_icon "lemon" "Lemon" "lemon_flat.svg" "lemon_3d.png"
copy_icon "watermelon" "Watermelon" "watermelon_flat.svg" "watermelon_3d.png"
copy_icon "melon" "Melon" "melon_flat.svg" "melon_3d.png"
copy_icon "grapes" "Grapes" "grapes_flat.svg" "grapes_3d.png"
copy_icon "strawberry" "Strawberry" "strawberry_flat.svg" "strawberry_3d.png"
copy_icon "blueberries" "Blueberries" "blueberries_flat.svg" "blueberries_3d.png"
copy_icon "cherries" "Cherries" "cherries_flat.svg" "cherries_3d.png"
copy_icon "peach" "Peach" "peach_flat.svg" "peach_3d.png"
copy_icon "pear" "Pear" "pear_flat.svg" "pear_3d.png"
copy_icon "pineapple" "Pineapple" "pineapple_flat.svg" "pineapple_3d.png"
copy_icon "mango" "Mango" "mango_flat.svg" "mango_3d.png"
copy_icon "kiwi" "Kiwi fruit" "kiwi_fruit_flat.svg" "kiwi_fruit_3d.png"
copy_icon "coconut" "Coconut" "coconut_flat.svg" "coconut_3d.png"

echo ""
echo "🥬 Copying VEGETABLES icons..."
copy_icon "tomato" "Tomato" "tomato_flat.svg" "tomato_3d.png"
copy_icon "carrot" "Carrot" "carrot_flat.svg" "carrot_3d.png"
copy_icon "corn" "Ear of corn" "ear_of_corn_flat.svg" "ear_of_corn_3d.png"
copy_icon "broccoli" "Broccoli" "broccoli_flat.svg" "broccoli_3d.png"
copy_icon "cucumber" "Cucumber" "cucumber_flat.svg" "cucumber_3d.png"
copy_icon "eggplant" "Eggplant" "eggplant_flat.svg" "eggplant_3d.png"
copy_icon "mushroom" "Mushroom" "mushroom_flat.svg" "mushroom_3d.png"
copy_icon "pepper_hot" "Hot pepper" "hot_pepper_flat.svg" "hot_pepper_3d.png"
copy_icon "bell_pepper" "Bell pepper" "bell_pepper_flat.svg" "bell_pepper_3d.png"
copy_icon "potato" "Potato" "potato_flat.svg" "potato_3d.png"
copy_icon "onion" "Onion" "onion_flat.svg" "onion_3d.png"
copy_icon "garlic" "Garlic" "garlic_flat.svg" "garlic_3d.png"
copy_icon "leafy_green" "Leafy green" "leafy_green_flat.svg" "leafy_green_3d.png"

echo ""
echo "🥩 Copying MEAT & SEAFOOD icons..."
copy_icon "meat" "Cut of meat" "cut_of_meat_flat.svg" "cut_of_meat_3d.png"
copy_icon "bacon" "Bacon" "bacon_flat.svg" "bacon_3d.png"
copy_icon "poultry_leg" "Poultry leg" "poultry_leg_flat.svg" "poultry_leg_3d.png"
copy_icon "fish" "Fish" "fish_flat.svg" "fish_3d.png"
copy_icon "shrimp" "Shrimp" "shrimp_flat.svg" "shrimp_3d.png"
copy_icon "crab" "Crab" "crab_flat.svg" "crab_3d.png"
copy_icon "lobster" "Lobster" "lobster_flat.svg" "lobster_3d.png"
copy_icon "squid" "Squid" "squid_flat.svg" "squid_3d.png"

echo ""
echo "🥚 Copying EGGS icons..."
copy_icon "egg" "Egg" "egg_flat.svg" "egg_3d.png"

echo ""
echo "🥛 Copying DAIRY icons..."
copy_icon "milk" "Glass of milk" "glass_of_milk_flat.svg" "glass_of_milk_3d.png"
copy_icon "cheese" "Cheese wedge" "cheese_wedge_flat.svg" "cheese_wedge_3d.png"
copy_icon "butter" "Butter" "butter_flat.svg" "butter_3d.png"
copy_icon "ice_cream" "Ice cream" "ice_cream_flat.svg" "ice_cream_3d.png"

echo ""
echo "🍞 Copying DRY FOOD icons..."
copy_icon "bread" "Bread" "bread_flat.svg" "bread_3d.png"
copy_icon "croissant" "Croissant" "croissant_flat.svg" "croissant_3d.png"
copy_icon "baguette" "Baguette bread" "baguette_bread_flat.svg" "baguette_bread_3d.png"
copy_icon "bagel" "Bagel" "bagel_flat.svg" "bagel_3d.png"
copy_icon "pretzel" "Pretzel" "pretzel_flat.svg" "pretzel_3d.png"
copy_icon "cookie" "Cookie" "cookie_flat.svg" "cookie_3d.png"
copy_icon "peanuts" "Peanuts" "peanuts_flat.svg" "peanuts_3d.png"
copy_icon "chestnut" "Chestnut" "chestnut_flat.svg" "chestnut_3d.png"

echo ""
echo "🧂 Copying CONDIMENTS icons..."
copy_icon "salt" "Salt" "salt_flat.svg" "salt_3d.png"
copy_icon "olive" "Olive" "olive_flat.svg" "olive_3d.png"
copy_icon "honey" "Honey pot" "honey_pot_flat.svg" "honey_pot_3d.png"
copy_icon "bottle" "Bottle with popping cork" "bottle_with_popping_cork_flat.svg" "bottle_with_popping_cork_3d.png"

echo ""
echo "📊 Summary:"
flat_count=$(ls -1 "$FLAT_DIR" 2>/dev/null | wc -l)
td_count=$(ls -1 "$TD_DIR" 2>/dev/null | wc -l)
echo "   - Flat icons: $flat_count"
echo "   - 3D icons: $td_count"

echo ""
echo "✅ Download complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Review downloaded icons in scripts/downloads/"
echo "   2. Run: python3 scripts/icon_organizer.py"
echo "   3. Run: python3 scripts/generate_icon_config.py"
echo "   4. Copy scripts/generated_icons.dart to lib/config/product_icons.dart"
