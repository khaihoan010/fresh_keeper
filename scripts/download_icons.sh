#!/bin/bash

# ============================================================================
# FluentUI Emoji Icon Download Script
# Downloads Flat and 3D icons from Microsoft's FluentUI Emoji repository
# ============================================================================

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ASSETS_DIR="$PROJECT_ROOT/assets/product_icons"
TEMP_DIR="/tmp/fluentui-emoji-download"

echo "🎨 FluentUI Emoji Icon Downloader"
echo "=================================="
echo ""

# Create assets directories
echo "📁 Creating asset directories..."
mkdir -p "$ASSETS_DIR/flat"
mkdir -p "$ASSETS_DIR/3d"

# Clone FluentUI Emoji repo
echo "📥 Downloading FluentUI Emoji repository..."
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone --depth 1 https://github.com/microsoft/fluentui-emoji.git "$TEMP_DIR"

echo ""
echo "🍎 Copying icons..."
echo ""

# Function to copy icon
# ICON_NAME: folder name like "Red apple" or "Banana"
# OUTPUT_NAME: our output file name like "apple_red" or "banana"
copy_icon() {
    local ICON_NAME=$1
    local OUTPUT_NAME=$2

    # Convert folder name to file base name: "Red apple" → "red_apple"
    local FILE_BASE=$(echo "$ICON_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

    local FLAT_PATH="$TEMP_DIR/assets/$ICON_NAME/Flat/${FILE_BASE}_flat.svg"
    local THREED_PATH="$TEMP_DIR/assets/$ICON_NAME/3D/${FILE_BASE}_3d.png"

    if [ -f "$FLAT_PATH" ]; then
        cp "$FLAT_PATH" "$ASSETS_DIR/flat/${OUTPUT_NAME}.svg"
        echo "  ✅ $OUTPUT_NAME (Flat SVG)"
    else
        echo "  ⚠️  $OUTPUT_NAME (Flat) - NOT FOUND: $FLAT_PATH"
    fi

    if [ -f "$THREED_PATH" ]; then
        cp "$THREED_PATH" "$ASSETS_DIR/3d/${OUTPUT_NAME}.png"
        echo "  ✅ $OUTPUT_NAME (3D PNG)"
    else
        echo "  ⚠️  $OUTPUT_NAME (3D) - NOT FOUND: $THREED_PATH"
    fi
}

# Fruits
echo "🍎 FRUITS"
copy_icon "Red apple" "apple_red"
copy_icon "Green apple" "apple_green"
copy_icon "Banana" "banana"
copy_icon "Tangerine" "orange"
copy_icon "Tangerine" "tangerine"
copy_icon "Lemon" "lemon"
copy_icon "Watermelon" "watermelon"
copy_icon "Melon" "melon"
copy_icon "Grapes" "grapes"
copy_icon "Strawberry" "strawberry"
copy_icon "Blueberries" "blueberries"
copy_icon "Cherries" "cherries"
copy_icon "Peach" "peach"
copy_icon "Pear" "pear"
copy_icon "Pineapple" "pineapple"
copy_icon "Mango" "mango"
copy_icon "Kiwi fruit" "kiwi"
copy_icon "Avocado" "avocado"
copy_icon "Coconut" "coconut"
copy_icon "Melon" "papaya"

echo ""
echo "🥕 VEGETABLES"
copy_icon "Tomato" "tomato"
copy_icon "Carrot" "carrot"
copy_icon "Broccoli" "broccoli"
copy_icon "Broccoli" "cauliflower"
copy_icon "Ear of corn" "corn"
copy_icon "Potato" "potato"
copy_icon "Sweet potato" "sweet_potato"
copy_icon "Cucumber" "cucumber"
copy_icon "Leafy green" "lettuce"
copy_icon "Leafy green" "cabbage"
copy_icon "Bell pepper" "bell_pepper"
copy_icon "Hot pepper" "hot_pepper"
copy_icon "Eggplant" "eggplant"
copy_icon "Onion" "onion"
copy_icon "Garlic" "garlic"
copy_icon "Mushroom" "mushroom"
copy_icon "Jack-o-lantern" "pumpkin"
copy_icon "Garlic" "ginger"  # Fallback to garlic since ginger might not exist

echo ""
echo "🥩 MEAT & SEAFOOD"
copy_icon "Cut of meat" "beef"
copy_icon "Bacon" "pork"
copy_icon "Poultry leg" "chicken"
copy_icon "Poultry leg" "turkey"
copy_icon "Bacon" "bacon"
copy_icon "Hot dog" "sausage"
copy_icon "Meat on bone" "ham"
copy_icon "Fish" "fish"
copy_icon "Shrimp" "shrimp"
copy_icon "Crab" "crab"
copy_icon "Lobster" "lobster"
copy_icon "Squid" "squid"
copy_icon "Oyster" "oyster"

echo ""
echo "🥚 EGGS"
copy_icon "Egg" "egg"
copy_icon "Cooking" "fried_egg"

echo ""
echo "🥛 DAIRY"
copy_icon "Glass of milk" "milk"
copy_icon "Cheese wedge" "cheese"
copy_icon "Butter" "butter"
copy_icon "Glass of milk" "yogurt"
copy_icon "Soft ice cream" "ice_cream"
copy_icon "Glass of milk" "cream"

echo ""
echo "🍞 DRY FOOD"
copy_icon "Bread" "bread"
copy_icon "Baguette bread" "baguette"
copy_icon "Croissant" "croissant"
copy_icon "Bagel" "bagel"
copy_icon "Pretzel" "pretzel"
copy_icon "Cooked rice" "rice"
copy_icon "Rice ball" "rice_ball"
copy_icon "Rice cracker" "rice_cracker"
copy_icon "Steaming bowl" "noodles"
copy_icon "Spaghetti" "spaghetti"
copy_icon "Cookie" "cookie"
copy_icon "Pretzel" "cracker"
copy_icon "Peanuts" "peanuts"
copy_icon "Chestnut" "chestnut"
copy_icon "Beans" "beans"
copy_icon "Bowl with spoon" "cereal"
copy_icon "Popcorn" "popcorn"
copy_icon "Chocolate bar" "chocolate"
copy_icon "Candy" "candy"
copy_icon "Honey pot" "honey"

echo ""
echo "🧹 Cleaning up..."
rm -rf "$TEMP_DIR"

echo ""
echo "✅ DONE!"
echo ""
echo "📊 Summary:"
echo "  - Flat icons (SVG): $(ls -1 $ASSETS_DIR/flat/*.svg 2>/dev/null | wc -l)"
echo "  - 3D icons (PNG): $(ls -1 $ASSETS_DIR/3d/*.png 2>/dev/null | wc -l)"
echo ""
echo "📁 Icons saved to:"
echo "  - $ASSETS_DIR/flat/"
echo "  - $ASSETS_DIR/3d/"
echo ""
echo "🚀 Next steps:"
echo "  1. Run: flutter pub get"
echo "  2. Verify icons in assets/product_icons/"
echo "  3. Run the app!"
echo ""
