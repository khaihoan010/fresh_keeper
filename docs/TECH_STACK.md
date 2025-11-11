# Fresh Keeper - Tech Stack

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────┐
│           Flutter Application            │
├─────────────────────────────────────────┤
│                                          │
│  ┌──────────────────────────────────┐   │
│  │   Presentation Layer             │   │
│  │   - Screens / Pages              │   │
│  │   - Widgets                      │   │
│  │   - UI Components                │   │
│  └──────────────────────────────────┘   │
│                ↕                         │
│  ┌──────────────────────────────────┐   │
│  │   Business Logic Layer           │   │
│  │   - BLoC / Providers             │   │
│  │   - Use Cases                    │   │
│  │   - State Management             │   │
│  └──────────────────────────────────┘   │
│                ↕                         │
│  ┌──────────────────────────────────┐   │
│  │   Data Layer                     │   │
│  │   - Repositories                 │   │
│  │   - Data Sources                 │   │
│  │   - Models                       │   │
│  └──────────────────────────────────┘   │
│                ↕                         │
│  ┌──────────────────────────────────┐   │
│  │   Services & Infrastructure      │   │
│  │   - Database (SQLite)            │   │
│  │   - Local Storage                │   │
│  │   - Notifications                │   │
│  │   - APIs (if any)                │   │
│  └──────────────────────────────────┘   │
│                                          │
└─────────────────────────────────────────┘
```

**Pattern:** Clean Architecture + BLoC/Provider

---

## 🛠️ Core Technologies

### 1. Flutter Framework

```yaml
flutter:
  sdk: ">=3.3.0 <4.0.0"

# Target versions:
# - iOS: 13.0+
# - Android: API 21+ (Android 5.0+)
```

**Why Flutter:**
- ✅ Single codebase for iOS & Android
- ✅ Fast development with hot reload
- ✅ Beautiful UI with Material & Cupertino
- ✅ Great performance (60fps)
- ✅ Large community & packages

### 2. Dart Language

```dart
// Version: 3.3.0+
// Features used:
// - Null safety
// - Enhanced enums
// - Pattern matching
// - Records (Dart 3+)
```

---

## 📦 Essential Packages

### State Management

#### Option 1: Provider (Recommended for MVP)
```yaml
provider: ^6.1.1
```

**Pros:**
- Simple to learn
- Good for small-medium apps
- Less boilerplate
- Official Flutter package

**Structure:**
```
lib/
  providers/
    product_provider.dart
    notification_provider.dart
    settings_provider.dart
```

#### Option 2: flutter_bloc (For Scalability)
```yaml
flutter_bloc: ^8.1.3
bloc: ^8.1.2
```

**Pros:**
- Better for complex state
- Testable
- Predictable state flow
- Good for large teams

**Structure:**
```
lib/
  blocs/
    product/
      product_bloc.dart
      product_event.dart
      product_state.dart
```

**Decision:** Start with **Provider** for MVP, migrate to BLoC if needed.

---

### Database

```yaml
sqflite: ^2.3.0
path_provider: ^2.1.1
path: ^1.8.3
```

**Why SQLite:**
- ✅ Built-in, no setup needed
- ✅ Fast local queries
- ✅ Support FTS5 for search
- ✅ Reliable for small-medium data
- ✅ No cost

**Usage:**
```dart
// Database setup
class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'fresh_keeper.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
}
```

---

### Local Storage

```yaml
shared_preferences: ^2.2.2
```

**Usage:**
- App settings
- User preferences
- Onboarding state
- Notification settings

```dart
// Example
Future<void> saveSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notifications_enabled', true);
  await prefs.setString('language', 'vi');
}
```

---

### Notifications

```yaml
flutter_local_notifications: ^16.3.0
timezone: ^0.9.2
```

**Features:**
- Local scheduled notifications
- Custom sounds
- Action buttons
- Badge support

**Usage:**
```dart
// Schedule notification
await flutterLocalNotificationsPlugin.zonedSchedule(
  0,
  'Sắp hết hạn!',
  'Táo sẽ hết hạn trong 3 ngày',
  scheduledDate,
  NotificationDetails(...),
  uiLocalNotificationDateInterpretation: ...,
  matchDateTimeComponents: DateTimeComponents.time,
);
```

---

### Date & Time

```yaml
intl: ^0.19.0
```

**Features:**
- Date formatting
- Localization
- Number formatting
- Currency formatting

**Usage:**
```dart
// Format date
final formatter = DateFormat('dd/MM/yyyy', 'vi');
String formatted = formatter.format(DateTime.now());

