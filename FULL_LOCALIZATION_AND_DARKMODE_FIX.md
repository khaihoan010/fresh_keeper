# 🌍 Full App Localization & 🌙 Dark Mode Fix Guide

## ✅ Already Completed

1. **AppLocalizations** - 200+ strings for all screens
2. **Settings Screen** - Fully localized & dark mode ready
3. **Dependencies** - flutter_localizations added

## 📋 Remaining Work

### All screens need:
1. Import AppLocalizations
2. Replace hardcoded Vietnamese strings with `l10n.key`
3. Fix hardcoded colors for dark mode support

---

## 🏠 HOME SCREEN (`lib/presentation/screens/home/home_screen.dart`)

### Changes Needed:

```dart
// Add import
import '../../../config/app_localizations.dart';

// In build method, add:
final l10n = AppLocalizations.of(context);

// Line 82: 'Thử lại' → l10n.retry
ElevatedButton(
  onPressed: () => provider.refresh(),
  child: Text(l10n.retry),  // ← Changed
),

// Line 117: 'Tổng Quan' → l10n.quickStats
Text('Tổng Quan', style: AppTheme.h2),
// TO:
Text(l10n.quickStats, style: AppTheme.h2),

// Line 133-138: Stat cards
_buildStatCard(
  icon: Icons.inventory_2_outlined,
  label: 'Tổng sản phẩm',  // → l10n.totalProducts
  value: '${provider.products.length}',
  color: AppTheme.primaryColor,
),

_buildStatCard(
  icon: Icons.warning_amber_outlined,
  label: 'Sắp hết hạn',  // → l10n.expiringItems
  value: '${provider.expiringProducts.length}',
  color: AppTheme.warningColor,
),

_buildStatCard(
  icon: Icons.error_outline,
  label: 'Đã hết hạn',  // → l10n.expiredItems
  value: '${provider.expiredProducts.length}',
  color: AppTheme.errorColor,
),

// Line 156: 'Thêm Sản Phẩm' → l10n.addProduct

// Line 169: 'Hết Hạn Hôm Nay' → l10n.expiringToday

// Line 181: 'Không có sản phẩm nào hết hạn hôm nay!' → l10n.noExpiringProducts
```

### Dark Mode Fixes:

```dart
// Line 68-72: Error icon color
const Icon(
  Icons.error_outline,
  size: 64,
  color: Colors.red,  // ❌ Hardcoded
),
// TO:
Icon(
  Icons.error_outline,
  size: 64,
  color: Theme.of(context).colorScheme.error,  // ✅ Theme-aware
),

// All Card widgets should use:
color: Theme.of(context).colorScheme.surface,
// Instead of:
color: Colors.white,
```

---

## 📦 PRODUCT DETAIL SCREEN (`lib/presentation/screens/product_detail/product_detail_screen.dart`)

### Critical Dark Mode Fix:

```dart
// Line 221-223: Gradient uses hardcoded Colors.white
colors: [
  _product.getStatusColor().withOpacity(0.2),
  Colors.white,  // ❌ This breaks dark mode!
],
// TO:
colors: [
  _product.getStatusColor().withOpacity(0.2),
  Theme.of(context).colorScheme.surface,  // ✅ Theme-aware
],

// Line 234: Container background
color: Colors.white,
// TO:
color: Theme.of(context).colorScheme.surface,

// Line 899: StickyTabBarDelegate background
color: Colors.white,
// TO:
color: Theme.of(context).colorScheme.surface,
```

### Localization Changes:

