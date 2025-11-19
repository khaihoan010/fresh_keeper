# 🎨 Fresh Keeper Icon Management Scripts

Bộ công cụ tự động để quản lý và mở rộng bộ icon cho Fresh Keeper app.

## 📦 Files trong thư mục này

```
scripts/
├── README.md                    ← Bạn đang đọc file này
├── ICON_DOWNLOAD_GUIDE.md       ← Hướng dẫn chi tiết các nguồn icon
├── download_fluent_icons.sh     ← Script tự động download icons từ Fluent Emoji
├── icon_organizer.py            ← Script organize và rename icons
├── generate_icon_config.py      ← Script tự động generate Dart code
├── downloads/                   ← Thư mục chứa icons đã download
│   ├── flat/                    ← Flat/SVG icons (free tier)
│   └── 3d/                      ← 3D/PNG icons (premium tier)
├── icon_manifest.json           ← Manifest tự động generate
└── generated_icons.dart         ← Dart code tự động generate
```

## 🚀 Quick Start - 3 Bước Đơn Giản

### Bước 1: Download Icons từ Fluent Emoji

```bash
cd /home/user/fresh_keeper
./scripts/download_fluent_icons.sh
```

**Kết quả:**
- ✅ Clone Microsoft Fluent Emoji repository
- ✅ Copy ~50 icons (cả flat và 3D) vào `scripts/downloads/`

**Nếu muốn download thêm từ nguồn khác:**
- Đọc hướng dẫn chi tiết: `scripts/ICON_DOWNLOAD_GUIDE.md`
- Lưu icons vào `scripts/downloads/flat/` hoặc `scripts/downloads/3d/`

---

### Bước 2: Organize Icons

```bash
python3 scripts/icon_organizer.py
```

**Script này làm gì:**
- ✅ Đọc icons từ `scripts/downloads/`
- ✅ Đổi tên theo convention (lowercase, underscore)
- ✅ Map tên tiếng Việt → tiếng Anh
- ✅ Copy vào `assets/product_icons/flat/` và `assets/product_icons/3d/`
- ✅ Tạo manifest JSON để track icons

**Output:**
```
✅ Copied: táo_đỏ.svg -> apple_red.svg
✅ Copied: cà_rốt.png -> carrot.png
...
📦 Organized 45 flat icons
📦 Organized 45 3d icons
📋 Generated manifest: scripts/icon_manifest.json
```

---

### Bước 3: Generate Dart Code

```bash
python3 scripts/generate_icon_config.py
```

**Script này làm gì:**
- ✅ Đọc manifest JSON
- ✅ Generate Dart code cho `ProductIcon` objects
- ✅ Tự động map tên Việt, emoji, tags
- ✅ Tạo file `scripts/generated_icons.dart`

**Output:**
```
✅ Generated: scripts/generated_icons.dart
   - Free icons: 45
   - Premium icons: 45
   - Total: 90

📋 Next step:
   Copy content from scripts/generated_icons.dart to lib/config/product_icons.dart
```

---

### Bước 4: Cập nhật vào App

```bash
# Backup file cũ
cp lib/config/product_icons.dart lib/config/product_icons.dart.backup

# Copy code mới
cp scripts/generated_icons.dart lib/config/product_icons.dart

# Verify
git diff lib/config/product_icons.dart
```

---

## 🛠️ Chi tiết từng Script

### 1. `download_fluent_icons.sh`

**Purpose:** Tự động download icons từ Microsoft Fluent Emoji (open source, MIT license)

**Usage:**
```bash
./scripts/download_fluent_icons.sh
```

**Features:**
- Clone Fluent Emoji repo vào `/tmp/`
- Copy ~50 food-related icons
- Bao gồm: fruits, vegetables, meat, dairy, etc.
- Cả flat SVG và 3D PNG

**Customize:**
Edit script để add thêm icons:
```bash
copy_icon "new_item" "Fluent Name" "flat_file.svg" "3d_file.png"
```

