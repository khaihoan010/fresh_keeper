# Fresh Keeper - Cấu Trúc Dữ Liệu

## 📊 Tổng Quan Database

Fresh Keeper sử dụng **SQLite** cho local database và **JSON** cho product reference data.

```
Database Structure:
├── user_products (User's fridge items)
├── product_templates (Reference product data)
├── categories (Product categories)
├── notifications (Scheduled notifications)
└── settings (App settings)
```

---

## 🗃️ Database Schema

### 1. Table: `user_products`
Lưu trữ sản phẩm mà user đã thêm vào tủ lạnh.

```sql
CREATE TABLE user_products (
  id TEXT PRIMARY KEY,
  product_template_id TEXT,  -- Foreign key to product_templates
  name TEXT NOT NULL,
  name_en TEXT,
  category TEXT NOT NULL,
  quantity REAL NOT NULL,
  unit TEXT NOT NULL,
  purchase_date TEXT NOT NULL,  -- ISO 8601 format
  expiry_date TEXT NOT NULL,    -- ISO 8601 format
  notes TEXT,
  image_path TEXT,
  status TEXT DEFAULT 'active', -- active, used, expired
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (product_template_id) REFERENCES product_templates(id)
);

CREATE INDEX idx_expiry_date ON user_products(expiry_date);
CREATE INDEX idx_status ON user_products(status);
CREATE INDEX idx_category ON user_products(category);
```

**Example Data:**
```json
{
  "id": "uuid-1234-5678",
  "product_template_id": "apple_fuji",
  "name": "Táo Fuji",
  "name_en": "Fuji Apple",
  "category": "fruits",
  "quantity": 5,
  "unit": "cái",
  "purchase_date": "2025-01-20T00:00:00Z",
  "expiry_date": "2025-01-27T00:00:00Z",
  "notes": "Mua ở siêu thị",
  "image_path": "/storage/images/uuid-1234-5678.jpg",
  "status": "active",
  "created_at": "2025-01-20T10:30:00Z",
  "updated_at": "2025-01-20T10:30:00Z"
}
```

---

### 2. Table: `product_templates`
Reference data cho các sản phẩm phổ biến (built-in database).

```sql
CREATE TABLE product_templates (
  id TEXT PRIMARY KEY,
  name_vi TEXT NOT NULL,
  name_en TEXT NOT NULL,
  aliases TEXT,  -- JSON array của tên khác
  category TEXT NOT NULL,
  shelf_life_refrigerated INTEGER,  -- days
  shelf_life_frozen INTEGER,        -- days
  shelf_life_opened INTEGER,        -- days
  nutrition_data TEXT,  -- JSON
  health_benefits TEXT, -- JSON array
  health_warnings TEXT, -- JSON array
  storage_tips TEXT,
  image_url TEXT,
  search_keywords TEXT, -- For search optimization
  FOREIGN KEY (category) REFERENCES categories(id)
);

CREATE INDEX idx_name_vi ON product_templates(name_vi);
CREATE INDEX idx_category_template ON product_templates(category);
CREATE VIRTUAL TABLE product_search USING fts5(name_vi, name_en, aliases, search_keywords);
```

**Example Data:**
```json
{
  "id": "apple_fuji",
  "name_vi": "Táo Fuji",
  "name_en": "Fuji Apple",
  "aliases": ["táo", "tao", "apple", "fuji apple"],
  "category": "fruits",
  "shelf_life_refrigerated": 7,
  "shelf_life_frozen": 240,
  "shelf_life_opened": null,
  "nutrition_data": {
    "serving_size": "100g",
    "calories": 52,
    "protein": 0.3,
    "carbohydrates": 14,
    "fat": 0.2,
    "fiber": 2.4,
    "sugar": 10.3,
    "vitamins": {
      "vitamin_c": 4.6,
      "vitamin_a": 54
    },
    "minerals": {
      "potassium": 107,
      "calcium": 6,
      "iron": 0.12
    }
  },
  "health_benefits": [
    "Giàu chất xơ, tốt cho tiêu hóa",
    "Chứa vitamin C, tăng cường miễn dịch",
    "Ít calories, phù hợp giảm cân",
    "Chất chống oxy hóa cao, chống lão hóa"
  ],
  "health_warnings": [
    "Người dị ứng táo nên tránh",
    "Không nên ăn quá nhiều nếu có vấn đề dạ dày"
  ],
  "storage_tips": "Bảo quản trong ngăn rau củ của tủ lạnh. Tách riêng với chuối vì táo tạo ra khí ethylene.",
  "image_url": "assets/products/apple_fuji.jpg",
  "search_keywords": "táo fuji tao apple"
}
```

