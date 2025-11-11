# Fresh Keeper - Chi Tiết Tính Năng

## 📱 Cấu Trúc Màn Hình

```
Fresh Keeper App
├── Splash Screen
├── Onboarding (First time only)
├── Main Navigation
│   ├── Home (Dashboard)
│   ├── Expiring Soon (Gần hết hạn)
│   ├── Add Product (+ Button)
│   ├── All Items (Tất cả)
│   └── Settings
└── Detail Screens
    ├── Product Detail
    ├── Edit Product
    └── Nutrition Info
```

---

## 🏠 Feature 1: Home / Dashboard

### Mô Tả
Màn hình chính hiển thị tổng quan về tủ lạnh, thống kê nhanh và sản phẩm cần chú ý.

### Thành Phần UI

#### 1. Header
- Logo app nhỏ ở góc trái
- Tên người dùng hoặc "Tủ lạnh của tôi"
- Icon settings ở góc phải
- Search bar (optional)

#### 2. Quick Stats Cards
```
┌─────────────────────────────────────┐
│  📦 Tổng Sản Phẩm                   │
│  42 sản phẩm                         │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  ⚠️  Gần Hết Hạn                    │
│  5 sản phẩm cần sử dụng              │
│  [Xem ngay →]                        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  🆕 Thêm Gần Đây                    │
│  • Cà chua (Hôm nay)                 │
│  • Thịt bò (Hôm qua)                 │
│  • Táo (2 ngày trước)                │
└─────────────────────────────────────┘
```

#### 3. Quick Actions
- Button lớn: "Thêm Sản Phẩm" (Primary CTA)
- Button phụ: "Xem Tất Cả"

#### 4. Categories Overview
```
[Rau Củ: 12] [Trái Cây: 8] [Thịt: 5] [Trứng: 10]
```
- Horizontal scrollable chips
- Tap để lọc

### Tương Tác
- **Pull to refresh:** Refresh tất cả data
- **Tap stats card:** Navigate đến detail
- **Tap category chip:** Filter danh sách
- **Tap "Thêm":** Mở form thêm sản phẩm

### Logic
```dart
// Pseudo code
class DashboardLogic {
  // Load tổng số sản phẩm
  int getTotalProducts() {
    return database.getAllProducts().length;
  }

  // Load sản phẩm gần hết hạn (< 7 ngày)
  List<Product> getExpiringSoon() {
    return database.getProductsExpiringSoon(days: 7);
  }

  // Load sản phẩm thêm gần đây (3 ngày)
  List<Product> getRecentlyAdded() {
    return database.getRecentProducts(days: 3);
  }

  // Thống kê theo category
  Map<String, int> getCategoryStats() {
    // Return {category: count}
  }
}
```

---

## ➕ Feature 2: Add Product (Thêm Sản Phẩm)

### Mô Tả
Form để thêm sản phẩm mới với tìm kiếm thông minh và tự động điền thông tin.

### Thành Phần UI

#### 1. Header
- Title: "Thêm Sản Phẩm Mới"
- Back button
- Close button (X)

#### 2. Form Fields

```
┌─────────────────────────────────────┐
│  1. PHÂN LOẠI *                      │
│  [Dropdown: Chọn loại thực phẩm ▼]  │
│                                      │
│  Options:                            │
│  • 🥬 Rau củ quả                     │
│  • 🍎 Trái cây                       │
│  • 🥩 Thịt                           │
│  • 🥚 Trứng                          │
│  • 🥛 Sữa & chế phẩm từ sữa          │
│  • 🍞 Đồ khô                         │
│  • 🧊 Đồ đông lạnh                   │
│  • 🧂 Gia vị                         │
│  • 📦 Khác                           │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  2. TÊN SẢN PHẨM *                   │
│  [🔍 Tìm kiếm hoặc nhập tên...]     │
│                                      │
│  --- Gợi ý khi gõ "ta" ---          │
│  ┌─────────────────────────────┐    │
│  │ 🍎 Táo (Apple)              │    │
│  │ 🌊 Tảo biển (Seaweed)       │    │
│  │ 🍐 Tá lá (Pear - Asian)    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  3. SỐ LƯỢNG *                       │
│  [- ] 1 [ + ]                        │
│  Unit: [Cái ▼]                       │
│  (Cái, Kg, Gram, Lít, Gói...)       │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  4. NGÀY MUA / CHO VÀO TỦ LẠNH *     │
│  [📅 20/01/2025]                     │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  5. NGÀY HẾT HẠN (Đề xuất) *         │
│  [📅 25/01/2025]                     │
│  💡 Đề xuất: 5 ngày (có thể chỉnh)  │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  6. GHI CHÚ (Tùy chọn)               │
│  [Mua ở siêu thị...]                 │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  7. HÌNH ẢNH (Tùy chọn)              │
│  [📷 Chụp ảnh] [🖼️ Chọn từ thư viện] │
└─────────────────────────────────────┘
```

