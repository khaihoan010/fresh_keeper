# 💰 Fresh Keeper - Monetization Setup Guide

## 📋 Tổng Quan

Tôi đã thêm hệ thống monetization hoàn chỉnh cho Fresh Keeper bao gồm:
- ✅ Unity Ads (Banner & Interstitial/Popup ads)
- ✅ Firebase Authentication (Anonymous & Email/Password)
- ✅ In-App Purchase (VIP Membership)
- ✅ Cloud Firestore (Quản lý premium status)

## 🎯 Chiến Lược Monetization

### 1. **Quảng Cáo (Free Users)**
- **Banner Ads**: Hiển thị ở bottom của các màn hình chính
- **Interstitial Ads (Popup)**:
  - Xuất hiện sau **3 lần** thêm sản phẩm
  - Giới hạn tối thiểu **3 phút** giữa mỗi lần hiển thị
  - Không làm gián đoạn trải nghiệm người dùng

### 2. **VIP Membership (Premium)**
- ❌ Tắt tất cả quảng cáo
- ⭐ Badge đặc biệt
- 🎨 Themes độc quyền (tùy chọn mở rộng)
- ☁️ Cloud backup (tùy chọn mở rộng)

### 3. **Pricing Plans**
- **Monthly**: ~49,000 VNĐ/tháng
- **Yearly**: ~399,000 VNĐ/năm (save 32%)
- **Lifetime**: ~999,000 VNĐ (one-time)

---

## 📦 Dependencies Đã Thêm

```yaml
# Ads
unity_ads_plugin: ^0.3.16

# Firebase
firebase_core: ^3.8.1
firebase_auth: ^5.3.4
cloud_firestore: ^5.5.2

# In-App Purchase
in_app_purchase: ^3.2.0
in_app_purchase_android: ^0.3.10+1
in_app_purchase_storekit: ^0.3.20+1
```

---

## 🔧 Setup Steps

### Step 1: Cài Đặt Dependencies

```bash
cd /home/user/fresh_keeper
flutter pub get
```

### Step 2: Firebase Setup

#### 2.1. Tạo Firebase Project
1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Tạo project mới: `fresh-keeper-prod`
3. Thêm Android app:
   - Package name: `com.freshkeeper.app` (hoặc package của bạn)
   - Download `google-services.json`
   - Đặt vào: `android/app/google-services.json`

4. Thêm iOS app:
   - Bundle ID: `com.freshkeeper.app`
   - Download `GoogleService-Info.plist`
   - Đặt vào: `ios/Runner/GoogleService-Info.plist`

#### 2.2. Cấu Hình Android

**android/build.gradle:**
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**android/app/build.gradle:**
```gradle
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'dev.flutter.flutter-gradle-plugin'
    id 'com.google.gms.google-services'  // ADD THIS
}

android {
    defaultConfig {
        minSdkVersion 21  // Firebase requires min 21
    }
}
```

#### 2.3. Cấu Hình iOS

**ios/Podfile:**
```ruby
platform :ios, '13.0'  # Firebase requires min 13.0
```

#### 2.4. Enable Firebase Services

Trong Firebase Console:
1. **Authentication** → Enable:
   - Anonymous
   - Email/Password
2. **Firestore Database** → Create database (Start in test mode)
3. **Rules** → Update:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Step 3: Unity Ads Setup

