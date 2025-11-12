# 🧪 Unity Ads Testing Guide - Hướng Dẫn Test Unity Ads

## ✅ Tình trạng hiện tại

Dựa trên Unity Dashboard của bạn:

### Unity Dashboard Configuration
- ✅ **Placements đã tạo đầy đủ:**
  - Banner_Android (ID: Banner_Android)
  - Banner_iOS (ID: Banner_iOS)
  - Interstitial_Android (ID: Interstitial_Android)
  - Interstitial_iOS (ID: Interstitial_iOS)
  - Rewarded_Android (ID: Rewarded_Android)
  - Rewarded_iOS (ID: Rewarded_iOS)

- ✅ **Game IDs đúng:**
  - Google Play Store: 5983297
  - Apple App Store: 5983296

- ✅ **Test Mode enabled:**
  - Google Play Store: Using test ads for all devices
  - Apple App Store: Using test ads for all devices

- ✅ **Ad delivery enabled:**
  - Google Play Store: Ad delivery enabled
  - Apple App Store: Ad delivery enabled

### Code Configuration
- ✅ **Android permissions:** INTERNET, ACCESS_NETWORK_STATE
- ✅ **iOS permissions:** NSUserTrackingUsageDescription
- ✅ **iOS SKAdNetwork IDs:** 74 IDs đã được thêm đầy đủ

---

## 🔴 Vấn đề hiện tại

Log của bạn vẫn hiển thị 2 lỗi:

### 1. Permission Warning (Chưa áp dụng)
```
W/UnityAds: Unity Ads was not able to get current network type due to missing permission
```

**Nguyên nhân:** App chưa được rebuild đúng cách sau khi thêm permissions vào `AndroidManifest.xml`.

**Giải pháp:** Clean build hoàn toàn (hướng dẫn bên dưới)

### 2. Banner/Interstitial Load Error
```
❌ Banner ad failed to load: UnityAdsLoadError.internalError - unknown error
❌ Banner Ad failed: UnityAdsBannerError.webView - unknown error
```

**Nguyên nhân có thể:**
1. Placements mới tạo cần thêm thời gian để propagate (5-10 phút)
2. App chưa có permissions đúng (cần clean rebuild)
3. Placements có thể chưa "Active" trong Unity Dashboard

---

## 🛠️ GIẢI PHÁP: Clean Build Hoàn Toàn

Bạn cần làm theo **CHÍNH XÁC** các bước sau:

### Bước 1: Uninstall app cũ khỏi thiết bị

```bash
adb uninstall com.example.fresh_keeper
```

**Tại sao:** Đảm bảo permissions cũ được xóa hoàn toàn.

### Bước 2: Clean build directories

```bash
flutter clean
rm -rf build/
rm -rf android/build/
rm -rf android/app/build/
rm -rf .dart_tool/
```

**Tại sao:** Xóa toàn bộ cached build files.

### Bước 3: Get dependencies lại

```bash
flutter pub get
```

### Bước 4: Build và install lại

```bash
flutter run
```

**Quan trọng:** Đợi app build hoàn toàn, **KHÔNG dùng hot reload/hot restart!**

---

## 📱 Kiểm tra sau khi rebuild

### 1. Kiểm tra Permission Warning

Log **KHÔNG được** có dòng này:
```
W/UnityAds: Unity Ads was not able to get current network type due to missing permission
```

Nếu vẫn còn warning → Rebuild chưa đúng, làm lại từ đầu.

### 2. Kiểm tra Unity Ads Initialization

Log **PHẢI có** những dòng này:
```
✅ Unity Ads initialized successfully
📊 After UnityAds.init() - isInitialized: true
```

### 3. Kiểm tra Banner Ad Loading

**Nếu thành công:**
```
✅ Banner Ad loaded: Banner_Android
✅ AdsProvider initialization complete
```

**Nếu vẫn lỗi:**
```
❌ Banner ad failed to load: UnityAdsLoadError.internalError - unknown error
```

---

## 🕐 Nếu vẫn lỗi sau clean build

### Option 1: Đợi Placements Propagate

Placements mới tạo có thể cần **5-10 phút** để Unity servers sync.

**Làm gì:**
1. Đợi thêm 10 phút
2. Stop app hoàn toàn
3. Restart app

### Option 2: Kiểm tra Placement Status trong Unity Dashboard

