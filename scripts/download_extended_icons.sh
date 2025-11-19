#!/bin/bash
#
# Extended Icon Download Script for Fresh Keeper
# Downloads additional 145+ food-related icons to reach 200 total
# Source: https://github.com/microsoft/fluentui-emoji
# License: MIT
#

set -e  # Exit on error

echo "🎨 Fresh Keeper - Extended Icon Downloader"
echo "=========================================="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMP_DIR="/tmp/fluent-emoji-download"
ASSETS_DIR="$TEMP_DIR/assets"
FLAT_DIR="$SCRIPT_DIR/downloads/flat"
TD_DIR="$SCRIPT_DIR/downloads/3d"

# Create directories
echo "📁 Ensuring directories exist..."
mkdir -p "$FLAT_DIR"
mkdir -p "$TD_DIR"

# Check if repo exists
if [ ! -d "$TEMP_DIR" ]; then
    echo "❌ Fluent Emoji repository not found. Please run download_fluent_icons.sh first!"
    exit 1
fi

# Helper function to copy icons
copy_icon() {
    local name=$1
    local fluent_name=$2
    local flat_ext=${3:-.svg}
    local td_ext=${4:-.png}

    # Try to find and copy flat icon
    if [ -d "$ASSETS_DIR/$fluent_name/Flat" ]; then
        local flat_file=$(find "$ASSETS_DIR/$fluent_name/Flat" -type f \( -name "*flat*$flat_ext" -o -name "*$flat_ext" \) | head -1)
        if [ -n "$flat_file" ]; then
            cp "$flat_file" "$FLAT_DIR/${name}${flat_ext}" 2>/dev/null && echo "  ✓ Flat: $name" || echo "  ⚠ Flat failed: $name"
        fi
    fi

    # Try to find and copy 3D icon
    if [ -d "$ASSETS_DIR/$fluent_name/3D" ]; then
        local td_file=$(find "$ASSETS_DIR/$fluent_name/3D" -type f \( -name "*3d*$td_ext" -o -name "*$td_ext" \) | head -1)
        if [ -n "$td_file" ]; then
            cp "$td_file" "$TD_DIR/${name}${td_ext}" 2>/dev/null && echo "  ✓ 3D: $name" || echo "  ⚠ 3D failed: $name"
        fi
    fi
}

echo ""
echo "🍕 Downloading PREPARED FOODS icons..."
copy_icon "pizza" "Pizza"
copy_icon "hamburger" "Hamburger"
copy_icon "hot_dog" "Hot dog"
copy_icon "sandwich" "Sandwich"
copy_icon "taco" "Taco"
copy_icon "burrito" "Burrito"
copy_icon "stuffed_flatbread" "Stuffed flatbread"
copy_icon "falafel" "Falafel"
copy_icon "shallow_pan_of_food" "Shallow pan of food"
copy_icon "pot_of_food" "Pot of food"

echo ""
echo "🍜 Downloading ASIAN FOODS icons..."
copy_icon "sushi" "Sushi"
copy_icon "fried_shrimp" "Fried shrimp"
copy_icon "spaghetti" "Spaghetti"
copy_icon "ramen" "Steaming bowl"
copy_icon "curry" "Curry rice"
copy_icon "dumpling" "Dumpling"
copy_icon "dango" "Dango"
copy_icon "fish_cake" "Fish cake with swirl"
copy_icon "moon_cake" "Moon cake"
copy_icon "oden" "Oden"
copy_icon "tempura" "Fried shrimp"
copy_icon "bento" "Bento box"
copy_icon "rice_ball" "Rice ball"

