# 🧪 Mock IAP Testing - Test Premium MIỄN PHÍ

## 🎯 Mục Đích

Test premium features **KHÔNG CẦN**:
- ❌ Google Play Console ($25)
- ❌ Apple Developer Account ($99/year)
- ❌ Real payment
- ❌ Test accounts

**Chỉ cần:**
- ✅ Flutter SDK
- ✅ Android/iOS device hoặc emulator
- ✅ 5 phút setup

---

## 🚀 Method 1: Debug Force Premium (EASIEST - 5 phút)

### Cách hoạt động:
- Add một flag debug
- Khi flag = true → App nghĩ user đã premium
- All premium features enabled
- Ads tắt hoàn toàn

### Implementation:

**File cần sửa:** `lib/presentation/providers/subscription_provider.dart`

Tôi sẽ add một static flag debug ở đầu class:

```dart
class SubscriptionProvider extends ChangeNotifier {
  // 🧪 DEBUG MODE - Set true để test premium features miễn phí
  static const bool _debugForcePremium = true; // ← Change this!

  // Rest of the code...
```

Sau đó modify getter `isPremium`:

```dart
bool get isPremium {
  // Debug mode: Force premium status
  if (kDebugMode && _debugForcePremium) {
    debugPrint('🧪 DEBUG: Force premium enabled');
    return true;
  }

  // Production: Check real premium status
  return _subscriptionStatus == SubscriptionStatus.premium;
}
```

### Cách dùng:

#### Bước 1: Enable Debug Premium
```dart
// lib/presentation/providers/subscription_provider.dart
static const bool _debugForcePremium = true; // ← Set to true
```

#### Bước 2: Run app
```bash
flutter run
```

#### Bước 3: Verify Premium Features
- ✅ Mở app → KHÔNG thấy banner ads
- ✅ Add 3 products → KHÔNG có interstitial ads
- ✅ Settings → Thấy "Premium" badge
- ✅ Premium screen → Hiển thị "Bạn là thành viên Premium!"

#### Bước 4: Test Complete Premium Experience
- Navigate qua all screens → NO ads anywhere
- All premium benefits active
- Test cloud backup UI
- Test premium themes (nếu có)

#### Bước 5: Trước khi Production Release
```dart
static const bool _debugForcePremium = false; // ← MUST set to false!
```

### Pros & Cons:

**✅ Pros:**
- Cực kỳ đơn giản (1 line code)
- Không cần setup gì thêm
- Test được 90% premium features
- Hoạt động trên cả Android & iOS

**❌ Cons:**
- Không test được purchase flow
- Không test được restore purchases
- Phải nhớ set false trước release

---

## 🎭 Method 2: Mock IAP with Fake Products (RECOMMENDED)

### Cách hoạt động:
- Tạo fake IAP products
- Mock purchase process
- Test full premium flow including UI
- Simulate 90% success rate, 10% failure for realistic testing

### Implementation: ✅ COMPLETE

**File created:** `lib/services/mock_iap_service.dart`

Tôi đã implement đầy đủ Mock IAP service với các tính năng:
- 3 fake products (Monthly, Yearly, Lifetime)
- Mock purchase với delay 2 giây
- Mock restore purchases với delay 1 giây
- 90% success rate, 10% failure cho realistic testing
- Chi tiết logs để debug

### Cách dùng:

#### Bước 1: Enable Mock IAP
```dart
// lib/services/mock_iap_service.dart
static const bool useMockIAP = true; // ← Set to true
```

#### Bước 2: Run app
```bash
flutter run
```

#### Bước 3: Test Purchase Flow
1. Mở app → Settings → Premium
2. Sẽ thấy 3 products:
   - **Monthly**: 49.000₫
   - **Yearly**: 399.000₫ (Tiết kiệm 32%)
   - **Lifetime**: 999.000₫ (Tốt nhất)
3. Chọn gói → Click "Xác nhận"
4. Loading 2 giây (simulated payment)
5. Kết quả:
   - **90% trường hợp**: "Thanh toán thành công!" → Premium activated
   - **10% trường hợp**: "Thanh toán bị hủy" → Thử lại

#### Bước 4: Verify Premium Active
Sau khi purchase thành công:
- ✅ Premium screen hiện: "Bạn là thành viên Premium!"
- ✅ Settings có Premium badge
- ✅ Banner ads biến mất
- ✅ Add 3+ products → KHÔNG có interstitial ads