#### 3.1. Tạo Unity Ads Account
1. Truy cập [Unity Dashboard](https://dashboard.unity3d.com/)
2. Tạo project mới: `Fresh Keeper`
3. Monetization → Ads → Enable

#### 3.2. Lấy Game IDs
- **Android Game ID**: `1234567` (thay thế)
- **iOS Game ID**: `7654321` (thay thế)

#### 3.3. Tạo Ad Placements
1. **Banner**:
   - Placement ID: `Banner_Android` / `Banner_iOS`
   - Type: Banner
2. **Interstitial**:
   - Placement ID: `Interstitial_Android` / `Interstitial_iOS`
   - Type: Interstitial

#### 3.4. Update Ads Service

**lib/services/ads_service.dart:**
```dart
// Thay TEST IDs bằng IDs thực của bạn
static const String _androidGameId = 'YOUR_ANDROID_GAME_ID';
static const String _iosGameId = 'YOUR_IOS_GAME_ID';
```

#### 3.5. Cấu Hình Android Manifest

**android/app/src/main/AndroidManifest.xml:**
```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXX~XXXXX"/>
    </application>
</manifest>
```

#### 3.6. Cấu Hình iOS Info.plist

**ios/Runner/Info.plist:**
```xml
<key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>4dzt52r2t5.skadnetwork</string>
    </dict>
</array>
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXX~XXXXX</string>
```

### Step 4: In-App Purchase Setup

#### 4.1. Google Play Console (Android)

1. **Tạo App** trong [Google Play Console](https://play.google.com/console/)
2. **Monetization → Products** → Create:

**Subscription Products:**
- Product ID: `fresh_keeper_premium_monthly`
  - Price: $0.99/month
  - Billing period: 1 month

- Product ID: `fresh_keeper_premium_yearly`
  - Price: $8.99/year
  - Billing period: 1 year

**One-time Product:**
- Product ID: `fresh_keeper_premium_lifetime`
  - Price: $19.99
  - Type: Non-consumable

3. **Tạo License Testers** cho testing

#### 4.2. App Store Connect (iOS)

1. **Tạo App** trong [App Store Connect](https://appstoreconnect.apple.com/)
2. **In-App Purchases** → Create:

**Auto-Renewable Subscriptions:**
- Reference Name: Premium Monthly
  - Product ID: `fresh_keeper_premium_monthly`
  - Price: $0.99
  - Duration: 1 month

- Reference Name: Premium Yearly
  - Product ID: `fresh_keeper_premium_yearly`
  - Price: $8.99
  - Duration: 1 year

**Non-Consumable:**
- Reference Name: Premium Lifetime
  - Product ID: `fresh_keeper_premium_lifetime`
  - Price: $19.99

3. **Tạo Sandbox Testers** cho testing

#### 4.3. Update Subscription Service

**lib/services/subscription_service.dart:**
```dart
// Product IDs đã được định nghĩa sẵn
// Đảm bảo match với Google Play & App Store
```

---

## 🏗️ Architecture

### Services Layer
```
lib/services/
├── auth_service.dart           # Firebase Authentication
├── subscription_service.dart   # IAP & Premium management
└── ads_service.dart            # Unity Ads management
```

### Providers (Cần tạo)
```
lib/presentation/providers/
├── subscription_provider.dart  # Premium state management
└── ads_provider.dart           # Ads state management
```

### Screens (Cần tạo)
```
lib/presentation/screens/
├── auth/
│   ├── login_screen.dart
│   └── register_screen.dart
└── subscription/
    └── premium_screen.dart
```

### Widgets (Cần tạo)
```
lib/presentation/widgets/
└── ads/
    ├── banner_ad_widget.dart
    └── premium_badge_widget.dart
```

---

## 🎨 UI Integration

### 1. Banner Ads Placement

**Vị trí hiển thị:**
- ✅ Home Screen (Dashboard) - Bottom
- ✅ All Items Screen - Bottom
- ✅ Expiring Soon Screen - Bottom
- ✅ Settings Screen - Bottom

**Không hiển thị banner:**
- ❌ Add Product Screen
- ❌ Product Detail Screen
- ❌ Edit Product Screen

### 2. Interstitial Ads Trigger

**Hiển thị sau:**
1. Thêm sản phẩm thứ 3 (count = 3)
2. Reset counter về 0
3. Đợi ít nhất 3 phút trước khi hiển thị lại

### 3. Premium Badge

**Hiển thị tại:**
- Settings Screen - Phía trên
- Home Screen - Góc trên phải (nếu là premium)

---

## 🧪 Testing

### Test Mode Configuration

**Unity Ads:**
```dart
// In lib/main.dart or initialization
await adsService.initialize(testMode: true);  // Use test ads
```

**In-App Purchase:**
- Android: Use license test accounts
- iOS: Use sandbox test accounts

### Test Flow

1. **Free User Experience:**
   ```
   - Mở app → Thấy banner ads
   - Thêm 3 sản phẩm → Popup ad xuất hiện
   - Đợi 3 phút → Có thể thêm 3 sản phẩm nữa → Popup ad lại xuất hiện
   ```

2. **Premium User Experience:**
   ```
   - Settings → Upgrade to Premium
   - Chọn gói → Thanh toán
   - Tất cả ads biến mất
   - Badge "Premium" xuất hiện
   ```

3. **Restore Purchase:**
   ```
   - Cài đặt lại app
   - Settings → Restore Purchase
   - Premium status được khôi phục
   ```

---

## 🚀 Production Deployment

### Pre-Launch Checklist

#### Unity Ads
- [ ] Thay test Game IDs bằng production IDs
- [ ] Set `testMode: false`
- [ ] Verify ad placements hoạt động

#### Firebase
- [ ] Update Firestore security rules
- [ ] Enable email verification (optional)
- [ ] Setup Firebase Analytics
- [ ] Configure Cloud Functions (optional)

#### In-App Purchase
- [ ] Tạo và submit tất cả products
- [ ] Test với sandbox accounts
- [ ] Setup server-side receipt validation (recommended)
- [ ] Implement subscription status webhooks

#### Privacy & Legal
- [ ] Update Privacy Policy (mention ads & data collection)
- [ ] Add "Restore Purchase" button
- [ ] Add "Terms of Service"
- [ ] GDPR compliance (if targeting EU)
- [ ] Add consent dialog for ads

---

## 📊 Analytics & Monitoring

### Recommended Events to Track

```dart
// Firebase Analytics
- ad_impression (banner/interstitial)
- premium_purchase_initiated
- premium_purchase_completed
- ad_clicked
- restore_purchase
```

### Key Metrics to Monitor

1. **Ad Performance:**
   - Ad impression rate
   - Ad click-through rate (CTR)
   - Revenue per user (RPU)

2. **Conversion:**
   - Free → Premium conversion rate
   - Trial → Paid conversion
   - Restoration rate

3. **User Retention:**
   - Day 1, 7, 30 retention
   - Churn rate for premium users

---

## 💡 Tips & Best Practices

### Ads Strategy
1. **Don't overdo it**: Quá nhiều ads → người dùng uninstall
2. **Strategic placement**: Banner ở bottom, không che nội dung
3. **Respect user**: Popup ad sau hành động hoàn thành, không giữa workflow
4. **Test thoroughly**: Đảm bảo ads không làm crash app

### Premium Strategy
1. **Value proposition**: Rõ ràng giá trị của premium
2. **Pricing**: Competitive với apps tương tự
3. **Free trial**: Consider offering 7-day free trial
4. **Discounts**: Discount cho yearly (save 30-40%)

### Technical
1. **Error handling**: Graceful fallback khi ads fail to load
2. **Loading states**: Show loading khi processing purchase
3. **Offline support**: Cache premium status locally
4. **Testing**: Test trên real devices, not just emulator

---

## 🐛 Troubleshooting

### Unity Ads không hiển thị
```
- Check Game ID đúng chưa
- Verify ad placements đã được tạo
- Check internet connection
- Enable test mode để xem có ads test không
```

### IAP không hoạt động
```
- Verify product IDs match exactly
- Check bundle ID/package name
- Ensure billing is enabled for testing accounts
- Clear app data and reinstall
```

### Firebase Authentication fail
```
- Check google-services.json/GoogleService-Info.plist exists
- Verify package name/bundle ID match Firebase
- Enable Authentication methods in Firebase Console
```

---

## 📞 Support & Resources

### Documentation
- [Unity Ads Flutter Plugin](https://github.com/unity-ads/flutter-package)
- [In-App Purchase Package](https://pub.dev/packages/in_app_purchase)
- [Firebase Flutter](https://firebase.flutter.dev/)

### Communities
- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://reddit.com/r/flutterdev)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

## ✅ Next Steps

1. **Đọc kỹ guide này**
2. **Run `flutter pub get`**
3. **Setup Firebase** (quan trọng nhất)
4. **Setup Unity Ads account**
5. **Tạo IAP products**
6. **Chạy app với test mode**
7. **Test toàn bộ flow**
8. **Chuẩn bị production**

Chúc bạn thành công! 🚀💰