#### 3. Action Buttons
- **Primary Button:** "Thêm Sản Phẩm" (Full width, prominent)
- **Secondary Button:** "Hủy"

### Tương Tác

#### Search Flow
1. User chọn category
2. User bắt đầu gõ tên sản phẩm
3. Sau 2 ký tự → trigger search
4. Hiển thị dropdown với 5-10 gợi ý
5. User chọn từ gợi ý hoặc tiếp tục gõ
6. Khi chọn gợi ý → tự động điền:
   - Expiry date (dựa trên shelf life)
   - Nutrition info
   - Storage tips

#### Validation
- Category: Required
- Product name: Required, min 2 chars
- Quantity: Required, > 0
- Purchase date: Required, <= today
- Expiry date: Required, >= purchase date

### Logic

```dart
class AddProductLogic {
  // Tìm kiếm sản phẩm
  Future<List<Product>> searchProducts(String query) async {
    // Search trong local database
    List<Product> localResults = await database.searchProducts(query);

    // Nếu có kết quả, return
    if (localResults.isNotEmpty) {
      return localResults;
    }

    // Nếu không, search trong API (nếu có)
    List<Product> apiResults = await api.searchProducts(query);
    return apiResults;
  }

  // Tự động điền expiry date
  DateTime calculateExpiryDate(Product product, DateTime purchaseDate) {
    int shelfLifeDays = product.shelfLife.refrigeratedDays;
    return purchaseDate.add(Duration(days: shelfLifeDays));
  }

  // Lưu sản phẩm
  Future<void> saveProduct(Product product) async {
    await database.insertProduct(product);

    // Schedule notification
    notificationService.scheduleExpiryNotifications(product);
  }
}
```

### Edge Cases
- Không tìm thấy sản phẩm → Cho phép nhập custom
- Sản phẩm custom → Không có thông tin dinh dưỡng
- Offline → Chỉ search trong local database
- Duplicate → Warning nhưng vẫn cho phép thêm

---

## 📋 Feature 3: All Items (Danh Sách Tất Cả)

### Mô Tả
Hiển thị tất cả sản phẩm với khả năng filter, sort và search.

### Thành Phần UI

#### 1. Header
- Title: "Tất Cả Sản Phẩm"
- Search bar
- Filter button
- Sort button

#### 2. Filter Bar (Horizontal scroll)
```
[Tất cả] [Rau củ: 12] [Trái cây: 8] [Thịt: 5] ...
```

#### 3. Sort Options (Bottom sheet)
```
Sắp xếp theo:
○ Gần hết hạn nhất (Mặc định)
○ Tên A-Z
○ Tên Z-A
○ Mới thêm nhất
○ Cũ nhất
```

#### 4. List View (Scrollable)
```
┌─────────────────────────────────────┐
│ 🍎 Táo                         🟢   │
│ Trái cây • Còn 10 ngày              │
│ Số lượng: 5 cái                      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🥬 Rau cải                     🟡   │
│ Rau củ • Còn 5 ngày                 │
│ Số lượng: 1 bó                       │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🥩 Thịt bò                     🔴   │
│ Thịt • Còn 2 ngày                   │
│ Số lượng: 500g                       │
└─────────────────────────────────────┘
```

#### 5. Item Actions (Swipe hoặc Long Press)
```
[Chỉnh sửa] [Đã dùng] [Xóa]
```

#### 6. Empty State
```
┌─────────────────────────────────────┐
│         📦                          │
│                                      │
│   Chưa có sản phẩm nào               │
│                                      │
│   Thêm sản phẩm đầu tiên của bạn    │
│   để bắt đầu quản lý tủ lạnh        │
│                                      │
│   [+ Thêm Sản Phẩm]                 │
└─────────────────────────────────────┘
```