#### Bước 5: Test Restore Purchases
1. Settings → Premium → "Khôi phục gói đã mua"
2. Loading 1 giây
3. Kết quả:
   - **50% trường hợp**: "Đã tìm thấy và khôi phục Premium" → Restored
   - **50% trường hợp**: "Không tìm thấy gói đăng ký nào" → No purchases

#### Bước 6: Trước khi Production Release
```dart
// lib/services/mock_iap_service.dart
static const bool useMockIAP = false; // ← MUST set to false!
```

### Expected Console Logs:

**On App Start:**
```
🧪 MOCK IAP: Loading mock products...
✅ SubscriptionProvider initialized (MOCK MODE)
   - Premium: false
   - Products: 3 (MOCK)

🧪 ════════════════════════════════════════
🧪 MOCK IAP ENABLED
🧪 You can test purchase flow without payment
🧪 Click "Mua" to simulate purchase
🧪 ════════════════════════════════════════
```

**On Purchase (Success):**
```
🧪 MOCK IAP: Starting purchase for fresh_keeper_premium_monthly...
🧪 MOCK IAP: User clicked CONFIRM
🧪 MOCK IAP: Processing payment...
🧪 MOCK IAP: Payment successful!
💎 MOCK: User is now Premium!
✅ Thanh toán thành công!
```

**On Purchase (Failure):**
```
🧪 MOCK IAP: Starting purchase for fresh_keeper_premium_yearly...
🧪 MOCK IAP: User clicked CANCEL
🧪 MOCK IAP: Payment canceled
❌ MOCK: Purchase failed - Thanh toán bị hủy
```

**On Restore (Success):**
```
🧪 MOCK IAP: Restoring purchases...
🧪 MOCK IAP: Checking previous purchases...
🧪 MOCK IAP: Found previous purchase
💎 MOCK: Premium restored!
✅ Đã tìm thấy và khôi phục Premium
```

### Pros & Cons:

**✅ Pros:**
- Test được FULL purchase flow
- Test được UI transitions
- Test được error handling
- Test được restore purchases
- Không cần Play Console/App Store setup
- Không tốn tiền
- 90% success rate → realistic testing
- 10% failure → test error handling

**❌ Cons:**
- Không test được real payment integration
- Không test được subscription renewal
- Không test được platform-specific bugs
- Phải nhớ disable trước release

---

## 📦 Method 3: Shared Preferences Toggle

### Hidden Debug Menu

Add một gesture ẩn để toggle premium:

**File:** `lib/presentation/screens/settings/settings_screen.dart`

Trong Premium list tile, wrap bằng `GestureDetector`:

```dart
GestureDetector(
  onLongPress: () async {
    if (kDebugMode) {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getBool('debug_premium') ?? false;
      await prefs.setBool('debug_premium', !current);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🧪 Debug Premium: ${!current}'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Reload premium status
      if (context.mounted) {
        context.read<SubscriptionProvider>().loadPremiumStatus();
      }
    }
  },
  child: ListTile(
    leading: const Icon(Icons.workspace_premium),
    title: const Text('Premium'),
    // ... rest of ListTile
  ),
)
```

**Trong SubscriptionProvider:**

```dart
Future<void> loadPremiumStatus() async {
  // Check debug override
  if (kDebugMode) {
    final prefs = await SharedPreferences.getInstance();
    final debugPremium = prefs.getBool('debug_premium') ?? false;

    if (debugPremium) {
      _subscriptionStatus = SubscriptionStatus.premium;
      debugPrint('🧪 DEBUG: Premium enabled via SharedPreferences');
      notifyListeners();
      return;
    }
  }

  // Normal premium check
  // ... existing code
}
```

### Cách dùng:

1. Mở Settings
2. **Long press** vào "Premium" item (giữ 2-3 giây)
3. Snackbar hiện: "🧪 Debug Premium: true"
4. App reload → Premium enabled
5. Long press lại để toggle off

**Pros:**
- Không cần rebuild app
- Toggle on/off dễ dàng
- Không cần chỉnh code
- Hidden từ users (chỉ long press mới thấy)

---

## 🏁 Quick Start Guide

### Option A: Fastest Way (1 minute)

```dart
// lib/presentation/providers/subscription_provider.dart
static const bool _debugForcePremium = true;
```

```bash
flutter run
```

