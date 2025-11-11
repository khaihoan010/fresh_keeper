# Fresh Keeper - Development Prompts

> **Hướng dẫn:** File này chứa tất cả prompts để code từng module của ứng dụng Fresh Keeper. Copy từng prompt và sử dụng với AI assistant để implement code.

---

## 📋 Table of Contents

1. [Setup Project](#1-setup-project)
2. [Database Layer](#2-database-layer)
3. [Data Models](#3-data-models)
4. [Repositories](#4-repositories)
5. [State Management](#5-state-management)
6. [UI Screens](#6-ui-screens)
7. [Widgets](#7-widgets)
8. [Services](#8-services)
9. [Localization](#9-localization)
10. [Testing](#10-testing)

---

## 1. SETUP PROJECT

### Prompt 1.1: Initialize Project & Dependencies

```
Tôi đang xây dựng ứng dụng Flutter "Fresh Keeper" để quản lý thực phẩm trong tủ lạnh.

Yêu cầu:
1. Cập nhật file pubspec.yaml với các dependencies sau:
   - provider: ^6.1.1 (state management)
   - sqflite: ^2.3.0 (database)
   - path_provider: ^2.1.1
   - path: ^1.8.3
   - flutter_local_notifications: ^16.3.0
   - timezone: ^0.9.2
   - intl: ^0.19.0
   - uuid: ^4.2.2
   - image_picker: ^1.0.5
   - cached_network_image: ^3.3.1
   - shimmer: ^3.0.0
   - flutter_slidable: ^3.0.1
   - smooth_page_indicator: ^1.1.0

2. Tạo cấu trúc thư mục như sau:
```
lib/
├── config/
│   ├── theme.dart
│   ├── routes.dart
│   └── constants.dart
├── core/
│   ├── utils/
│   └── extensions/
├── data/
│   ├── models/
│   ├── repositories/
│   └── data_sources/
├── domain/
│   ├── entities/
│   └── use_cases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── services/
```

3. Tạo file main.dart cơ bản với:
   - MaterialApp setup
   - Theme configuration (màu primary: #7DDDC9)
   - Provider setup
   - Navigation setup

Vui lòng tạo đầy đủ code cho các file này.
```

---

### Prompt 1.2: Theme Configuration

```
Tạo file lib/config/theme.dart cho Fresh Keeper app với yêu cầu:

Design System:
- Primary Color: #7DDDC9 (Mint Green)
- Secondary Color: #FFB6C1 (Pink)
- Accent Color: #FF6B6B (Coral Red)
- Success: #4CAF50
- Warning: #FF9800
- Error: #F44336
- Background: #FFFFFF và #FFFEF7

Typography:
- Title: 24-28pt Bold
- Subtitle: 18-20pt Medium
- Body: 14-16pt Regular
- Caption: 12pt Light

Components:
- Card border radius: 12pt
- Button border radius: 8pt
- Button height: 48pt
- Shadows: elevation 2, 4, 6, 8

Tạo cả Light Theme. Dark theme để sau.

Include:
- ThemeData configuration
- TextTheme
- ColorScheme
- ButtonTheme
- CardTheme
- InputDecorationTheme
```

---

### Prompt 1.3: Constants & Routes

```
Tạo 2 files:

1. lib/config/constants.dart với:
   - App name, version
   - Database name, version
   - Notification channel IDs
   - Storage keys
   - Default values
   - API endpoints (để sau)

2. lib/config/routes.dart với:
   - Named routes cho tất cả screens:
     - '/' : SplashScreen
     - '/onboarding' : OnboardingScreen
     - '/home' : HomeScreen
     - '/add_product' : AddProductScreen
     - '/all_items' : AllItemsScreen
     - '/expiring_soon' : ExpiringSoonScreen
     - '/product_detail' : ProductDetailScreen
     - '/settings' : SettingsScreen
   - Route generator function
   - Route transitions (slide, fade)

Sử dụng MaterialPageRoute hoặc custom PageRoute.
```

---

## 2. DATABASE LAYER

### Prompt 2.1: Database Helper

```
Tạo file lib/services/database_service.dart - singleton class để quản lý SQLite database.

Requirements:
1. Database name: 'fresh_keeper.db'
2. Version: 1
3. Tables:
   - user_products
   - product_templates
   - categories
   - notifications
   - settings

4. Implement:
   - Singleton pattern
   - Database initialization
   - Create tables
   - Upgrade logic
   - FTS5 virtual table cho search
   - Load initial data từ JSON (assets/data/)

5. Tables schema theo file DATA_STRUCTURE.md

6. Methods:
   - Future<Database> get database
   - _initDatabase()
   - _onCreate(Database db, int version)
   - _onUpgrade(Database db, int oldVersion, int newVersion)
   - _loadInitialData(Database db)

Include error handling và logging.
```

---

### Prompt 2.2: Product Local Data Source

```
Tạo file lib/data/data_sources/local/product_local_data_source.dart

Class: ProductLocalDataSource

Methods cần implement:
1. CRUD Operations:
   - Future<int> insertProduct(UserProduct product)
   - Future<UserProduct?> getProductById(String id)
   - Future<List<UserProduct>> getAllProducts()
   - Future<int> updateProduct(UserProduct product)
   - Future<int> deleteProduct(String id)

2. Queries:
   - Future<List<UserProduct>> getProductsByCategory(String category)
   - Future<List<UserProduct>> getProductsByStatus(ProductStatus status)
   - Future<List<UserProduct>> getExpiringSoon(int days)
   - Future<List<UserProduct>> getRecentProducts(int days)
   - Future<List<UserProduct>> searchProducts(String query)

3. Templates:
   - Future<List<ProductTemplate>> searchTemplates(String query)
   - Future<ProductTemplate?> getTemplateById(String id)

4. Stats:
   - Future<int> getTotalCount()
   - Future<int> getExpiringSoonCount(int days)
   - Future<Map<String, int>> getCountByCategory()

Sử dụng DatabaseService để lấy database instance.
Include error handling và null safety.
```

---

## 3. DATA MODELS

### Prompt 3.1: Core Models

```
Tạo các model classes trong lib/data/models/:

1. user_product.dart:
   - Class UserProduct với tất cả fields theo DATA_STRUCTURE.md
   - Getters: daysUntilExpiry, isExpired, isExpiringSoon, getStatusColor()
   - toJson(), fromJson()
   - copyWith()
   - Enums: ProductStatus (active, used, expired)

2. product_template.dart:
   - Class ProductTemplate
   - Fields: id, nameVi, nameEn, aliases, category, shelf life, nutrition, etc.
   - Method: calculateExpiryDate(DateTime purchaseDate)
   - toJson(), fromJson()

3. nutrition_data.dart:
   - Class NutritionData
   - Fields: servingSize, calories, protein, carbs, fat, fiber, vitamins, minerals
   - toJson(), fromJson()

4. category.dart:
   - Class Category
   - Fields: id, nameVi, nameEn, icon (emoji), color
   - toJson(), fromJson()

Tất cả models phải:
- Immutable (final fields)
- Null safety
- JSON serialization
- Equatable (optional, for testing)
```

---

### Prompt 3.2: Extensions

```
Tạo các extension files trong lib/core/extensions/:

1. datetime_extension.dart:
   - extension DateTimeExtension on DateTime
   - String toFormattedString() - format "dd/MM/yyyy"
   - String toRelativeString() - "Hôm nay", "Hôm qua", "2 ngày trước"
   - bool isToday()
   - bool isSameDay(DateTime other)
   - DateTime startOfDay()
   - DateTime endOfDay()

2. string_extension.dart:
   - extension StringExtension on String
   - String removeVietnameseTones() - for search
   - String capitalize()
   - bool containsIgnoreCase(String other)
   - bool matchesSearch(String query)

3. color_extension.dart:
   - extension ColorExtension on Color
   - String toHexString()
   - Color darken([double amount = 0.1])
   - Color lighten([double amount = 0.1])

Các extensions này sẽ được dùng nhiều trong app.
```

---

## 4. REPOSITORIES

### Prompt 4.1: Product Repository

```
Tạo file lib/data/repositories/product_repository.dart

Class: ProductRepository
Pattern: Repository pattern để abstract data sources

Constructor:
- ProductRepository(ProductLocalDataSource localDataSource)

Methods:
1. CRUD:
   - Future<Result<int>> addProduct(UserProduct product)
   - Future<Result<UserProduct>> getProduct(String id)
   - Future<Result<List<UserProduct>>> getAllProducts()
   - Future<Result<int>> updateProduct(UserProduct product)
   - Future<Result<int>> deleteProduct(String id)

2. Queries:
   - Future<Result<List<UserProduct>>> getExpiringSoon(int days)
   - Future<Result<List<UserProduct>>> searchProducts(String query)
   - Future<Result<List<ProductTemplate>>> searchTemplates(String query)

3. Stats:
   - Future<Result<DashboardStats>> getDashboardStats()

Result type:
```dart
class Result<T> {
  final T? data;
  final String? error;
  bool get isSuccess => error == null;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
}
```

Include error handling và logging.
```

---

## 5. STATE MANAGEMENT

### Prompt 5.1: Product Provider

```
Tạo file lib/presentation/providers/product_provider.dart sử dụng Provider package.

Class: ProductProvider extends ChangeNotifier

State variables:
- List<UserProduct> _products
- List<UserProduct> _expiringSoon
- List<UserProduct> _recentProducts
- bool _isLoading
- String? _error
- String _selectedCategory = 'all'
- SortOption _sortBy

Getters:
- List<UserProduct> get products
- List<UserProduct> get expiringSoon
- List<UserProduct> get filteredProducts (apply category filter & sort)
- int get totalCount
- int get expiringSoonCount
- Map<String, int> get categoryStats

Methods:
1. Load data:
   - Future<void> loadProducts()
   - Future<void> loadExpiringSoon()
   - Future<void> loadRecentProducts()
   - Future<void> loadDashboard()

2. CRUD:
   - Future<bool> addProduct(UserProduct product)
   - Future<bool> updateProduct(UserProduct product)
   - Future<bool> deleteProduct(String id)
   - Future<bool> markAsUsed(String id)

3. Filter & Sort:
   - void setCategory(String category)
   - void setSortOption(SortOption option)
   - void sortProducts()

4. Search:
   - Future<List<ProductTemplate>> searchTemplates(String query)

Include:
- Error handling
- Loading states
- notifyListeners() calls
- Try-catch blocks
```

---

### Prompt 5.2: Notification Provider

```
Tạo file lib/presentation/providers/notification_provider.dart

Class: NotificationProvider extends ChangeNotifier

State:
- bool _notificationsEnabled
- List<int> _reminderDays (e.g., [7, 3, 1, 0])
- TimeOfDay _notificationTime
- String _soundOption

Getters & Setters:
- bool get notificationsEnabled
- set notificationsEnabled(bool value)
- List<int> get reminderDays
- TimeOfDay get notificationTime

Methods:
- Future<void> loadSettings()
- Future<void> saveSettings()
- Future<void> toggleNotifications(bool value)
- Future<void> updateReminderDays(List<int> days)
- Future<void> updateNotificationTime(TimeOfDay time)
- Future<void> testNotification()

Integrate với SharedPreferences để lưu settings.
```

---

### Prompt 5.3: Settings Provider

```
Tạo file lib/presentation/providers/settings_provider.dart

Class: SettingsProvider extends ChangeNotifier

State:
- String _language ('vi' hoặc 'en')
- ThemeMode _themeMode
- bool _onboardingCompleted
- String _userName
- String? _userAvatar

Methods:
- Future<void> loadSettings()
- Future<void> saveSettings()
- Future<void> setLanguage(String lang)
- Future<void> setThemeMode(ThemeMode mode)
- Future<void> completeOnboarding()
- Future<void> updateUserProfile(String name, String? avatar)
- Future<void> clearAllData() // Reset app

Sử dụng SharedPreferences.
```

---

## 6. UI SCREENS

### Prompt 6.1: Splash Screen

```
Tạo file lib/presentation/screens/splash/splash_screen.dart

Requirements:
- Hiển thị logo Fresh Keeper (🧊)
- App name và tagline
- Loading indicator
- Gradient background (mint → white)
- Check onboarding status
- Navigate to Onboarding hoặc Home sau 2 giây

Animated:
- Fade in logo
- Slide up text
- Pulsing loading indicator

Sử dụng:
- Future.delayed() cho timing
- Navigator.pushReplacementNamed() cho navigation
- SettingsProvider để check onboarding
```

---

### Prompt 6.2: Onboarding Screens

```
Tạo file lib/presentation/screens/onboarding/onboarding_screen.dart

Requirements:
- PageView với 4 screens
- Smooth page indicator (dots)
- Skip button (ở góc phải trên)
- Next/Back buttons
- "Bắt đầu" button ở screen cuối

4 Screens theo WIREFRAMES.md:
1. Welcome - giới thiệu app
2. Add Products - tính năng thêm sản phẩm
3. Notifications - nhận thông báo
4. Nutrition - xem dinh dưỡng

Each screen có:
- Illustration (dùng Icon/Emoji lớn làm placeholder)
- Title (H2, bold)
- Description (Body text)

Sau khi hoàn thành:
- Lưu onboarding_completed = true
- Navigate to Home

Sử dụng:
- PageView.builder
- smooth_page_indicator package
- SettingsProvider
```

---

### Prompt 6.3: Home Screen (Dashboard)

```
Tạo file lib/presentation/screens/home/home_screen.dart

Layout theo WIREFRAMES.md:
1. AppBar:
   - Logo + title
   - Search icon (optional)
   - Settings icon

2. Search bar (optional để phase 2)

3. Stats Cards:
   - Total products card
   - Expiring soon card (with warning badge)
   - Recently added card

4. Category chips (horizontal scroll)

5. Primary CTA button "Thêm Sản Phẩm"

6. Bottom Navigation Bar (dùng widget riêng)

State Management:
- Use ProductProvider
- Consumer/Selector cho rebuild optimization

Features:
- Pull to refresh
- Navigate to detail screens
- Tap category chip → filter all items

Cards design:
- Rounded corners (12pt)
- Shadow elevation 2
- Icon + Title + Value
- Tap to navigate

Include loading states và empty states.
```

---

### Prompt 6.4: Add Product Screen

```
Tạo file lib/presentation/screens/add_product/add_product_screen.dart

Form fields theo WIREFRAMES.md:
1. Category dropdown
2. Product name với search suggestions
3. Quantity với +/- buttons
4. Unit dropdown
5. Purchase date picker
6. Expiry date picker (auto-filled)
7. Notes (optional)
8. Image picker (optional)

Search suggestions:
- Dropdown appears when typing (after 2 chars)
- Show 5-10 matching templates
- Highlight matching text
- Tap to select → auto-fill

Validation:
- Category required
- Name required, min 2 chars
- Quantity > 0
- Purchase date <= today
- Expiry date >= purchase date

Buttons:
- Primary: "Thêm Sản Phẩm" (full width)
- Secondary: "Hủy"

On submit:
- Validate
- Call ProductProvider.addProduct()
- Show success message
- Navigate back

Features:
- Real-time search
- Date pickers (showDatePicker)
- Form validation
- Loading states

Sử dụng:
- Form & TextEditingController
- FocusNode
- AutoCompleteCore / Custom dropdown
```

---

### Prompt 6.5: All Items Screen

```
Tạo file lib/presentation/screens/all_items/all_items_screen.dart

Layout:
1. AppBar với title "Tất Cả Sản Phẩm"
2. Search bar
3. Category filter chips (horizontal)
4. Sort button (opens bottom sheet)
5. ListView of products
6. Empty state

Product List Item:
- ProductCard widget (tạo riêng)
- Swipe actions (iOS) hoặc long press (Android)
- Actions: Edit, Mark as Used, Delete

Sort options (bottom sheet):
- Gần hết hạn nhất (default)
- Tên A-Z
- Tên Z-A
- Mới thêm nhất
- Cũ nhất

Features:
- Pull to refresh
- Filter by category
- Sort
- Search
- Tap item → detail
- Swipe → actions

State:
- ProductProvider với filter & sort
- Loading, error, empty states

Sử dụng:
- ListView.builder
- flutter_slidable cho swipe
- showModalBottomSheet cho sort
```

---

### Prompt 6.6: Expiring Soon Screen

```
Tạo file lib/presentation/screens/expiring_soon/expiring_soon_screen.dart

Layout:
1. AppBar "Gần Hết Hạn" với badge count
2. Alert banner (nếu có items urgent)
3. Grouped list:
   - "HÔM NAY / QUÁ HẠN"
   - "1-3 NGÀY TỚI"
   - "4-7 NGÀY TỚI"

Each item:
- Product card với warning color
- "Đã dùng" button
- "Chi tiết" button

Empty state:
- ✅ icon
- "Tuyệt vời! Không có sản phẩm nào gần hết hạn"

Features:
- Group by urgency
- Quick actions (Mark as used)
- Navigate to detail

State:
- ProductProvider.expiringSoon
- Group items by daysUntilExpiry

Design:
- Red/Orange badges
- Prominent CTAs
- Urgent alert banner
```

---

### Prompt 6.7: Product Detail Screen

```
Tạo file lib/presentation/screens/product_detail/product_detail_screen.dart

Layout:
1. AppBar với Edit & More buttons
2. Product image (nếu có)
3. Product name + status badge
4. TabBar: [Thông Tin] [Dinh Dưỡng] [Sức Khỏe]
5. TabView content
6. Bottom action buttons

Tab 1 - Thông Tin:
- Category, quantity, dates
- Days remaining
- Notes
- Storage tips
- Bảo quản section

Tab 2 - Dinh Dưỡng:
- Nutrition facts
- Progress bars
- Vitamins & minerals
- Visual charts (optional)

Tab 3 - Sức Khỏe:
- Lợi ích (green card)
- Lưu ý (orange card)
- Phù hợp cho

Bottom actions:
- Chỉnh sửa
- Đã sử dụng
- Xóa

Features:
- Swipe between tabs
- Navigate to edit
- Confirmation dialogs
- Delete with undo

Sử dụng:
- TabBar & TabBarView
- Consumer<ProductProvider>
- Expandable cards
```

---

### Prompt 6.8: Settings Screen

```
Tạo file lib/presentation/screens/settings/settings_screen.dart

Layout theo WIREFRAMES.md:
- User profile section
- Grouped settings list

Sections:
1. Người dùng (name, avatar)
2. Thông báo (toggle, options)
3. Giao diện (theme, colors, font)
4. Ngôn ngữ (VI/EN)
5. Dữ liệu (backup, restore, clear)
6. Thông tin (version, policies, contact)

Each item:
- Icon + Title + Trailing (arrow/toggle)
- Tap to navigate or toggle

Features:
- Toggle switches
- Navigate to sub-screens
- Show dialogs for actions
- Confirmation for destructive actions

State:
- SettingsProvider
- NotificationProvider

Sử dụng:
- ListView with sections
- ListTile
- SwitchListTile
- showDialog for confirmations
```

---

## 7. WIDGETS

### Prompt 7.1: Product Card Widget

```
Tạo file lib/presentation/widgets/product/product_card.dart

Reusable widget cho product list item.

Layout:
- Card container
- Icon/emoji (emoji cho category)
- Product name (bold)
- Category • Days remaining
- Quantity
- Expiry date
- Status indicator (colored dot, top-right)

Props:
- UserProduct product
- VoidCallback? onTap
- VoidCallback? onEdit
- VoidCallback? onDelete
- VoidCallback? onMarkUsed

Features:
- Color-coded by days remaining
- Tap to view detail
- Optional swipe actions

Design:
- 12pt border radius
- Padding 16pt
- Shadow elevation 2
- Status colors: green/orange/red

Sử dụng:
- Card widget
- Row/Column layout
- Gesture detectors
```

---

### Prompt 7.2: Custom Button Widget

```
Tạo file lib/presentation/widgets/common/custom_button.dart

3 button types:
1. PrimaryButton - filled, primary color
2. SecondaryButton - outlined, primary border
3. TextButton - text only, no background

Props:
- String text
- VoidCallback onPressed
- bool isLoading
- bool isDisabled
- IconData? icon
- double? width

Features:
- Loading state (show spinner)
- Disabled state (opacity 0.4)
- Ripple effect
- Icon support

Design:
- Height 48pt
- Border radius 8pt
- Font 16pt semi-bold
- Full width hoặc custom

Example usage:
```dart
PrimaryButton(
  text: 'Thêm Sản Phẩm',
  onPressed: () {},
  isLoading: false,
)
```
```

---

### Prompt 7.3: Bottom Navigation Widget

```
Tạo file lib/presentation/widgets/common/bottom_navigation_bar.dart

5 items:
1. Home (🏠)
2. Expiring Soon (⚠️) with badge
3. Add (FAB center)
4. All Items (📋)
5. Settings (⚙️)

Layout:
- BottomNavigationBar với 5 items
- FAB ở giữa (floating)
- Badge trên Expiring Soon tab

Props:
- int currentIndex
- Function(int) onTap

Features:
- Selected/unselected states
- Badge count
- FAB với shadow
- Smooth transitions

Design:
- Icons 24x24pt
- Selected: primary color
- Unselected: gray
- FAB: 56x56pt, primary color

Sử dụng:
- BottomNavigationBar
- FloatingActionButton
- Badge widget
```

---

### Prompt 7.4: Search Bar Widget

```
Tạo file lib/presentation/widgets/common/search_bar_widget.dart

Custom search bar với suggestions.

Props:
- String hint
- Function(String) onSearch
- Function(String)? onChanged
- List<ProductTemplate> suggestions

Features:
- TextField với search icon
- Clear button (X)
- Dropdown suggestions
- Highlight matching text
- Debounce input

Layout:
- Container với rounded corners
- Icon (left)
- TextField (center)
- Clear button (right, conditional)
- Overlay suggestions dropdown

Design:
- Height 48pt
- Border radius 8pt
- Background #F5F5F5
- Focus: white bg + primary border

Sử dụng:
- TextField
- OverlayEntry cho dropdown
- Timer cho debounce
```

---

### Prompt 7.5: Empty State Widget

```
Tạo file lib/presentation/widgets/common/empty_state_widget.dart

Reusable empty state cho các screens.

Props:
- IconData icon (hoặc String emoji)
- String title
- String? message
- String? actionText
- VoidCallback? onAction

Layout (centered):
- Large icon/emoji
- Title (bold, 20pt)
- Message (gray, 14pt)
- Action button (optional)

Example:
```dart
EmptyStateWidget(
  icon: '📦',
  title: 'Chưa có sản phẩm nào',
  message: 'Thêm sản phẩm đầu tiên của bạn',
  actionText: '+ Thêm Sản Phẩm',
  onAction: () {},
)
```

Design:
- Center alignment
- Spacing 16pt
- Muted colors
- Friendly tone
```

---

### Prompt 7.6: Loading Widget

```
Tạo file lib/presentation/widgets/common/loading_widget.dart

3 loading states:
1. FullScreenLoading - cover toàn màn hình
2. InlineLoading - circular indicator nhỏ
3. SkeletonLoading - shimmer effect

FullScreenLoading:
- Overlay với barrier
- Centered spinner
- Optional message

InlineLoading:
- Small spinner
- Center hoặc custom alignment

SkeletonLoading:
- Shimmer effect cho list items
- Match layout của ProductCard

Sử dụng:
- CircularProgressIndicator
- shimmer package
- Stack & Positioned
```

---

## 8. SERVICES

### Prompt 8.1: Notification Service

```
Tạo file lib/services/notification_service.dart

Singleton class để quản lý local notifications.

Methods:
1. Initialization:
   - Future<void> initialize()
   - _configureLocalTimeZone()
   - _requestPermissions()

2. Schedule:
   - Future<void> scheduleExpiryNotifications(UserProduct product)
   - Future<void> scheduleNotification(...)

3. Management:
   - Future<void> cancelNotification(int id)
   - Future<void> cancelProductNotifications(String productId)
   - Future<void> cancelAllNotifications()

4. Handling:
   - void onNotificationTap(NotificationResponse response)
   - Navigate to product detail

Schedule 3 notifications per product:
- 3 days before expiry
- 1 day before expiry
- On expiry day

Sử dụng:
- flutter_local_notifications
- timezone package
- Generate unique notification IDs

Include:
- Permission handling
- Platform-specific configuration
- Payload for navigation
```

---

### Prompt 8.2: Storage Service

```
Tạo file lib/services/storage_service.dart

Wrapper cho SharedPreferences.

Methods:
1. Getters:
   - Future<String?> getString(String key)
   - Future<int?> getInt(String key)
   - Future<bool?> getBool(String key)
   - Future<List<String>?> getStringList(String key)

2. Setters:
   - Future<bool> setString(String key, String value)
   - Future<bool> setInt(String key, int value)
   - Future<bool> setBool(String key, bool value)
   - Future<bool> setStringList(String key, List<String> value)

3. Management:
   - Future<bool> remove(String key)
   - Future<bool> clear()
   - Future<bool> containsKey(String key)

Singleton pattern.
Include error handling.
```

---

### Prompt 8.3: Image Service

```
Tạo file lib/services/image_service.dart

Handle image picking, compression, storage.

Methods:
1. Pick:
   - Future<File?> pickFromCamera()
   - Future<File?> pickFromGallery()

2. Process:
   - Future<File> compressImage(File file)
   - Future<File> cropImage(File file) (optional)

3. Storage:
   - Future<String> saveImage(File file, String productId)
   - Future<bool> deleteImage(String path)

Compression:
- Max width: 800px
- Quality: 85%
- Format: JPEG

Storage path:
- app_documents/images/[productId].jpg

Sử dụng:
- image_picker
- path_provider
- image package (cho compression)

Include error handling.
```

---

## 9. LOCALIZATION

### Prompt 9.1: Localization Setup

```
Setup localization cho Fresh Keeper.

1. Add dependencies:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```

2. Tạo lib/core/l10n/:
   - app_localizations.dart (abstract class)
   - app_localizations_vi.dart (Vietnamese)
   - app_localizations_en.dart (English)

3. Strings cần translate:
   - App name, taglines
   - Screen titles
   - Button labels
   - Messages
   - Errors
   - Categories
   - Form labels
   - Notifications

4. Usage:
```dart
Text(AppLocalizations.of(context).add_product)
```

5. Update main.dart:
```dart
MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('vi', ''),
    Locale('en', ''),
  ],
)
```

Priority: Vietnamese first, English for Phase 2.
```

---

## 10. TESTING

### Prompt 10.1: Unit Tests

```
Tạo unit tests trong test/unit/:

1. test/unit/models/user_product_test.dart:
   - Test toJson/fromJson
   - Test daysUntilExpiry calculation
   - Test isExpired logic
   - Test isExpiringSoon logic
   - Test copyWith

2. test/unit/repositories/product_repository_test.dart:
   - Mock ProductLocalDataSource
   - Test CRUD operations
   - Test error handling
   - Test Result type

3. test/unit/providers/product_provider_test.dart:
   - Test loading states
   - Test filter & sort
   - Test CRUD operations
   - Test notifyListeners calls

Setup:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.7
```

Generate mocks:
```bash
flutter pub run build_runner build
```

Include:
- Test setup & teardown
- Mock dependencies
- Assertions
- Edge cases
```

---

### Prompt 10.2: Widget Tests

```
Tạo widget tests trong test/widget/:

1. test/widget/widgets/product_card_test.dart:
   - Test rendering
   - Test tap action
   - Test colors by status

2. test/widget/screens/home_screen_test.dart:
   - Test rendering with data
   - Test empty state
   - Test navigation
   - Test pull to refresh

3. test/widget/screens/add_product_screen_test.dart:
   - Test form validation
   - Test search suggestions
   - Test date pickers
   - Test submit

Setup:
```dart
testWidgets('ProductCard displays correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProductCard(product: mockProduct),
    ),
  );

  expect(find.text('Táo Fuji'), findsOneWidget);
  expect(find.byType(Card), findsOneWidget);
});
```

Test:
- Widget rendering
- User interactions
- State changes
- Navigation
```

---

### Prompt 10.3: Integration Tests

```
Tạo integration tests trong integration_test/:

1. integration_test/app_test.dart:

Flow 1: Add Product:
- Launch app
- Navigate to Add Product
- Fill form
- Submit
- Verify product in list

Flow 2: Mark as Used:
- Find product in list
- Swipe to mark as used
- Verify removed from list

Flow 3: Expiring Soon:
- Navigate to Expiring Soon
- Verify products grouped correctly
- Mark as used
- Verify empty state

Setup:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

Run:
```bash
flutter test integration_test/app_test.dart
```

Include:
- End-to-end flows
- User journeys
- Database operations
- Navigation flows
```

---

## 📋 Development Sequence

### Phase 1: Foundation (Week 1-2)
1. ✅ Setup project & dependencies
2. ✅ Create folder structure
3. ✅ Implement database layer
4. ✅ Create data models
5. ✅ Setup theme & constants

### Phase 2: Core Features (Week 3-4)
6. Implement repositories
7. Setup state management (providers)
8. Create services (database, storage)
9. Build basic UI screens
10. Implement navigation

### Phase 3: UI/UX (Week 5-6)
11. Home screen (dashboard)
12. Add product screen with search
13. All items screen with filter/sort
14. Expiring soon screen
15. Product detail screen
16. Settings screen

### Phase 4: Advanced Features (Week 7-8)
17. Notifications service
18. Image handling
19. Search optimization
20. Onboarding flow
21. Polish UI/UX

### Phase 5: Testing & Polish (Week 9-10)
22. Unit tests
23. Widget tests
24. Integration tests
25. Bug fixes
26. Performance optimization
27. Prepare for release

---

## 🎯 Quick Start Commands

```bash
# Setup dependencies
flutter pub get

# Run app
flutter run

# Generate code (for json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Generate mocks (for testing)
flutter pub run build_runner build

# Run tests
flutter test

# Run integration tests
flutter test integration_test/

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

---

## ✅ Checklist Before Coding

- [ ] Đọc kỹ REQUIREMENTS.md
- [ ] Xem WIREFRAMES.md
- [ ] Hiểu DATA_STRUCTURE.md
- [ ] Review UI_UX_GUIDELINES.md
- [ ] Check TECH_STACK.md
- [ ] Setup project với prompt 1.1
- [ ] Tạo database schema
- [ ] Chuẩn bị sample data (products_database.json)

---

## 📚 Resources

- **Flutter Docs:** https://docs.flutter.dev/
- **Provider:** https://pub.dev/packages/provider
- **SQLite:** https://pub.dev/packages/sqflite
- **Notifications:** https://pub.dev/packages/flutter_local_notifications

---

## 💡 Tips

1. **Code từng module nhỏ:** Đừng cố làm hết một lúc
2. **Test ngay:** Viết test cho từng module sau khi hoàn thành
3. **Commit thường xuyên:** Mỗi feature một commit
4. **Refactor sau:** Làm working version trước, optimize sau
5. **UI sau logic:** Implement logic trước, UI sau
6. **Use hot reload:** Tận dụng hot reload của Flutter
7. **Debug với print:** Dùng debugPrint() thay vì print()
8. **Handle errors:** Luôn có try-catch và error states

---

## 🚀 Ready to Code!

Copy từng prompt ở trên và paste vào AI assistant (Claude, ChatGPT, etc.) để generate code cho từng module.

**Suggested order:**
1. Start với Prompt 1.1, 1.2, 1.3 (Setup)
2. Then Prompt 2.1, 2.2 (Database)
3. Then Prompt 3.1, 3.2 (Models)
4. Then Prompt 4.1 (Repository)
5. Continue theo sequence...

Good luck! 🎉