### Tương Tác
- **Tap item:** Xem chi tiết
- **Swipe left:** Hiện actions (Edit, Done, Delete)
- **Pull to refresh:** Refresh list
- **Tap filter chip:** Filter theo category
- **Tap sort:** Show sort options

### Logic

```dart
class AllItemsLogic {
  List<Product> products = [];
  String selectedCategory = 'all';
  SortOption sortBy = SortOption.expiryDate;

  // Load products
  Future<void> loadProducts() async {
    products = await database.getAllProducts();
    applyFilterAndSort();
  }

  // Filter
  void filterByCategory(String category) {
    selectedCategory = category;
    applyFilterAndSort();
  }

  // Sort
  void sortProducts(SortOption option) {
    sortBy = option;
    applyFilterAndSort();
  }

  // Apply filter and sort
  void applyFilterAndSort() {
    var filtered = products;

    // Filter
    if (selectedCategory != 'all') {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }

    // Sort
    switch (sortBy) {
      case SortOption.expiryDate:
        filtered.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
      case SortOption.nameAZ:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      // ... other cases
    }

    notifyListeners();
  }

  // Delete product
  Future<void> deleteProduct(Product product) async {
    await database.deleteProduct(product.id);
    notificationService.cancelNotifications(product.id);
    loadProducts();
  }

  // Mark as used
  Future<void> markAsUsed(Product product) async {
    product.status = ProductStatus.used;
    await database.updateProduct(product);
    loadProducts();
  }
}
```

### Color Coding Logic
```dart
Color getStatusColor(Product product) {
  int daysUntilExpiry = product.expiryDate.difference(DateTime.now()).inDays;

  if (daysUntilExpiry > 7) {
    return Colors.green;      // 🟢 Xanh
  } else if (daysUntilExpiry >= 3) {
    return Colors.orange;     // 🟡 Vàng
  } else {
    return Colors.red;        // 🔴 Đỏ
  }
}
```

---

## ⚠️ Feature 4: Expiring Soon (Gần Hết Hạn)

### Mô Tả
Tab riêng hiển thị sản phẩm gần hết hạn, sắp xếp theo độ ưu tiên.

### Thành Phần UI

#### 1. Header
- Title: "Gần Hết Hạn"
- Badge số lượng: (5)
- Info icon: Giải thích tiêu chí

#### 2. Alert Banner (nếu có sản phẩm đỏ)
```
┌─────────────────────────────────────┐
│ ⚠️  CẦN DÙNG NGAY!                  │
│ 3 sản phẩm còn dưới 3 ngày          │
└─────────────────────────────────────┘
```

#### 3. List View (Grouped by urgency)
```
--- HÔM NAY / QUÁ HẠN ---
┌─────────────────────────────────────┐
│ 🥩 Thịt bò                     🔴   │
│ Hết hạn hôm nay!                     │
│ [Đã dùng] [Chi tiết]                │
└─────────────────────────────────────┘

--- 1-3 NGÀY TỚI ---
┌─────────────────────────────────────┐
│ 🥬 Rau cải                     🔴   │
│ Còn 2 ngày                           │
│ [Đã dùng] [Chi tiết]                │
└─────────────────────────────────────┘

--- 4-7 NGÀY TỚI ---
┌─────────────────────────────────────┐
│ 🍎 Táo                         🟡   │
│ Còn 5 ngày                           │
│ [Đã dùng] [Chi tiết]                │
└─────────────────────────────────────┘
```

#### 4. Empty State
```
┌─────────────────────────────────────┐
│         ✅                          │
│                                      │
│   Tuyệt vời!                         │
│   Không có sản phẩm nào gần hết hạn │
│                                      │
└─────────────────────────────────────┘
```

### Tương Tác
- **Tap "Đã dùng":** Mark as used, remove from list
- **Tap "Chi tiết":** View product detail
- **Pull to refresh:** Refresh urgency status

### Logic

```dart
class ExpiringSoonLogic {
  // Get products expiring within 7 days
  Future<List<Product>> getExpiringSoon() async {
    DateTime now = DateTime.now();
    DateTime cutoff = now.add(Duration(days: 7));

    List<Product> products = await database.getProductsByExpiry(
      start: now,
      end: cutoff,
    );

    // Sort by expiry date (urgent first)
    products.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    return products;
  }

  // Group by urgency
  Map<String, List<Product>> groupByUrgency(List<Product> products) {
    Map<String, List<Product>> grouped = {
      'today': [],
      'next3days': [],
      'next7days': [],
    };

    DateTime now = DateTime.now();

    for (var product in products) {
      int daysUntil = product.expiryDate.difference(now).inDays;

      if (daysUntil <= 0) {
        grouped['today']!.add(product);
      } else if (daysUntil <= 3) {
        grouped['next3days']!.add(product);
      } else {
        grouped['next7days']!.add(product);
      }
    }

    return grouped;
  }
}
```