---

### 3. Table: `categories`
Danh mục sản phẩm.

```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name_vi TEXT NOT NULL,
  name_en TEXT NOT NULL,
  icon TEXT NOT NULL,
  color TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0
);
```

**Data:**
```json
[
  {
    "id": "vegetables",
    "name_vi": "Rau củ quả",
    "name_en": "Vegetables",
    "icon": "🥬",
    "color": "#4CAF50",
    "sort_order": 1
  },
  {
    "id": "fruits",
    "name_vi": "Trái cây",
    "name_en": "Fruits",
    "icon": "🍎",
    "color": "#FF5722",
    "sort_order": 2
  },
  {
    "id": "meat",
    "name_vi": "Thịt",
    "name_en": "Meat",
    "icon": "🥩",
    "color": "#E91E63",
    "sort_order": 3
  },
  {
    "id": "eggs",
    "name_vi": "Trứng",
    "name_en": "Eggs",
    "icon": "🥚",
    "color": "#FFC107",
    "sort_order": 4
  },
  {
    "id": "dairy",
    "name_vi": "Sữa & chế phẩm",
    "name_en": "Dairy",
    "icon": "🥛",
    "color": "#2196F3",
    "sort_order": 5
  },
  {
    "id": "dry_food",
    "name_vi": "Đồ khô",
    "name_en": "Dry Food",
    "icon": "🍞",
    "color": "#795548",
    "sort_order": 6
  },
  {
    "id": "frozen",
    "name_vi": "Đồ đông lạnh",
    "name_en": "Frozen",
    "icon": "🧊",
    "color": "#00BCD4",
    "sort_order": 7
  },
  {
    "id": "condiments",
    "name_vi": "Gia vị",
    "name_en": "Condiments",
    "icon": "🧂",
    "color": "#FF9800",
    "sort_order": 8
  },
  {
    "id": "other",
    "name_vi": "Khác",
    "name_en": "Other",
    "icon": "📦",
    "color": "#9E9E9E",
    "sort_order": 9
  }
]
```

---

### 4. Table: `notifications`
Scheduled notifications.

```sql
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  notification_type TEXT NOT NULL, -- reminder_3d, reminder_1d, expiry_today
  scheduled_date TEXT NOT NULL,
  is_sent INTEGER DEFAULT 0,
  created_at TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES user_products(id) ON DELETE CASCADE
);

CREATE INDEX idx_scheduled_date ON notifications(scheduled_date);
CREATE INDEX idx_is_sent ON notifications(is_sent);
```

**Example Data:**
```json
{
  "id": "notif-uuid-1234",
  "product_id": "uuid-1234-5678",
  "notification_type": "reminder_3d",
  "scheduled_date": "2025-01-24T15:00:00Z",
  "is_sent": 0,
  "created_at": "2025-01-20T10:30:00Z"
}
```

---

### 5. Table: `settings`
App settings and preferences.