1. Vào Unity Dashboard: https://dashboard.unity3d.com/
2. Go to: **Monetization → Ad Units**
3. Kiểm tra **mỗi placement:**
   - `Banner_Android` → Status phải là **Active** hoặc **Enabled**
   - `Banner_iOS` → Status phải là **Active** hoặc **Enabled**
   - `Interstitial_Android` → Status phải là **Active** hoặc **Enabled**
   - `Interstitial_iOS` → Status phải là **Active** hoặc **Enabled**

**Nếu status là "Disabled" hoặc "Paused":**
- Click vào placement
- Change status to **Active** hoặc **Enabled**
- Save
- Đợi 2-5 phút
- Restart app

### Option 3: Kiểm tra Test Mode

Trong Unity Dashboard → **Project Settings**:
- **Test mode** phải được enable
- **Google Play Store:** "Using test ads for all devices" ✅
- **Apple App Store:** "Using test ads for all devices" ✅

Nếu không phải "Using test ads", placements có thể cần approval để hiển thị production ads.

---

## 🎯 Expected Behavior - Kết quả mong đợi

Sau khi clean build và đợi placements propagate, bạn sẽ thấy:

### Log khi thành công:
```
I/flutter: 🎯 AdsProvider.initialize() called
I/flutter: 📱 Initializing Unity Ads...
I/flutter: 🎯 AdsService.initialize() called
I/flutter: 📱 Platform: Android
I/flutter: 🧪 Test Mode: true
I/flutter: 🎮 Game ID: 5983297
I/UnityAds: Initializing Unity Services 4.16.3 with game id 5983297 in test mode
I/flutter: ✅ Unity Ads initialized successfully
I/flutter: 📊 After UnityAds.init() - isInitialized: true
I/flutter: 📊 Unity Ads initialized: true
I/flutter: 📱 Loading banner ad...
I/flutter: ✅ Banner ad loaded
I/flutter: ✅ AdsProvider initialization complete
```

**Không có permission warning!**
**Không có "unknown error"!**

### Visual result:
- Banner ads xuất hiện ở **bottom** của tất cả screens:
  - ✅ Home Screen
  - ✅ All Items Screen
  - ✅ Expiring Soon Screen
  - ✅ Settings Screen

- Interstitial ads hiển thị sau khi **add 3 products**

---

## 🐛 Troubleshooting Checklist

Nếu ads vẫn không hoạt động, kiểm tra:

### Unity Dashboard
- [ ] Đã login vào Unity Dashboard
- [ ] Project đúng (Game ID: 5983297)
- [ ] Monetization enabled
- [ ] 4 placements đã tạo (Banner_Android, Banner_iOS, Interstitial_Android, Interstitial_iOS)
- [ ] Tất cả placements có status **Active**
- [ ] Test mode enabled
- [ ] Ad delivery enabled

### App Build
- [ ] Đã uninstall app cũ (`adb uninstall com.example.fresh_keeper`)
- [ ] Đã clean build directories (`flutter clean`, `rm -rf build/`...)
- [ ] Đã get dependencies (`flutter pub get`)
- [ ] Đã build lại (`flutter run`)
- [ ] **KHÔNG** dùng hot reload/hot restart
- [ ] Đã stop và restart app hoàn toàn

### Log Verification
- [ ] **KHÔNG** có permission warning về network type
- [ ] Unity Ads initialized successfully
- [ ] isInitialized: true
- [ ] **KHÔNG** có "unknown error"
- [ ] Banner ad loaded successfully

### Timing
- [ ] Đã đợi ít nhất 5-10 phút sau khi tạo placements
- [ ] Đã restart app sau khi đợi

### Network
- [ ] Device có internet connection
- [ ] Không dùng VPN/proxy chặn ads
- [ ] Có thể access Unity servers

---

## 📞 Next Steps

### Nếu vẫn không hoạt động sau tất cả các bước trên:

1. **Gửi screenshot Unity Dashboard:**
   - Monetization → Ad Units page
   - Cho tôi thấy tất cả placements và status của chúng

2. **Gửi full log:**
   - Chạy `flutter run` và copy toàn bộ log
   - Tìm đoạn từ "AdsProvider.initialize()" đến khi có error

3. **Kiểm tra Unity Ads Status:**
   - Visit: https://status.unity.com/
   - Verify Unity Ads services operational

---

## 💡 Tips

- **Test Mode quan trọng!** Trong development, **LUÔN** dùng test mode
- **Patience!** Placements mới cần thời gian propagate (5-10 phút)
- **Clean build is key!** Permissions chỉ apply sau clean build
- **Don't hot reload!** Rebuild hoàn toàn sau khi thay đổi permissions

---

**Last Updated**: 2024-11-12
**Version**: 1.0.0