---

### 2. `icon_organizer.py`

**Purpose:** Organize và standardize icons

**Configuration:**
- **CATEGORIES**: Map category Vietnamese → English ID
- **FOOD_NAME_MAPPING**: Map Vietnamese food names → English

**Functions:**
- `ensure_directories()`: Tạo folders cần thiết
- `organize_icons(icon_type)`: Copy và rename icons
- `generate_manifest()`: Tạo JSON manifest
- `guess_category(name)`: Tự động đoán category dựa vào tên

**Customize:**
Thêm mapping mới vào `FOOD_NAME_MAPPING`:
```python
FOOD_NAME_MAPPING = {
    'bap_cai': 'cabbage',
    'dua_hau': 'watermelon',
    # Add more...
}
```

---

### 3. `generate_icon_config.py`

**Purpose:** Generate Dart code từ icon manifest

**Configuration:**
- **VIETNAMESE_NAMES**: Map English → Vietnamese display names
- **EMOJI_MAPPING**: Map icon names → emoji characters

**Functions:**
- `to_title_case(name)`: Convert snake_case → Title Case
- `get_emoji(name)`: Get emoji cho icon
- `generate_icon_entry()`: Generate Dart code cho 1 icon
- `generate_config()`: Generate toàn bộ file

**Output Format:**
```dart
ProductIcon(
  id: 'apple_red',
  name: 'Red Apple',
  nameVi: 'Táo đỏ',
  category: 'fruits',
  tier: IconTier.free,
  emoji: '🍎',
  assetPath: 'assets/product_icons/flat/apple_red.svg',
  displayOrder: 1,
  tags: ['apple red', 'táo đỏ', 'red apple'],
),
```

**Customize:**
Add thêm tên Việt:
```python
VIETNAMESE_NAMES = {
    'new_item': 'Tên tiếng Việt',
    # Add more...
}
```

---

## 📋 Workflows

### Workflow 1: Add Thêm Vài Icons Mới

```bash
# 1. Download icons thủ công
# Lưu vào scripts/downloads/flat/ hoặc scripts/downloads/3d/

# 2. Organize
python3 scripts/icon_organizer.py

# 3. Generate
python3 scripts/generate_icon_config.py

# 4. Update app
cp scripts/generated_icons.dart lib/config/product_icons.dart
```

---

### Workflow 2: Rebuild Toàn Bộ Icon Library

```bash
# 1. Xóa icons cũ
rm -rf scripts/downloads/flat/*
rm -rf scripts/downloads/3d/*

# 2. Download mới
./scripts/download_fluent_icons.sh

# 3. Organize
python3 scripts/icon_organizer.py

# 4. Generate
python3 scripts/generate_icon_config.py

# 5. Review
cat scripts/icon_manifest.json
cat scripts/generated_icons.dart

# 6. Backup & Update
cp lib/config/product_icons.dart lib/config/product_icons.dart.backup
cp scripts/generated_icons.dart lib/config/product_icons.dart

# 7. Commit
git add assets/product_icons/ lib/config/product_icons.dart
git commit -m "feat: Add new icon library with XX icons"
```

---

### Workflow 3: Add Icons từ Multiple Sources

```bash
# 1. Download từ Fluent Emoji
./scripts/download_fluent_icons.sh

# 2. Download thêm từ Flaticon
# Lưu thủ công vào scripts/downloads/flat/

# 3. Download 3D từ Icons8
# Lưu thủ công vào scripts/downloads/3d/

# 4. Organize tất cả
python3 scripts/icon_organizer.py

# 5. Generate
python3 scripts/generate_icon_config.py

# 6. Update app
cp scripts/generated_icons.dart lib/config/product_icons.dart
```

---

## 🎯 Best Practices

### Naming Convention