```sql
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

**Example Data:**
```json
[
  {"key": "notifications_enabled", "value": "true", "updated_at": "2025-01-20T10:00:00Z"},
  {"key": "reminder_days", "value": "[7,3,1,0]", "updated_at": "2025-01-20T10:00:00Z"},
  {"key": "notification_time", "value": "15:00", "updated_at": "2025-01-20T10:00:00Z"},
  {"key": "language", "value": "vi", "updated_at": "2025-01-20T10:00:00Z"},
  {"key": "theme", "value": "light", "updated_at": "2025-01-20T10:00:00Z"},
  {"key": "onboarding_completed", "value": "false", "updated_at": "2025-01-20T10:00:00Z"}
]
```

---

## 📦 Dart Models

### 1. UserProduct Model

```dart
import 'package:uuid/uuid.dart';

enum ProductStatus { active, used, expired }

class UserProduct {
  final String id;
  final String? productTemplateId;
  final String name;
  final String? nameEn;
  final String category;
  final double quantity;
  final String unit;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String? notes;
  final String? imagePath;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProduct({
    String? id,
    this.productTemplateId,
    required this.name,
    this.nameEn,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    required this.expiryDate,
    this.notes,
    this.imagePath,
    this.status = ProductStatus.active,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Days until expiry
  int get daysUntilExpiry {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  // Is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  // Is expiring soon (within 7 days)
  bool get isExpiringSoon {
    return daysUntilExpiry <= 7 && daysUntilExpiry >= 0;
  }

  // Status color
  Color getStatusColor() {
    if (daysUntilExpiry > 7) {
      return Colors.green;
    } else if (daysUntilExpiry >= 3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // To JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_template_id': productTemplateId,
      'name': name,
      'name_en': nameEn,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'purchase_date': purchaseDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'notes': notes,
      'image_path': imagePath,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // From JSON
  factory UserProduct.fromJson(Map<String, dynamic> json) {
    return UserProduct(
      id: json['id'],
      productTemplateId: json['product_template_id'],
      name: json['name'],
      nameEn: json['name_en'],
      category: json['category'],
      quantity: json['quantity'],
      unit: json['unit'],
      purchaseDate: DateTime.parse(json['purchase_date']),
      expiryDate: DateTime.parse(json['expiry_date']),
      notes: json['notes'],
      imagePath: json['image_path'],
      status: ProductStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProductStatus.active,
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // CopyWith
  UserProduct copyWith({
    String? id,
    String? productTemplateId,
    String? name,
    String? nameEn,
    String? category,
    double? quantity,
    String? unit,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? notes,
    String? imagePath,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProduct(
      id: id ?? this.id,
      productTemplateId: productTemplateId ?? this.productTemplateId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
```

---

### 2. ProductTemplate Model

```dart
class ProductTemplate {
  final String id;
  final String nameVi;
  final String nameEn;
  final List<String> aliases;
  final String category;
  final int? shelfLifeRefrigerated;
  final int? shelfLifeFrozen;
  final int? shelfLifeOpened;
  final NutritionData? nutritionData;
  final List<String>? healthBenefits;
  final List<String>? healthWarnings;
  final String? storageTips;
  final String? imageUrl;

  ProductTemplate({
    required this.id,
    required this.nameVi,
    required this.nameEn,
    required this.aliases,
    required this.category,
    this.shelfLifeRefrigerated,
    this.shelfLifeFrozen,
    this.shelfLifeOpened,
    this.nutritionData,
    this.healthBenefits,
    this.healthWarnings,
    this.storageTips,
    this.imageUrl,
  });

  // Calculate expiry date based on purchase date
  DateTime calculateExpiryDate(DateTime purchaseDate, {bool frozen = false}) {
    int days = frozen
        ? (shelfLifeFrozen ?? 30)
        : (shelfLifeRefrigerated ?? 7);
    return purchaseDate.add(Duration(days: days));
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_vi': nameVi,
      'name_en': nameEn,
      'aliases': aliases,
      'category': category,
      'shelf_life_refrigerated': shelfLifeRefrigerated,
      'shelf_life_frozen': shelfLifeFrozen,
      'shelf_life_opened': shelfLifeOpened,
      'nutrition_data': nutritionData?.toJson(),
      'health_benefits': healthBenefits,
      'health_warnings': healthWarnings,
      'storage_tips': storageTips,
      'image_url': imageUrl,
    };
  }

  // From JSON
  factory ProductTemplate.fromJson(Map<String, dynamic> json) {
    return ProductTemplate(
      id: json['id'],
      nameVi: json['name_vi'],
      nameEn: json['name_en'],
      aliases: List<String>.from(json['aliases'] ?? []),
      category: json['category'],
      shelfLifeRefrigerated: json['shelf_life_refrigerated'],
      shelfLifeFrozen: json['shelf_life_frozen'],
      shelfLifeOpened: json['shelf_life_opened'],
      nutritionData: json['nutrition_data'] != null
          ? NutritionData.fromJson(json['nutrition_data'])
          : null,
      healthBenefits: json['health_benefits'] != null
          ? List<String>.from(json['health_benefits'])
          : null,
      healthWarnings: json['health_warnings'] != null
          ? List<String>.from(json['health_warnings'])
          : null,
      storageTips: json['storage_tips'],
      imageUrl: json['image_url'],
    );
  }
}
```

---

### 3. NutritionData Model

```dart
class NutritionData {
  final String servingSize;
  final double? calories;
  final double? protein;
  final double? carbohydrates;
  final double? fat;
  final double? fiber;
  final double? sugar;
  final Map<String, double>? vitamins;
  final Map<String, double>? minerals;

  NutritionData({
    required this.servingSize,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.fiber,
    this.sugar,
    this.vitamins,
    this.minerals,
  });

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'serving_size': servingSize,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'vitamins': vitamins,
      'minerals': minerals,
    };
  }

  // From JSON
  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      servingSize: json['serving_size'],
      calories: json['calories']?.toDouble(),
      protein: json['protein']?.toDouble(),
      carbohydrates: json['carbohydrates']?.toDouble(),
      fat: json['fat']?.toDouble(),
      fiber: json['fiber']?.toDouble(),
      sugar: json['sugar']?.toDouble(),
      vitamins: json['vitamins'] != null
          ? Map<String, double>.from(json['vitamins'])
          : null,
      minerals: json['minerals'] != null
          ? Map<String, double>.from(json['minerals'])
          : null,
    );
  }
}
```

---

### 4. Category Model

```dart
class Category {
  final String id;
  final String nameVi;
  final String nameEn;
  final String icon;
  final Color color;
  final int sortOrder;

  Category({
    required this.id,
    required this.nameVi,
    required this.nameEn,
    required this.icon,
    required this.color,
    required this.sortOrder,
  });

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_vi': nameVi,
      'name_en': nameEn,
      'icon': icon,
      'color': color.value.toRadixString(16),
      'sort_order': sortOrder,
    };
  }

  // From JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameVi: json['name_vi'],
      nameEn: json['name_en'],
      icon: json['icon'],
      color: Color(int.parse(json['color'], radix: 16)),
      sortOrder: json['sort_order'],
    );
  }
}
```

---

## 🔄 Data Flow

### Adding a Product

```
1. User selects category
2. User types product name
   ↓
3. App searches in product_templates
   - FTS5 search on name_vi, name_en, aliases
   - Return top 10 matches
   ↓
4. User selects from suggestions
   ↓
5. App auto-fills:
   - Expiry date (purchase_date + shelf_life_refrigerated)
   - Nutrition data
   - Storage tips
   ↓
6. User confirms and saves
   ↓
7. Insert into user_products
   ↓
8. Schedule notifications (3d, 1d, 0d)
   ↓
9. Update UI
```

### Loading Dashboard

```
1. Load all active products
   SELECT * FROM user_products WHERE status = 'active'
   ↓
2. Calculate stats:
   - Total count
   - Expiring soon count (expiry_date <= now + 7 days)
   - By category count
   ↓
3. Load recent products
   SELECT * FROM user_products ORDER BY created_at DESC LIMIT 5
   ↓
4. Render UI
```

### Notification Flow

```
1. Background job checks every hour
   ↓
2. Query notifications table:
   SELECT * FROM notifications
   WHERE scheduled_date <= now
   AND is_sent = 0
   ↓
3. For each notification:
   - Get product details
   - Show local notification
   - Mark is_sent = 1
   ↓
4. User taps notification
   ↓
5. App opens to product detail
```

---

## 📝 JSON Data Files

### products_database.json
Initial product templates loaded on first app launch.

```json
{
  "version": "1.0.0",
  "last_updated": "2025-01-20",
  "products": [
    {
      "id": "apple_fuji",
      "name_vi": "Táo Fuji",
      "name_en": "Fuji Apple",
      "aliases": ["táo", "tao", "apple"],
      "category": "fruits",
      "shelf_life_refrigerated": 7,
      "shelf_life_frozen": 240,
      "nutrition_data": {
        "serving_size": "100g",
        "calories": 52,
        "protein": 0.3,
        "carbohydrates": 14,
        "fat": 0.2,
        "fiber": 2.4,
        "vitamins": {"vitamin_c": 4.6},
        "minerals": {"potassium": 107}
      },
      "health_benefits": [
        "Giàu chất xơ, tốt cho tiêu hóa"
      ],
      "storage_tips": "Bảo quản trong ngăn rau củ"
    }
    // ... 500-1000 products
  ]
}
```

---

## 🔍 Search Optimization

### FTS5 Virtual Table
```sql
CREATE VIRTUAL TABLE product_search USING fts5(
  product_id UNINDEXED,
  name_vi,
  name_en,
  aliases,
  search_keywords
);

-- Populate from product_templates
INSERT INTO product_search
SELECT id, name_vi, name_en, aliases, search_keywords
FROM product_templates;
```

### Search Query
```sql
-- Search for "ta"
SELECT pt.*
FROM product_search ps
JOIN product_templates pt ON ps.product_id = pt.id
WHERE product_search MATCH 'ta*'
ORDER BY rank
LIMIT 10;
```

---

## 💾 Database Initialization

```dart
class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fresh_keeper.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute(''' ... CREATE TABLE statements ... ''');

    // Load initial data
    await _loadInitialData(db);
  }