---

## 📝 Feature 5: Product Detail (Chi Tiết Sản Phẩm)

### Mô Tả
Màn hình chi tiết hiển thị đầy đủ thông tin về sản phẩm, bao gồm dinh dưỡng và lợi ích sức khỏe.

### Thành Phần UI

#### 1. Header
- Back button
- Product image (nếu có)
- Product name
- Status badge (Xanh/Vàng/Đỏ)
- Edit button (icon)

#### 2. Tab Navigation
```
[Thông Tin] [Dinh Dưỡng] [Sức Khỏe]
```

#### Tab 1: Thông Tin Cơ Bản
```
┌─────────────────────────────────────┐
│  📦 Thông Tin Sản Phẩm               │
│  ────────────────────────────────    │
│  Loại: Trái cây                      │
│  Số lượng: 5 cái                     │
│  Ngày mua: 20/01/2025                │
│  Hết hạn: 25/01/2025                 │
│  Còn lại: 5 ngày                     │
│  Ghi chú: Mua ở siêu thị             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  💾 Bảo Quản                         │
│  ────────────────────────────────    │
│  Ngăn mát: 5-7 ngày                  │
│  Ngăn đông: 8-12 tháng               │
│  Sau khi mở: 3 ngày                  │
│                                      │
│  💡 Mẹo: Bảo quản trong ngăn rau     │
│     củ để giữ độ tươi                │
└─────────────────────────────────────┘
```

#### Tab 2: Dinh Dưỡng
```
┌─────────────────────────────────────┐
│  🍎 Giá Trị Dinh Dưỡng (100g)        │
│  ────────────────────────────────    │
│                                      │
│  Calories:        52 kcal            │
│  ████░░░░░░ (3% DV)                  │
│                                      │
│  Protein:         0.3g               │
│  █░░░░░░░░░ (1% DV)                  │
│                                      │
│  Carbs:           14g                │
│  ████░░░░░░ (5% DV)                  │
│                                      │
│  Fat:             0.2g               │
│  █░░░░░░░░░ (0% DV)                  │
│                                      │
│  Fiber:           2.4g               │
│  ████████░░ (10% DV)                 │
│                                      │
│  ────────────────────────────────    │
│                                      │
│  Vitamin C:       14% DV             │
│  Vitamin A:       1% DV              │
│  Kali:            3% DV              │
│  Calcium:         1% DV              │
│                                      │
└─────────────────────────────────────┘
```

#### Tab 3: Sức Khỏe
```
┌─────────────────────────────────────┐
│  ✅ Lợi Ích Sức Khỏe                 │
│  ────────────────────────────────    │
│  • Giàu chất xơ, tốt cho tiêu hóa   │
│  • Chứa vitamin C, tăng cường        │
│    miễn dịch                         │
│  • Ít calories, phù hợp giảm cân    │
│  • Antioxidant cao, chống lão hóa   │
│                                      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  ⚠️  Lưu Ý                           │
│  ────────────────────────────────    │
│  • Người dị ứng táo nên tránh       │
│  • Không nên ăn nhiều nếu có         │
│    vấn đề về dạ dày                  │
│  • Nên rửa sạch trước khi ăn        │
│                                      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  🏷️ Phù Hợp Cho                      │
│  ────────────────────────────────    │
│  ✓ Người giảm cân                    │
│  ✓ Người tiểu đường (ít lượng)      │
│  ✓ Trẻ em                            │
│  ✓ Phụ nữ mang thai                  │
│                                      │
└─────────────────────────────────────┘
```

#### Action Buttons (Bottom)
```
[Chỉnh Sửa] [Đã Sử Dụng] [Xóa]
```

### Tương Tác
- **Swipe left/right:** Switch tabs
- **Tap Edit:** Navigate to edit screen
- **Tap "Đã sử dụng":** Confirmation → Mark as used
- **Tap "Xóa":** Confirmation → Delete product

---

