#!/bin/bash
set -e
echo "🎨 Fresh Keeper - Final Icon Batch (28 more icons)"
echo "================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_DIR="/tmp/fluent-emoji-download"
ASSETS_DIR="$TEMP_DIR/assets"
FLAT_DIR="$SCRIPT_DIR/downloads/flat"
TD_DIR="$SCRIPT_DIR/downloads/3d"

copy_icon() {
    local name=$1
    local fluent_name=$2
    if [ -d "$ASSETS_DIR/$fluent_name/Flat" ]; then
        local flat_file=$(find "$ASSETS_DIR/$fluent_name/Flat" -type f | head -1)
        [ -n "$flat_file" ] && cp "$flat_file" "$FLAT_DIR/${name}.svg" 2>/dev/null && echo "  ✓ $name"
    fi
    if [ -d "$ASSETS_DIR/$fluent_name/3D" ]; then
        local td_file=$(find "$ASSETS_DIR/$fluent_name/3D" -type f | head -1)
        [ -n "$td_file" ] && cp "$td_file" "$TD_DIR/${name}.png" 2>/dev/null
    fi
}

echo ""
echo "🍰 More desserts & snacks..."
copy_icon "ice_cream_cone" "Ice cream"
copy_icon "soft_ice_cream" "Soft ice cream"
copy_icon "shaved_ice" "Shaved ice"
copy_icon "doughnut_chocolate" "Doughnut"
copy_icon "chocolate_bar" "Chocolate bar"
copy_icon "pudding" "Custard"

echo ""
echo "🥤 More beverages..."
copy_icon "mate" "Mate"
copy_icon "juice_box" "Beverage box"
copy_icon "soft_drink" "Cup with straw"

echo ""
echo "🍳 Cooking & prepared..."
copy_icon "cooking" "Cooking"
copy_icon "fried_egg_full" "Cooking"
copy_icon "french_fries" "French fries"
copy_icon "popcorn_bowl" "Popcorn"

echo ""
echo "🥙 More international food..."
copy_icon "flatbread" "Flatbread"
copy_icon "pita" "Flatbread"
copy_icon "naan" "Flatbread"
copy_icon "tortilla" "Flatbread"

echo ""
echo "🫐 More fruits..."
copy_icon "blueberry" "Blueberries"

echo ""
echo "🥒 More vegetables..."
copy_icon "pickle" "Cucumber"
copy_icon "zucchini" "Cucumber"
copy_icon "squash" "Pumpkin"

echo ""
echo "🧃 Packaged foods..."
copy_icon "takeout_box" "Takeout box"
copy_icon "chopsticks_food" "Chopsticks"

echo ""
echo "🍯 Condiments & extras..."
copy_icon "jam" "Honey pot"
copy_icon "maple_syrup" "Honey pot"
copy_icon "peanut_butter" "Honey pot"

echo ""
echo "🌮 Street food..."
copy_icon "tamale" "Tamale"
copy_icon "empanada" "Pie"
copy_icon "samosa" "Dumpling"

echo ""
flat_count=$(ls -1 "$FLAT_DIR" 2>/dev/null | wc -l)
td_count=$(ls -1 "$TD_DIR" 2>/dev/null | wc -l)
echo "📊 Final count:"
echo "   - Flat icons: $flat_count"
echo "   - 3D icons: $td_count"
echo "✅ Complete!"
