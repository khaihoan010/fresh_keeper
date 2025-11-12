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

### Implementation:

Tôi sẽ implement đầy đủ cho bạn. Let me create the files:

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