  Future<void> _loadInitialData(Database db) async {
    // Load categories
    String categoriesJson = await rootBundle.loadString('assets/data/categories.json');
    List<dynamic> categories = json.decode(categoriesJson);

    for (var category in categories) {
      await db.insert('categories', category);
    }

    // Load product templates
    String productsJson = await rootBundle.loadString('assets/data/products_database.json');
    Map<String, dynamic> productsData = json.decode(productsJson);

    for (var product in productsData['products']) {
      await db.insert('product_templates', product);
    }
  }
}
```

---

## 📈 Data Size Estimates

### Storage Requirements
- **SQLite Database:** ~5-10 MB
  - product_templates: ~3-5 MB (1000 products with nutrition)
  - user_products: ~1 KB per item (grows with usage)
  - Other tables: < 1 MB

- **JSON Files:** ~2-5 MB
  - products_database.json: ~2-4 MB
  - categories.json: < 100 KB

- **Images:** Variable
  - Product template images: ~100-200 KB each
  - User photos: ~500 KB - 2 MB each

- **Total Initial App Size:** ~15-20 MB

### Performance Targets
- Search query: < 50ms
- Product list load: < 100ms
- Dashboard load: < 200ms
- Add product: < 500ms

---

## 🔐 Data Security & Privacy

### Local Storage Only
- All user data stored locally on device
- No server sync (MVP)
- No analytics or tracking

### Data Backup (Future)
- Export to JSON file
- Import from JSON file
- Optional cloud backup (Google Drive / iCloud)

### Data Deletion
- Clear all data option in settings
- Remove all database records
- Delete all user images
- Reset to fresh state