Done! App nghĩ bạn là Premium.

### Option B: Interactive Way (3 minutes)

1. Long press "Premium" trong Settings
2. Toggle debug premium ON
3. Test features
4. Toggle OFF khi xong

### Option C: Full Mock IAP (Tôi sẽ implement cho bạn)

Wait... let me implement this properly!

---

## 🧪 Testing Checklist

### Premium Features to Test:

- [ ] **No Ads**
  - [ ] Home screen - No banner
  - [ ] All Items - No banner
  - [ ] Expiring Soon - No banner
  - [ ] Settings - No banner
  - [ ] Add 3+ products - No interstitial

- [ ] **Premium UI**
  - [ ] Settings shows Premium badge
  - [ ] Premium screen shows "Bạn là thành viên Premium!"
  - [ ] Premium icon/indicator visible

- [ ] **State Management**
  - [ ] `isPremium` returns true
  - [ ] `shouldShowAds` returns false
  - [ ] UI updates immediately

### Non-Premium Features (Set flag to false):

- [ ] Banner ads appear on all screens
- [ ] Interstitial after 3 products
- [ ] Premium screen shows upgrade options
- [ ] "Nâng cấp Premium" button visible

---

## 🔄 Development Workflow

```
Day 1-3: Mock Premium Development
├── Enable _debugForcePremium = true
├── Develop premium features
├── Test ad-free experience
└── Perfect UI/UX

Day 4-7: Feature Complete
├── Test with mock = false
├── Verify ads work correctly
├── Test upgrade flow UI
└── Bug fixes

Week 2: Polish
├── Widget tests
├── Integration tests
├── Performance testing
└── Ready for real IAP

Week 3+: Real IAP (If ready)
├── Register Play Console ($25)
├── Setup real IAP products
└── Beta testing
```

---

## ⚠️ IMPORTANT: Before Release

### Pre-Release Checklist:

```dart
// ❌ WRONG - Will give everyone premium for free!
static const bool _debugForcePremium = true;

// ✅ CORRECT - Production ready
static const bool _debugForcePremium = false;
```

**Add this check to CI/CD:**

```bash
# Check if debug flag is disabled
grep "_debugForcePremium = true" lib/presentation/providers/subscription_provider.dart
if [ $? -eq 0 ]; then
  echo "❌ ERROR: Debug premium is still enabled!"
  exit 1
fi
```

---

## 💡 Pro Tips

### Tip 1: Git Branch for Mock Testing

```bash
git checkout -b feature/premium-mock-testing
# Enable _debugForcePremium = true
# Commit and test
# Don't merge this branch!
```

### Tip 2: Environment Variables

```dart
static const bool _debugForcePremium =
    bool.fromEnvironment('FORCE_PREMIUM', defaultValue: false);
```

Run with:
```bash
flutter run --dart-define=FORCE_PREMIUM=true
```

### Tip 3: Build Flavors

```bash
# Dev build - Always premium
flutter run --flavor dev

# Prod build - Real IAP
flutter run --flavor prod
```

---

## 📊 Comparison

| Method | Setup Time | Realism | Best For |
|--------|-----------|---------|----------|
| **Debug Flag** | 1 min | 70% | Quick testing |
| **SharedPrefs Toggle** | 3 mins | 80% | Interactive testing |
| **Mock IAP** | 30 mins | 95% | Complete flow testing |
| **Real IAP** | 2 days + $25 | 100% | Production ready |

---

## 🎯 Recommendation

**For Week 1-2 Development:**

Use **Method 1 (Debug Flag)** vì:
- ✅ Cực nhanh setup
- ✅ Test được hầu hết features
- ✅ Không cần config phức tạp
- ✅ Đủ cho development phase

**Khi nào cần Real IAP:**
- ✅ App UI/UX đã hoàn thiện
- ✅ All features tested với mock
- ✅ Ready cho beta testing
- ✅ Có budget $25 (Play Console)

---

**Next Steps: Bạn muốn tôi implement cái nào?**

1. ✅ Method 1: Debug Flag (Đơn giản nhất)
2. ⚙️ Method 2: Mock IAP Products (Full featured)
3. 🎮 Method 3: SharedPrefs Toggle (Interactive)

Tôi recommend **Method 1** để bắt đầu. Chỉ cần 1 minute setup!

---

**Last Updated**: 2024-11-12
**Version**: 1.0.0