## 🔔 Feature 6: Notifications (Thông Báo)

### Mô Tả
Local push notifications để nhắc nhở người dùng về sản phẩm gần hết hạn.

### Notification Types

#### 1. Reminder 3 Days Before
```
┌─────────────────────────────────────┐
│ Fresh Keeper                         │
│ Sắp hết hạn!                         │
│                                      │
│ Táo sẽ hết hạn trong 3 ngày.         │
│ Hãy sử dụng sớm nhé!                 │
│                                      │
│ 15:00                                │
└─────────────────────────────────────┘
```

#### 2. Reminder 1 Day Before
```
┌─────────────────────────────────────┐
│ Fresh Keeper                         │
│ Gần hết hạn!                         │
│                                      │
│ Thịt bò sẽ hết hạn vào ngày mai.     │
│ Đừng quên sử dụng!                   │
│                                      │
│ 10:00                                │
└─────────────────────────────────────┘
```

#### 3. Expiry Day
```
┌─────────────────────────────────────┐
│ Fresh Keeper                         │
│ ⚠️ Hết hạn hôm nay!                  │
│                                      │
│ Rau cải hết hạn hôm nay.             │
│ Hãy kiểm tra và sử dụng ngay!        │
│                                      │
│ 08:00                                │
└─────────────────────────────────────┘
```

#### 4. Multiple Items
```
┌─────────────────────────────────────┐
│ Fresh Keeper                         │
│ 3 sản phẩm cần chú ý!                │
│                                      │
│ Bạn có 3 sản phẩm sắp hết hạn.       │
│ Tap để xem chi tiết.                 │
│                                      │
│ 09:00                                │
└─────────────────────────────────────┘
```

### Notification Settings
```
┌─────────────────────────────────────┐
│  🔔 Cài Đặt Thông Báo                │
│  ────────────────────────────────    │
│                                      │
│  Bật thông báo       [Toggle: ON]   │
│                                      │
│  ────────────────────────────────    │
│                                      │
│  Nhắc trước:                         │
│  ☑ 7 ngày trước                      │
│  ☑ 3 ngày trước                      │
│  ☑ 1 ngày trước                      │
│  ☑ Ngày hết hạn                      │
│                                      │
│  ────────────────────────────────    │
│                                      │
│  Thời gian nhận:                     │
│  ○ Buổi sáng (8:00)                  │
│  ● Buổi trưa (12:00)                 │
│  ○ Buổi chiều (17:00)                │
│  ○ Buổi tối (20:00)                  │
│  ○ Tùy chỉnh: [Chọn giờ]            │
│                                      │
│  ────────────────────────────────    │
│                                      │
│  [Lưu Cài Đặt]                       │
│                                      │
└─────────────────────────────────────┘
```

### Logic

```dart
class NotificationService {
  // Schedule notifications for a product
  Future<void> scheduleExpiryNotifications(Product product) async {
    DateTime expiryDate = product.expiryDate;

    // Cancel existing notifications for this product
    await cancelNotifications(product.id);

    // Schedule 3-day reminder
    DateTime remind3Days = expiryDate.subtract(Duration(days: 3));
    if (remind3Days.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: '${product.id}_3d',
        title: 'Sắp hết hạn!',
        body: '${product.name} sẽ hết hạn trong 3 ngày.',
        scheduledDate: remind3Days,
      );
    }

    // Schedule 1-day reminder
    DateTime remind1Day = expiryDate.subtract(Duration(days: 1));
    if (remind1Day.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: '${product.id}_1d',
        title: 'Gần hết hạn!',
        body: '${product.name} sẽ hết hạn vào ngày mai.',
        scheduledDate: remind1Day,
      );
    }

    // Schedule expiry day
    if (expiryDate.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: '${product.id}_0d',
        title: '⚠️ Hết hạn hôm nay!',
        body: '${product.name} hết hạn hôm nay.',
        scheduledDate: expiryDate,
      );
    }
  }

  // Daily check for multiple items
  Future<void> scheduleDailyCheck() async {
    // Every day at 9:00 AM
    await scheduleNotification(
      id: 'daily_check',
      title: 'Fresh Keeper',
      body: 'Kiểm tra tủ lạnh của bạn!',
      scheduledDate: DateTime.now().add(Duration(days: 1)).copyWith(hour: 9),
      repeat: true,
    );
  }
}
```

---