**File names:**
- ✅ `apple_red.svg` (lowercase, underscore)
- ❌ `Apple Red.svg`
- ❌ `apple-red.svg`

**Icon IDs:**
- ✅ `apple_red` (descriptive)
- ❌ `icon1`, `img_001`

### Icon Requirements

**Flat Icons (Free):**
- Format: SVG preferred, PNG acceptable
- Size: Vector (SVG) or >= 256px
- Style: Flat, 2D, consistent style

**3D Icons (Premium):**
- Format: PNG
- Size: >= 256px × 256px (512px recommended)
- Style: 3D, glossy, Fluent Emoji style
- Background: Transparent

### Organization Tips

1. **Group by category** khi download
2. **Consistent style** - chọn 1 style và stick with it
3. **Test first** - download vài icons test trước
4. **Backup** - luôn backup `product_icons.dart` trước khi update
5. **Commit often** - commit sau mỗi batch icons

---

## 🐛 Troubleshooting

### Script không chạy?

```bash
# Check Python version
python3 --version  # Should be 3.6+

# Make executable
chmod +x scripts/*.sh scripts/*.py

# Check dependencies
# (No external dependencies needed - pure Python stdlib)
```

### Icons không copy?

```bash
# Check file paths
ls -la scripts/downloads/flat/
ls -la scripts/downloads/3d/

# Check permissions
chmod 644 scripts/downloads/flat/*
chmod 644 scripts/downloads/3d/*

# Run with verbose output
python3 scripts/icon_organizer.py
```

### Generated code có lỗi?

```bash
# Check manifest
cat scripts/icon_manifest.json

# Validate JSON
python3 -m json.tool scripts/icon_manifest.json

# Check generated Dart
head -50 scripts/generated_icons.dart
```

### Icons không hiển thị trong app?

1. Check asset paths trong `product_icons.dart`
2. Verify files tồn tại: `ls assets/product_icons/flat/`
3. Run `flutter clean && flutter pub get`
4. Restart app

---

## 📚 Additional Resources

- **Icon Sources:** `scripts/ICON_DOWNLOAD_GUIDE.md`
- **Microsoft Fluent Emoji:** https://github.com/microsoft/fluentui-emoji
- **Flaticon:** https://www.flaticon.com
- **Icons8:** https://icons8.com
- **Flutter Assets:** https://docs.flutter.dev/development/ui/assets-and-images

---

## 🤝 Contributing

Để add thêm icons:

1. Fork/clone repo
2. Add icons vào `scripts/downloads/`
3. Run organizing workflow
4. Test trong app
5. Commit với message rõ ràng
6. Create pull request

---

## 📄 License

Scripts trong folder này: MIT License

Icons:
- **Fluent Emoji**: MIT License (Microsoft)
- **Other sources**: Check license từng nguồn

---

## 💡 Tips & Tricks

### Optimize PNG Icons

```bash
# Install TinyPNG CLI (optional)
npm install -g tinypng-cli

# Compress all PNGs
tinypng scripts/downloads/3d/*.png
```

### Batch Rename Icons

```bash
# Rename all uppercase to lowercase
cd scripts/downloads/flat
for f in *; do mv "$f" "$(echo $f | tr '[:upper:]' '[:lower:]')"; done
```

### Quick Check Icon Count

```bash
# Count by category
python3 << EOF
import json
with open('scripts/icon_manifest.json') as f:
    data = json.load(f)
    for icon_type in ['flat', '3d']:
        print(f"\n{icon_type.upper()} icons by category:")
        icons = data[icon_type]
        categories = {}
        for icon_id, icon_data in icons.items():
            cat = icon_data['category']
            categories[cat] = categories.get(cat, 0) + 1
        for cat, count in sorted(categories.items()):
            print(f"  {cat}: {count}")
EOF
```

---

Happy Icon Management! 🎨✨

**Need help?** Check `ICON_DOWNLOAD_GUIDE.md` or open an issue.