// Relative time
String daysRemaining = '${product.daysUntilExpiry} ngày';
```

---

### JSON & Serialization

```yaml
json_annotation: ^4.8.1
json_serializable: ^6.7.1
build_runner: ^2.4.7
```

**Why:**
- Type-safe JSON parsing
- Auto-generate serialization code
- Less manual work

**Usage:**
```dart
@JsonSerializable()
class Product {
  final String id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
```

---

### UUID Generation

```yaml
uuid: ^4.2.2
```

**Usage:**
```dart
final uuid = Uuid();
final productId = uuid.v4(); // Generate unique ID
```

---

### Image Handling

```yaml
image_picker: ^1.0.5
cached_network_image: ^3.3.1
```

**Features:**
- Pick from camera/gallery
- Cache images
- Placeholder support

**Usage:**
```dart
// Pick image
final ImagePicker picker = ImagePicker();
final XFile? image = await picker.pickImage(source: ImageSource.camera);

// Display with cache
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

### UI/UX Enhancements

```yaml
# Shimmer loading effect
shimmer: ^3.0.0

# Pull to refresh
flutter_slidable: ^3.0.1

# Smooth page indicator
smooth_page_indicator: ^1.1.0

# Icons
cupertino_icons: ^1.0.6

# SVG support
flutter_svg: ^2.0.9

# Animations
lottie: ^3.0.0
```

---

### Search & Filtering

For search optimization, use SQLite FTS5 (Full-Text Search):

```dart
// Create FTS5 table
await db.execute('''
  CREATE VIRTUAL TABLE product_search USING fts5(
    product_id UNINDEXED,
    name_vi,
    name_en,
    aliases
  )
''');

// Search
final results = await db.rawQuery('''
  SELECT pt.*
  FROM product_search ps
  JOIN product_templates pt ON ps.product_id = pt.id
  WHERE product_search MATCH ?
  ORDER BY rank
  LIMIT 10
''', ['$query*']);
```

---

### Testing

```yaml
flutter_test:
  sdk: flutter

mockito: ^5.4.4
bloc_test: ^9.1.5 # if using BLoC
integration_test:
  sdk: flutter
```

**Test Structure:**
```
test/
  unit/
    models/
    repositories/
    providers/
  widget/
    screens/
    widgets/
  integration/
    flows/
```

---

## 🗂️ Project Structure

```
fresh_keeper/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── config/
│   │   ├── theme.dart
│   │   ├── routes.dart
│   │   └── constants.dart
│   │
│   ├── core/
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   └── validators.dart
│   │   └── extensions/
│   │       ├── string_extension.dart
│   │       └── datetime_extension.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_product.dart
│   │   │   ├── product_template.dart
│   │   │   ├── category.dart
│   │   │   └── nutrition_data.dart
│   │   │
│   │   ├── repositories/
│   │   │   ├── product_repository.dart
│   │   │   ├── category_repository.dart
│   │   │   └── notification_repository.dart
│   │   │
│   │   └── data_sources/
│   │       ├── local/
│   │       │   ├── database_helper.dart
│   │       │   ├── product_local_data_source.dart
│   │       │   └── preferences_data_source.dart
│   │       └── remote/ (future)
│   │
│   ├── domain/
│   │   ├── entities/
│   │   └── use_cases/
│   │       ├── add_product_use_case.dart
│   │       ├── get_expiring_products_use_case.dart
│   │       └── schedule_notification_use_case.dart
│   │
│   ├── presentation/
│   │   ├── providers/ (or blocs/)
│   │   │   ├── product_provider.dart
│   │   │   ├── notification_provider.dart
│   │   │   └── settings_provider.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── splash/
│   │   │   ├── onboarding/
│   │   │   ├── home/
│   │   │   ├── add_product/
│   │   │   ├── all_items/
│   │   │   ├── expiring_soon/
│   │   │   ├── product_detail/
│   │   │   └── settings/
│   │   │
│   │   └── widgets/
│   │       ├── common/
│   │       │   ├── custom_button.dart
│   │       │   ├── custom_card.dart
│   │       │   └── loading_indicator.dart
│   │       ├── product/
│   │       │   ├── product_card.dart
│   │       │   └── product_list_item.dart
│   │       └── search/
│   │           └── search_suggestion_list.dart
│   │
│   └── services/
│       ├── notification_service.dart
│       ├── database_service.dart
│       └── storage_service.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   ├── data/
│   │   ├── products_database.json
│   │   └── categories.json
│   └── fonts/ (if custom fonts)
│
├── test/
├── integration_test/
├── android/
├── ios/
└── pubspec.yaml
```

---

## 📱 Platform-Specific Configuration

### iOS Configuration

**Info.plist:**
```xml
<!-- Camera permission -->
<key>NSCameraUsageDescription</key>
<string>Chụp ảnh sản phẩm</string>

<!-- Photo library permission -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Chọn ảnh từ thư viện</string>

<!-- Notification permission -->
<key>UIBackgroundModes</key>
<array>
  <string>remote-notification</string>
</array>
```

**Podfile:**
```ruby
platform :ios, '13.0'
```

### Android Configuration

**AndroidManifest.xml:**
```xml
<!-- Permissions -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<!-- Notification channel -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="fresh_keeper_channel" />
```

**build.gradle:**
```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

---

## 🔧 Development Tools

### Version Control
```bash
# Git
git init
git add .
git commit -m "Initial commit"

# .gitignore includes:
# - *.g.dart (generated files)
# - build/
# - .dart_tool/
```

### Code Generation
```bash
# Run build_runner for JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on save)
flutter pub run build_runner watch
```

### Linting
```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_final_fields
    - avoid_print
    - sized_box_for_whitespace
```

### Debugging
```bash
# Run in debug mode
flutter run

# Run with verbose logging
flutter run -v

# Profile mode
flutter run --profile

# Release mode
flutter run --release
```

---

## 🚀 Build & Deployment

### Build Commands

#### Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by ABI
flutter build apk --split-per-abi
```

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

#### iOS
```bash
# Build iOS app
flutter build ios --release

# Open Xcode
open ios/Runner.xcworkspace
```

### App Signing

#### Android
```gradle
// android/app/build.gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile']
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### iOS
- Use Xcode for certificate management
- Configure in Xcode → Signing & Capabilities

---

## 📊 Performance Optimization

### Image Optimization
```dart
// Resize images before storing
import 'package:image/image.dart' as img;

Future<File> compressImage(File file) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);
  final resized = img.copyResize(image!, width: 800);
  final compressed = img.encodeJpg(resized, quality: 85);

  return File(file.path)..writeAsBytesSync(compressed);
}
```

### Database Optimization
```dart
// Use indexes
await db.execute('CREATE INDEX idx_expiry_date ON user_products(expiry_date)');