echo ""
echo "🧁 Downloading DESSERTS & SWEETS icons..."
copy_icon "cake" "Shortcake"
copy_icon "birthday_cake" "Birthday cake"
copy_icon "cupcake" "Cupcake"
copy_icon "pie" "Pie"
copy_icon "donut" "Doughnut"
copy_icon "birthday_cake_lit" "Birthday cake"
copy_icon "lollipop" "Lollipop"
copy_icon "custard" "Custard"
copy_icon "fortune_cookie" "Fortune cookie"
copy_icon "pancakes" "Pancakes"
copy_icon "waffle" "Waffle"

echo ""
echo "☕ Downloading BEVERAGES icons..."
copy_icon "coffee" "Hot beverage"
copy_icon "tea" "Teacup without handle"
copy_icon "teapot" "Teapot"
copy_icon "bubble_tea" "Bubble tea"
copy_icon "beverage_box" "Beverage box"
copy_icon "cup_with_straw" "Cup with straw"
copy_icon "beer" "Beer mug"
copy_icon "clinking_beer_mugs" "Clinking beer mugs"
copy_icon "wine_glass" "Wine glass"
copy_icon "cocktail" "Cocktail glass"
copy_icon "tropical_drink" "Tropical drink"
copy_icon "champagne" "Bottle with popping cork"
copy_icon "sake" "Sake"
copy_icon "glass_of_milk" "Glass of milk"
copy_icon "baby_bottle" "Baby bottle"

echo ""
echo "🍇 Downloading MORE FRUITS icons..."
copy_icon "berries" "Berries"
copy_icon "olive_oil" "Olive"
copy_icon "bell_pepper_green" "Bell pepper"
copy_icon "grapefruit" "Citrus"
copy_icon "pomegranate" "Pomegranate"
copy_icon "apricot" "Apricot"
copy_icon "plum" "Plum"
copy_icon "fig" "Fig"
copy_icon "date" "Date"
copy_icon "persimmon" "Persimmon"

echo ""
echo "🥗 Downloading MORE VEGETABLES icons..."
copy_icon "green_salad" "Green salad"
copy_icon "leafy_greens" "Leafy green"
copy_icon "celery" "Celery"
copy_icon "radish_white" "Radish"
copy_icon "turnip" "Turnip"
copy_icon "beet" "Beet"
copy_icon "leek" "Leek"
copy_icon "asparagus" "Asparagus"
copy_icon "bean_sprouts" "Seedling"
copy_icon "artichoke" "Artichoke"
copy_icon "fennel" "Fennel"

echo ""
echo "🌰 Downloading NUTS & SEEDS icons..."
copy_icon "almond" "Almond"
copy_icon "walnut" "Walnut"
copy_icon "hazelnut" "Hazelnut"
copy_icon "cashew" "Cashew"
copy_icon "pistachio" "Pistachio"
copy_icon "sunflower_seeds" "Sunflower"
copy_icon "pumpkin_seeds" "Pumpkin"
copy_icon "pine_nut" "Pine nut"

echo ""
copy_icon "sesame" "Sesame"

echo ""
echo "🌾 Downloading GRAINS & CEREALS icons..."
copy_icon "wheat" "Sheaf of rice"
copy_icon "rice_white" "Rice"
copy_icon "rice_brown" "Cooked rice"
copy_icon "quinoa" "Grain"
copy_icon "oats" "Grain"
copy_icon "barley" "Sheaf of rice"
copy_icon "millet" "Grain"
copy_icon "cornflakes" "Corn"

echo ""
echo "🥫 Downloading CANNED & PACKAGED icons..."
copy_icon "canned_food" "Canned food"
copy_icon "jar" "Honey pot"
copy_icon "oil_bottle" "Bottle with popping cork"
copy_icon "vinegar_bottle" "Bottle with popping cork"

echo ""
echo "🍽️ Downloading UTENSILS & KITCHENWARE icons..."
copy_icon "fork_and_knife" "Fork and knife"
copy_icon "fork_and_knife_with_plate" "Fork and knife with plate"
copy_icon "spoon" "Spoon"
copy_icon "kitchen_knife" "Kitchen knife"
copy_icon "chopsticks" "Chopsticks"
copy_icon "bowl_with_spoon" "Bowl with spoon"
copy_icon "teacup_without_handle" "Teacup without handle"
copy_icon "amphora" "Amphora"

