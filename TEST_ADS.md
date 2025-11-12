# 🧪 Test Unity Ads - Quick Guide

## Chạy app và kiểm tra log

```bash
flutter run
```

## ✅ Log mong đợi nếu thành công:

```
🎯 AdsProvider.initialize() called
📱 Initializing Unity Ads...
🎯 AdsService.initialize() called
📱 Platform: Android
🧪 Test Mode: true
🎮 Game ID: 5983297
📱 Calling UnityAds.init()...
✅ Unity Ads initialized successfully
📊 Loaded ad preferences:
  - Add product count: 0
  - Last interstitial: null
📊 After UnityAds.init() - isInitialized: true
📊 Unity Ads initialized: true
📱 Loading banner ad...
✅ Banner ad loaded
✅ AdsProvider initialization complete
✅ Banner Ad loaded: Banner_Android
```

## ❌ Log nếu thất bại:

### Scenario 1: Unity Ads initialization failed
```
❌ Unity Ads initialization failed: INVALID_ARGUMENT - invalid game id
   Error code: INVALID_ARGUMENT
   Message: invalid game id
```

**Giải pháp:** Kiểm tra Game IDs trong Unity Dashboard

### Scenario 2: Timeout
```
⏱️ Unity Ads initialization timeout
📊 After UnityAds.init() - isInitialized: false
```

**Giải pháp:**
- Kiểm tra internet connection
- Thử lại sau vài phút
- Kiểm tra Unity Ads service status

### Scenario 3: User is premium
```
🎯 AdsProvider.initialize() called
⚠️ User is premium, skipping ads initialization
```

**Giải pháp:** Đây là behavior đúng - Premium users không thấy ads

## 🔍 Debug Steps

### 1. Kiểm tra Unity Ads có initialize không:
Tìm log:
```
✅ Unity Ads initialized successfully
```

### 2. Kiểm tra Banner Ad có load không:
Tìm log:
```
✅ Banner Ad loaded: Banner_Android
```

### 3. Nếu thấy error:
```
❌ Unity Ads initialization failed: [ERROR] - [MESSAGE]
```

Đọc error message và check:
- `INVALID_ARGUMENT`: Game ID sai
- `NETWORK_ERROR`: Không có internet
- `NO_CONNECTION`: Unity Ads service down
- `TIMEOUT`: Initialization quá lâu

### 4. Nếu banner không hiển thị nhưng không có error:
Check Unity Dashboard:
1. Login vào https://dashboard.unity3d.com/
2. Chọn project (Game ID: 5983297 Android / 5983296 iOS)
3. Monetization → Placements
4. Kiểm tra `Banner_Android` và `Banner_iOS` đã được tạo chưa

## 📱 Test Flow

### Test 1: Banner Ad
1. ✅ Mở app → Home Screen
2. ✅ Scroll xuống dưới cùng
3. ✅ Thấy banner ad (hoặc placeholder nếu test mode)

### Test 2: Interstitial Ad
1. ✅ Thêm product lần 1 → không có ad
2. ✅ Thêm product lần 2 → không có ad
3. ✅ Thêm product lần 3 → **POPUP AD xuất hiện**
4. ✅ Đợi 3 phút
5. ✅ Thêm 3 products nữa → **POPUP AD xuất hiện lại**

### Test 3: Premium User
1. ✅ Navigate to Settings
2. ✅ Tap "Nâng cấp Premium"
3. ✅ (Giả lập premium) → Không thấy banner ads nữa

## 🐛 Common Issues

### Issue: "Unity Ads not initialized"
**Solution:** App cần restart để Unity Ads initialize. Đóng app hoàn toàn và mở lại.

### Issue: Banner hiện placeholder trắng
**Solution:** Test mode đang bật - ads sẽ hiện test content. Đây là normal.

### Issue: Popup ad không xuất hiện sau 3 products
**Solution:**
- Check log xem có message "🎬 Showing interstitial ad..."
- Nếu có "⏳ Interstitial ad cooldown..." → chưa đủ 3 phút

### Issue: Initialization timeout
**Solution:**
- Restart app
- Check internet
- Wait 5 minutes và thử lại (Unity Ads có thể rate limit)

## 📊 Expected Behavior

### On App Start:
- Unity Ads initialize trong ~2-5 giây
- Banner ads xuất hiện ở bottom của 4 screens:
  - Home Screen
  - All Items Screen
  - Expiring Soon Screen
  - Settings Screen

### On Add Product:
- Counter tăng (check log: "📊 Product added. Count: X")
- Sau 3 products + 3 phút → Interstitial ad

### Premium User:
- Không thấy banner ads
- Không thấy interstitial ads
- Settings screen hiện Premium badge

---

**Version:** 1.0.0
**Last Updated:** 2024-11-12
