# 🐛 Unity Ads Debug Guide

## Lỗi Banner Ad: `UnityAdsBannerError.webView - unknown error`

### Nguyên nhân có thể:

#### 1. **Ads chưa được kích hoạt trong Unity Dashboard** ⚠️
Unity Ads cần thời gian review và kích hoạt ads. Trong khi chờ, bạn phải sử dụng **Test Mode**.

**Giải pháp:**
- Đảm bảo Test Mode đang bật trong code
- Kiểm tra trong Unity Dashboard xem ads đã được approve chưa

```dart
// lib/presentation/providers/ads_provider.dart
Future<void> initialize() async {
  try {
    await _adsService.initialize(testMode: true); // ← ĐẢM BẢO = true
    _isInitialized = _adsService.isInitialized;
    debugPrint('✅ Ads provider initialized');
  } catch (e) {
    debugPrint('❌ Error initializing ads provider: $e');
  }
}
```

#### 2. **Placement IDs chưa đúng**
Placement IDs phải khớp chính xác với Unity Dashboard.

**Kiểm tra:**
```
Banner Android: Banner_Android
Banner iOS: Banner_iOS
Interstitial Android: Interstitial_Android
Interstitial iOS: Interstitial_iOS
```

**Đã sửa trong commit gần nhất** ✅

#### 3. **Game IDs sai hoặc chưa kích hoạt**
```dart
Android Game ID: 5983297
iOS Game ID: 5983296
```

**Kiểm tra:**
1. Vào [Unity Dashboard](https://dashboard.unity3d.com/)
2. Project Settings → Monetization
3. Kiểm tra Game IDs có đúng không
4. Kiểm tra project status: **Active** hay **Not Active**

#### 4. **Network hoặc Webview Issues**
Unity Ads sử dụng WebView để hiển thị ads. Một số thiết bị Android cũ có thể có vấn đề.

**Giải pháp:**
- Test trên thiết bị Android mới hơn (API 21+)
- Kiểm tra internet connection
- Clear app data và thử lại

#### 5. **Ads chưa có inventory (không có quảng cáo để hiển thị)**
Trong Test Mode, Unity cung cấp test ads. Nhưng nếu Test Mode tắt mà chưa có advertiser, ads sẽ fail.

**Giải pháp:**
- Luôn dùng Test Mode trong development
- Chỉ tắt Test Mode khi app đã publish lên store

---

## 🔧 Các bước Debug

### Bước 1: Kiểm tra Unity Ads có initialize không

Xem log khi app start:
```
✅ Unity Ads initialized successfully
```

Nếu thấy:
```
❌ Unity Ads initialization failed: ...
```

→ Kiểm tra Game IDs

### Bước 2: Kiểm tra Test Mode

Trong file `lib/presentation/providers/ads_provider.dart`:
```dart
await _adsService.initialize(testMode: true); // ← Phải là true
```

### Bước 3: Xem log chi tiết

Khi banner ad fail, sẽ thấy log:
```
❌ Banner Ad failed: UnityAdsBannerError.webView - unknown error
   Placement ID: Banner_Android
   Platform: Android
   Expected ID: Banner_Android
```

Kiểm tra:
- Placement ID có đúng không?
- Platform detection có đúng không?

### Bước 4: Test với Interstitial Ad

Thử show interstitial ad để xem có cùng lỗi không:
```dart
// Thêm vào Add Product Screen sau khi add 3 products
final adsProvider = context.read<AdsProvider>();
await adsProvider.onProductAdded();
```

Nếu interstitial cũng fail → vấn đề ở Unity Ads initialization
Nếu interstitial hoạt động → vấn đề chỉ ở banner ads

---

## 🎯 Checklist Debug

- [ ] **Test Mode = true** trong development
- [ ] **Game IDs đúng** (5983297 Android, 5983296 iOS)
- [ ] **Placement IDs đúng** (Banner_Android, Banner_iOS, etc.)
- [ ] **Unity Dashboard** - Project đã kích hoạt
- [ ] **Internet connection** hoạt động
- [ ] **Thiết bị Android API 21+**
- [ ] **Clear app data** và test lại
- [ ] **Unity Ads SDK** version compatibility

---

## 📱 Test với Unity Test Ads

Trong Test Mode, Unity cung cấp test ads. Nếu vẫn không hiển thị:

### Option 1: Kiểm tra Unity Dashboard

1. Đăng nhập [Unity Dashboard](https://dashboard.unity3d.com/)
2. Chọn project
3. Monetization → Ad Units
4. Kiểm tra các ad units đã được tạo chưa:
   - Banner_Android
   - Banner_iOS
   - Interstitial_Android
   - Interstitial_iOS

Nếu chưa có, tạo mới với đúng IDs.

### Option 2: Thử với Default Test Placement

Unity có default test placements. Thử thay placement ID:

```dart
// Test với default banner placement
placementId: 'banner'  // thay vì 'Banner_Android'
```

Nếu hoạt động → vấn đề ở custom placement IDs trong Dashboard.

---

## 🚀 Production Checklist

Trước khi deploy production:

1. **Tắt Test Mode:**
```dart
await _adsService.initialize(testMode: false);
```

2. **Kiểm tra ads đã được approve** trong Unity Dashboard

3. **Test real ads** trên thiết bị thật

4. **Monitor revenue** trong Unity Dashboard

5. **Setup mediation** (optional) để tăng fill rate

---

## 📞 Support

Nếu vẫn gặp vấn đề:

1. **Unity Ads Documentation:**
   https://docs.unity.com/ads/

2. **Unity Forum:**
   https://forum.unity.com/forums/unity-ads.67/

3. **Check Unity Ads Status:**
   https://status.unity.com/

4. **Contact Unity Support:**
   Qua Unity Dashboard → Support

---

## 🔍 Common Errors

### `UnityAdsBannerError.webView - unknown error`
→ Ads chưa có inventory hoặc placement ID sai

### `UnityAdsInitializationError.INVALID_GAME_ID`
→ Game ID sai

### `UnityAdsLoadError.NO_FILL`
→ Không có ads để hiển thị (bật Test Mode)

### `UnityAdsLoadError.TIMEOUT`
→ Network timeout (kiểm tra internet)

### `UnityAdsShowError.NOT_INITIALIZED`
→ Unity Ads chưa initialize (đợi initialize xong)

---

## 📊 Expected Behavior

**Khi hoạt động đúng:**

1. App start:
```
✅ Unity Ads initialized successfully
```

2. Banner ad load:
```
✅ Banner Ad loaded: Banner_Android
```

3. User add 3 products:
```
📊 Product added. Count: 3
🎬 Showing interstitial ad after product threshold
✅ Interstitial ad loaded: Interstitial_Android
▶️ Interstitial ad started: Interstitial_Android
✅ Interstitial ad completed: Interstitial_Android
```

4. Premium user:
```
⚠️ Banner Ad not shown - Unity Ads not initialized
(Banner không hiển thị cho premium users)
```

---

**Updated:** 2024-11-12
**Version:** 1.0.0