echo ""
echo "🧈 Downloading MORE DAIRY icons..."
copy_icon "whipped_cream" "Custard"
copy_icon "condensed_milk" "Bottle with popping cork"
copy_icon "sour_cream" "Custard"
copy_icon "cottage_cheese" "Cheese wedge"

echo ""
echo "🥓 Downloading MORE MEAT icons..."
copy_icon "steak" "Cut of meat"
copy_icon "ribs" "Meat on bone"
copy_icon "duck_meat" "Poultry leg"
copy_icon "lamb_chop" "Cut of meat"
copy_icon "meatball" "Meat on bone"

echo ""
echo "🐟 Downloading MORE SEAFOOD icons..."
copy_icon "salmon" "Fish"
copy_icon "tuna" "Fish"
copy_icon "sardine" "Fish"
copy_icon "octopus" "Octopus"
copy_icon "oyster_raw" "Oyster"
copy_icon "mussel" "Oyster"
copy_icon "scallop" "Oyster"

echo ""
echo "🌶️ Downloading HERBS & SPICES icons..."
copy_icon "basil" "Herb"
copy_icon "parsley" "Herb"
copy_icon "cilantro" "Herb"
copy_icon "mint" "Herb"
copy_icon "rosemary" "Herb"
copy_icon "thyme" "Herb"
copy_icon "oregano" "Herb"
copy_icon "chili_powder" "Hot pepper"
copy_icon "black_pepper" "Pepper"
copy_icon "paprika" "Bell pepper"
copy_icon "cinnamon_stick" "Cinnamon"
copy_icon "vanilla" "Ice cream"
copy_icon "bay_leaf" "Herb"

echo ""
echo "🫘 Downloading LEGUMES icons..."
copy_icon "green_beans" "Peas"
copy_icon "lima_beans" "Beans"
copy_icon "black_beans" "Beans"
copy_icon "kidney_beans" "Beans"
copy_icon "chickpeas" "Beans"
copy_icon "lentils" "Beans"
copy_icon "soybeans" "Beans"
copy_icon "pinto_beans" "Beans"

echo ""
echo "🥔 Downloading MORE ROOT VEGETABLES icons..."
copy_icon "sweet_potato_purple" "Sweet potato"
copy_icon "yam" "Sweet potato"
copy_icon "taro" "Potato"
copy_icon "cassava" "Potato"
copy_icon "parsnip" "Carrot"
copy_icon "rutabaga" "Turnip"

echo ""
echo "🍄 Downloading MUSHROOM VARIETIES icons..."
copy_icon "shiitake" "Mushroom"
copy_icon "oyster_mushroom" "Mushroom"
copy_icon "portobello" "Mushroom"
copy_icon "enoki" "Mushroom"
copy_icon "button_mushroom" "Mushroom"

echo ""
echo "🫑 Downloading PEPPER VARIETIES icons..."
copy_icon "jalapeno" "Hot pepper"
copy_icon "habanero" "Hot pepper"
copy_icon "serrano" "Hot pepper"
copy_icon "poblano" "Bell pepper"
copy_icon "cayenne" "Hot pepper"

echo ""
echo "📊 Summary:"
flat_count=$(ls -1 "$FLAT_DIR" 2>/dev/null | wc -l)
td_count=$(ls -1 "$TD_DIR" 2>/dev/null | wc -l)
echo "   - Total Flat icons: $flat_count"
echo "   - Total 3D icons: $td_count"

echo ""
echo "✅ Extended download complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Run: python3 scripts/icon_organizer.py"
echo "   2. Run: python3 scripts/generate_icon_config.py"
echo "   3. Copy to lib/config/product_icons.dart"