```dart
// Add import
import '../../../config/app_localizations.dart';

// Line 167: 'Chi Tiết Sản Phẩm' → l10n.productDetail

// Line 181: 'Đánh dấu đã dùng' → l10n.markUsed

// Line 192: 'Xóa sản phẩm' → l10n.deleteProduct

// Line 319-321: Tab labels
Tab(text: 'Thông Tin'),  // → Tab(text: l10n.information)
Tab(text: 'Dinh Dưỡng'), // → Tab(text: l10n.nutrition)
Tab(text: 'Sức Khỏe'),   // → Tab(text: l10n.health)

// Line 354: 'Thông tin cơ bản' → l10n.basicInfo

// Line 358-385: Info fields
label: 'Số lượng',     // → l10n.quantity
label: 'Ngày mua',     // → l10n.purchaseDate
label: 'Ngày hết hạn',  // → l10n.expiryDate
label: 'Vị trí',       // → l10n.location

// Line 390: 'Ghi chú' → l10n.notes

// Line 417: '💡 Mẹo bảo quản' → l10n.storageTips

// Line 441: 'Đánh Dấu Đã Dùng' → l10n.markAsUsed

// Line 455: 'Xóa Sản Phẩm' → l10n.deleteProduct

// Line 490: 'Chưa có thông tin dinh dưỡng' → l10n.noNutritionData

// Line 495: 'Thông tin dinh dưỡng sẽ được cập nhật sau' → l10n.noNutritionInfoYet

// Line 511: '🍎 Giá Trị Dinh Dưỡng' → l10n.nutritionValue

// Line 563: 'Vitamin' → l10n.vitamins

// Line 597: 'Khoáng chất' → l10n.minerals

// Line 655: 'Chưa có thông tin sức khỏe' → l10n.noHealthData

// Line 660: 'Thông tin sức khỏe sẽ được cập nhật sau' → l10n.noNutritionInfoYet

// Line 677: '✅ Lợi Ích Sức Khỏe' → l10n.healthBenefits

// Line 710: '⚠️ Lưu Ý' → l10n.healthWarnings
```

---

## 📋 ALL ITEMS SCREEN (`lib/presentation/screens/all_items/all_items_screen.dart`)

### Localization:

```dart
// Add import
import '../../../config/app_localizations.dart';

// Add in build:
final l10n = AppLocalizations.of(context);

// Replace all hardcoded strings:
'Tất Cả' → l10n.allItems
'Sắp xếp theo' → l10n.sortBy
'Lọc theo' → l10n.filterBy
'Hạn sử dụng (gần nhất)' → l10n.expiryDateSoon
'Hạn sử dụng (xa nhất)' → l10n.expiryDateLate
'Tên (A-Z)' → l10n.nameAZ
'Tên (Z-A)' → l10n.nameZA
'Mới thêm nhất' → l10n.addedNewest
'Cũ nhất' → l10n.addedOldest
'Tất cả danh mục' → l10n.allCategories
'Tất cả vị trí' → l10n.allLocations
'Chưa có sản phẩm nào' → l10n.noProducts
```

### Dark Mode Fixes:

All Cards and Containers with `Colors.white` should use `Theme.of(context).colorScheme.surface`

---

## ➕ ADD PRODUCT SCREEN (`lib/presentation/screens/add_product/add_product_screen.dart`)

### Localization:

```dart
// Line ~30: 'Thêm Sản Phẩm' → l10n.addProduct

// Search field:
hintText: 'Tìm kiếm sản phẩm...' → hintText: l10n.searchProduct

// Line ~250: 'Quét mã vạch' → l10n.scanBarcode

// Form fields:
'Tên sản phẩm' → l10n.productName
'Nhập tên sản phẩm' → l10n.enterProductName
'Số lượng' → l10n.quantity
'Nhập số lượng' → l10n.enterQuantity
'Ngày mua' → l10n.purchaseDate
'Chọn ngày' → l10n.selectDate
'Ngày hết hạn' → l10n.expiryDate
'Danh mục' → l10n.category
'Chọn danh mục' → l10n.selectCategory
'Vị trí' → l10n.location
'Chọn vị trí' → l10n.selectLocation
'Ghi chú (tùy chọn)' → l10n.addNotes

// Locations:
'Tủ lạnh' → l10n.fridge
'Tủ đông' → l10n.freezer
'Tủ đồ khô' → l10n.pantry

// Loading states:
'Đang tìm kiếm...' → l10n.searching
'Đang tìm online...' → l10n.searchingOnline

// Buttons:
'Thêm' → l10n.add
'Hủy' → l10n.cancel
```