## ⚙️ Feature 7: Settings (Cài Đặt)

### Mô Tả
Màn hình cài đặt cho phép người dùng tùy chỉnh app.

### Menu Structure
```
┌─────────────────────────────────────┐
│  ⚙️ CÀI ĐẶT                          │
│                                      │
│  👤 NGƯỜI DÙNG                       │
│  ├─ Tên hiển thị                     │
│  └─ Ảnh đại diện                     │
│                                      │
│  🔔 THÔNG BÁO                        │
│  ├─ Bật/tắt thông báo                │
│  ├─ Nhắc trước (ngày)                │
│  └─ Thời gian nhận                   │
│                                      │
│  🎨 GIAO DIỆN                        │
│  ├─ Theme (Sáng/Tối/Auto)           │
│  ├─ Màu chủ đạo                      │
│  └─ Kích thước chữ                   │
│                                      │
│  🌐 NGÔN NGỮ                         │
│  └─ Tiếng Việt / English             │
│                                      │
│  💾 DỮ LIỆU                          │
│  ├─ Backup                           │
│  ├─ Restore                          │
│  └─ Xóa tất cả dữ liệu              │
│                                      │
│  ℹ️ THÔNG TIN                        │
│  ├─ Phiên bản: 1.0.0                │
│  ├─ Privacy Policy                   │
│  ├─ Terms of Service                 │
│  ├─ Liên hệ / Góp ý                  │
│  └─ Đánh giá ứng dụng               │
│                                      │
└─────────────────────────────────────┘
```

---

## 🎨 Feature 8: Onboarding

### Mô Tả
Giới thiệu app cho người dùng mới lần đầu sử dụng.

### Screens (4 screens)

#### Screen 1: Welcome
```
┌─────────────────────────────────────┐
│                                      │
│         🧊                          │
│      [Illustration]                  │
│                                      │
│    Chào mừng đến với                 │
│      Fresh Keeper!                   │
│                                      │
│  Quản lý tủ lạnh thông minh,        │
│  giảm lãng phí thực phẩm             │
│                                      │
│                                      │
│  ●○○○               [Tiếp theo →]   │
└─────────────────────────────────────┘
```

#### Screen 2: Add Products
```
┌─────────────────────────────────────┐
│                                      │
│         📱                          │
│      [Illustration]                  │
│                                      │
│    Thêm sản phẩm dễ dàng             │
│                                      │
│  Tìm kiếm thông minh với gợi ý      │
│  tự động điền thông tin              │
│                                      │
│                                      │
│  ○●○○   [← Quay lại] [Tiếp theo →] │
└─────────────────────────────────────┘
```

#### Screen 3: Get Notified
```
┌─────────────────────────────────────┐
│                                      │
│         🔔                          │
│      [Illustration]                  │
│                                      │
│   Nhận thông báo kịp thời            │
│                                      │
│  Được nhắc nhở trước khi thực phẩm  │
│  hết hạn                             │
│                                      │
│                                      │
│  ○○●○   [← Quay lại] [Tiếp theo →] │
└─────────────────────────────────────┘
```

#### Screen 4: Nutrition Info
```
┌─────────────────────────────────────┐
│                                      │
│         🥗                          │
│      [Illustration]                  │
│                                      │
│  Tìm hiểu dinh dưỡng                 │
│                                      │
│  Xem thông tin dinh dưỡng và        │
│  lợi ích sức khỏe của mỗi thực phẩm │
│                                      │
│                                      │
│  ○○○●   [← Quay lại] [Bắt đầu! ✓]  │
└─────────────────────────────────────┘
```

---

## 📊 Feature Priority Summary

### Phase 1 - MVP (Must Have)
1. ✅ Add Product với search
2. ✅ All Items list với color coding
3. ✅ Product Detail với nutrition
4. ✅ Expiring Soon list
5. ✅ Local Notifications
6. ✅ Basic Dashboard
7. ✅ Settings (notification only)

### Phase 2 - Enhancement
1. 📊 Advanced Dashboard với charts
2. 🎨 Full Settings (theme, language)
3. 📸 Camera integration
4. 🔍 Barcode scanner
5. 📖 Onboarding screens
6. 🌙 Dark mode

### Phase 3 - Advanced
1. 🍳 Recipe suggestions
2. ☁️ Cloud backup
3. 📊 Analytics & insights
4. 🛒 Shopping list
5. 👥 Family sharing
