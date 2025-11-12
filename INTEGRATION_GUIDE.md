# 🔧 Monetization Integration Guide

## ✅ Đã Hoàn Thành

### 1. Core Services ✅
- ✅ `lib/services/auth_service.dart` - Firebase Authentication
- ✅ `lib/services/subscription_service.dart` - In-App Purchase
- ✅ `lib/services/ads_service.dart` - Unity Ads (Game IDs: 5983297 Android, 5983296 iOS)

### 2. Providers ✅
- ✅ `lib/presentation/providers/subscription_provider.dart` - Premium state management
- ✅ `lib/presentation/providers/ads_provider.dart` - Ads state management

### 3. UI Components ✅
- ✅ `lib/presentation/widgets/ads/banner_ad_widget.dart` - Banner ad widget
- ✅ `lib/presentation/widgets/ads/premium_badge_widget.dart` - Premium badge & upgrade button
- ✅ `lib/presentation/screens/premium/premium_screen.dart` - Premium subscription screen

### 4. App Initialization ✅
- ✅ `lib/main.dart` - Firebase initialized, providers added
- ✅ `lib/config/routes.dart` - Premium route added

---

## 🚧 Cần Làm Tiếp

### Step 1: Integrate Banner Ads vào Screens

Thêm `BannerAdWidget` vào **4 screens** sau:

#### A. Home Screen (`lib/presentation/screens/home/home_screen.dart`)

```dart
import '../../widgets/ads/banner_ad_widget.dart';

// In build method, wrap Scaffold body with Column:
body: Column(
  children: [
    Expanded(
      child: // existing body content
    ),
    const BannerAdWidget(), // Add at bottom
  ],
),
```

#### B. All Items Screen (`lib/presentation/screens/all_items/all_items_screen.dart`)

```dart
import '../../widgets/ads/banner_ad_widget.dart';

body: Column(
  children: [
    Expanded(
      child: // existing body content
    ),
    const BannerAdWidget(),
  ],
),
```

#### C. Expiring Soon Screen (`lib/presentation/screens/expiring_soon/expiring_soon_screen.dart`)

```dart
import '../../widgets/ads/banner_ad_widget.dart';

body: Column(
  children: [
    Expanded(
      child: // existing body content
    ),
    const BannerAdWidget(),
  ],
),
```

#### D. Settings Screen (`lib/presentation/screens/settings/settings_screen.dart`)

```dart
import '../../widgets/ads/banner_ad_widget.dart';
import '../../widgets/ads/premium_badge_widget.dart';
import '../../../config/routes.dart';
import 'package:provider/provider.dart';
import '../../providers/subscription_provider.dart';

// Add Premium badge at top of ListView
ListView(
  children: [
    // Premium Section
    Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        if (subscriptionProvider.isPremium) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const PremiumBadgeWidget(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thành viên Premium',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cảm ơn bạn đã ủng hộ!',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: PremiumUpgradeButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.premium);
              },
            ),
          );
        }
      },
    ),

    // Existing settings items...
  ],
),

// Wrap in Column to add banner at bottom
body: Column(
  children: [
    Expanded(
      child: ListView(/* existing content */),
    ),
    const BannerAdWidget(),
  ],
),
```

### Step 2: Integrate Popup Ads vào Add Product

File: `lib/presentation/screens/add_product/add_product_screen.dart`

```dart
import 'package:provider/provider.dart';
import '../../providers/ads_provider.dart';

// In _handleSaveProduct method, after successfully adding product:
Future<void> _handleSaveProduct() async {
  // ... existing validation ...

  // Save product
  final success = await provider.addProduct(product);

  if (success && mounted) {
    // Show ads after adding product (respects 3-product + 3-minute rules)
    final adsProvider = context.read<AdsProvider>();
    await adsProvider.onProductAdded();

    // Navigate back
    Navigator.of(context).pop(true);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.productAdded(product.name)),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
```

### Step 3: Test Flow

#### Test Free User Experience:
1. Mở app → Banner ads hiển thị ở bottom của Home, All Items, Expiring Soon, Settings
2. Thêm sản phẩm lần 1 → Không ads
3. Thêm sản phẩm lần 2 → Không ads
4. Thêm sản phẩm lần 3 → Popup ads xuất hiện!
5. Đợi 3 phút → Thêm 3 sản phẩm nữa → Popup ads lại xuất hiện

#### Test Premium User Experience:
1. Settings → Tap "Nâng cấp lên Premium"
2. Chọn gói (sẽ fail nếu chưa setup IAP products, nhưng UI hoạt động)
3. Sau khi Premium: Tất cả ads biến mất
4. Premium badge xuất hiện trong Settings

---

## 🔥 Firebase Setup Required

**QUAN TRỌNG**: Trước khi app hoạt động hoàn toàn, cần setup Firebase:

### Android Setup:
1. Tạo project trên Firebase Console
2. Add Android app với package name từ `android/app/build.gradle`
3. Download `google-services.json` vào `android/app/`
4. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```
5. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS Setup:
1. Add iOS app với Bundle ID từ Xcode
2. Download `GoogleService-Info.plist` vào `ios/Runner/`
3. Update `ios/Podfile` minimum version to 13.0

### Enable Firebase Services:
- ✅ Authentication → Anonymous + Email/Password
- ✅ Firestore Database → Create in test mode

**Chi tiết xem trong MONETIZATION_SETUP.md**

---

## 📝 Quick Commands

```bash
# Run app
flutter run

# Clean build if needed
flutter clean && flutter pub get

# Run with verbose logging
flutter run -v

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

---

## 🐛 Common Issues

### "Firebase not initialized"
- App vẫn chạy được, nhưng không có monetization features
- Fix: Setup Firebase như hướng dẫn trên

### "Unity Ads failed to initialize"
- Check internet connection
- Verify Game IDs correct: 5983297 (Android), 5983296 (iOS)
- Ensure test mode enabled: `testMode: true`

### "Products not found"
- IAP chưa setup trên Play Console/App Store Connect
- App vẫn chạy bình thường, chỉ không thể purchase

---

## ✅ Final Checklist

- [ ] Banner ads xuất hiện ở 4 screens
- [ ] Popup ads xuất hiện sau 3 sản phẩm
- [ ] Premium button trong Settings
- [ ] Premium screen mở được
- [ ] Khi Premium, ads biến mất
- [ ] App không crash khi chưa có Firebase

---

## 🚀 Next Steps After Integration

1. **Setup Firebase** (bắt buộc cho production)
2. **Setup Unity Ads account** với Game IDs
3. **Create IAP products** trên Play Console & App Store Connect
4. **Test trên real devices**
5. **Set testMode: false** khi ready production
6. **Submit app** lên stores

---

Chúc bạn thành công! 🎉