### Dark Mode Fixes:

```dart
// Search results container (should use theme surface color)
color: Colors.white → color: Theme.of(context).colorScheme.surface

// All form InputDecoration already use theme, but verify
```

---

## ⏰ EXPIRING SOON SCREEN

### Localization:

```dart
'Sắp Hết Hạn' → l10n.expiringSoon
'Trong 3 ngày' → l10n.within3Days
'Trong 7 ngày' → l10n.within7Days
'Tất cả sắp hết hạn' → l10n.allExpiring
'Không có sản phẩm nào sắp hết hạn!' → l10n.noExpiringItems
'Tin tốt!' → l10n.greatNews
'Tất cả sản phẩm của bạn đều còn tươi ngon' → l10n.allFresh

// Use function for dynamic text:
l10n.expiresIn(days)  // Returns "Hết hạn sau X ngày" or "Expires in X days"
```

---

## 🎨 GLOBAL DARK MODE FIXES

### Common Patterns to Fix:

1. **Hardcoded white backgrounds:**
```dart
❌ color: Colors.white
✅ color: Theme.of(context).colorScheme.surface
```

2. **Hardcoded black text:**
```dart
❌ color: Colors.black
✅ color: Theme.of(context).colorScheme.onSurface
```

3. **Hardcoded colors in gradients:**
```dart
❌ colors: [someColor, Colors.white]
✅ colors: [someColor, Theme.of(context).colorScheme.surface]
```

4. **Card backgrounds:**
```dart
❌ Card(color: Colors.white)
✅ Card(color: Theme.of(context).colorScheme.surface)
// OR just use Card() without color (inherits from theme)
```

5. **Dialog backgrounds:**
Already handled in `AppTheme.darkTheme.dialogTheme`

6. **Bottom sheets:**
```dart
❌ backgroundColor: Colors.white
✅ backgroundColor: Theme.of(context).colorScheme.surface
```

---

## 🚀 Implementation Priority

1. **HIGH PRIORITY** (Most visible):
   - ✅ Settings Screen (DONE)
   - 🔥 Home Screen
   - 🔥 Product Detail Screen (especially gradient fix!)
   - 🔥 All Items Screen

2. **MEDIUM PRIORITY**:
   - Add Product Screen
   - Expiring Soon Screen

3. **LOW PRIORITY**:
   - Edit Product Screen
   - Analytics Screen
   - Other minor screens

---

## ✅ Testing Checklist

After implementing:

- [ ] Settings screen in English
- [ ] Settings screen in Dark Mode
- [ ] Home screen in English
- [ ] Home screen in Dark Mode
- [ ] Product Detail in English
- [ ] Product Detail in Dark Mode (check gradient!)
- [ ] All Items in English
- [ ] All Items in Dark Mode
- [ ] Add Product in English
- [ ] Add Product in Dark Mode
- [ ] All text is readable in both modes
- [ ] No hardcoded "Colors.white" or "Colors.black" remaining
- [ ] Switch language → all screens update
- [ ] Switch theme → all colors update

---

## 💡 Quick Reference

### Get localization:
```dart
final l10n = AppLocalizations.of(context);
```

### Get theme colors:
```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

// Common colors:
colorScheme.surface        // Background for cards, etc
colorScheme.onSurface      // Text on surface
colorScheme.primary        // Primary brand color
colorScheme.onPrimary      // Text on primary
colorScheme.error          // Error color
colorScheme.onError        // Text on error
```

### Example replacement:
```dart
// Before:
Card(
  color: Colors.white,
  child: Text(
    'Trang Chủ',
    style: TextStyle(color: Colors.black),
  ),
)

// After:
Card(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    l10n.home,
    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  ),
)

// Or even better (let theme handle it):
Card(
  // No color specified - uses theme
  child: Text(l10n.home),  // Uses theme text color
)
```