// Batch operations
await db.transaction((txn) async {
  for (var product in products) {
    await txn.insert('user_products', product.toJson());
  }
});
```

### Widget Optimization
```dart
// Use const constructors
const Text('Hello');

// Avoid rebuilding expensive widgets
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return const Card(...);
  }
}
```

---

## 🔐 Security

### Data Security
- All data stored locally (encrypted if sensitive)
- No plain text passwords
- Secure API keys (if any) in environment variables

### API Security (Future)
```dart
// Use environment variables
const apiKey = String.fromEnvironment('API_KEY');

// HTTPS only
final dio = Dio()..options.baseUrl = 'https://api.example.com';
```

---

## 📈 Analytics (Optional)

```yaml
# Firebase Analytics (if needed)
firebase_analytics: ^10.7.4
firebase_core: ^2.24.2
```

**Track Events:**
```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'product_added',
  parameters: {
    'category': product.category,
    'name': product.name,
  },
);
```

---

## ✅ Tech Stack Summary

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.3+ | Cross-platform UI |
| **Language** | Dart 3.0+ | Programming |
| **State** | Provider | State management |
| **Database** | SQLite | Local storage |
| **Notifications** | flutter_local_notifications | Reminders |
| **Serialization** | json_serializable | JSON parsing |
| **Storage** | shared_preferences | Settings |
| **Images** | image_picker | Camera/Gallery |
| **Date/Time** | intl | Formatting |
| **Testing** | flutter_test, mockito | Unit/Widget tests |

**Total Package Count:** ~15-20 packages for MVP

---

## 🎯 Next Steps

1. ✅ Setup Flutter project
2. ✅ Add dependencies to pubspec.yaml
3. ✅ Create folder structure
4. ⏳ Setup database schema
5. ⏳ Implement core models
6. ⏳ Build UI screens
7. ⏳ Integrate state management
8. ⏳ Add notifications
9. ⏳ Testing
10. ⏳ Deploy to stores
