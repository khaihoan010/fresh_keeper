# 💳 In-App Purchase Testing Guide - Hướng Dẫn Test Premium Payment

## 📋 Tổng Quan

Fresh Keeper có 3 gói Premium:
- **Monthly**: `fresh_keeper_premium_monthly` - Gói tháng
- **Yearly**: `fresh_keeper_premium_yearly` - Gói năm
- **Lifetime**: `fresh_keeper_premium_lifetime` - Mua 1 lần dùng mãi

---

## 🤖 Android - Google Play Store Testing

### Bước 1: Tạo App trong Google Play Console

1. Đăng nhập: https://play.google.com/console
2. Click **Create app**
3. Điền thông tin:
   - App name: Fresh Keeper
   - Default language: Vietnamese
   - App or game: App
   - Free or paid: Free
   - Declarations: Check all boxes
4. Click **Create app**

### Bước 2: Tạo In-App Products

1. Trong Google Play Console, vào app của bạn
2. Sidebar → **Monetize** → **In-app products**
3. Click **Create product**

#### Product 1: Monthly Subscription

**⚠️ LƯU Ý: Google Play yêu cầu dùng Subscription thay vì In-app product cho monthly/yearly!**

1. Vào **Monetize** → **Subscriptions**
2. Click **Create subscription**
3. Điền thông tin:
   - **Product ID**: `fresh_keeper_premium_monthly` (PHẢI GIỐNG CODE!)
   - **Name**: Fresh Keeper Premium - Monthly
   - **Description**: Trải nghiệm Fresh Keeper không giới hạn, không quảng cáo

4. **Base plans and offers**:
   - Click **Add base plan**
   - **Base plan ID**: `monthly-base`
   - **Billing period**: 1 month
   - **Price**: Chọn giá (VD: 49,000 VND)
   - **Renewal type**: Auto-renewing
   - **Grace period**: 3 days (recommended)

5. Click **Activate** sau khi hoàn thành

#### Product 2: Yearly Subscription

1. Click **Create subscription**
2. Điền:
   - **Product ID**: `fresh_keeper_premium_yearly`
   - **Name**: Fresh Keeper Premium - Yearly
   - **Description**: Tiết kiệm 32% so với gói tháng

3. **Base plans**:
   - **Base plan ID**: `yearly-base`
   - **Billing period**: 1 year
   - **Price**: 399,000 VND (32% off so với monthly)
   - **Renewal type**: Auto-renewing

4. Click **Activate**

#### Product 3: Lifetime (One-time purchase)

Vì Lifetime không phải subscription:

1. Vào **Monetize** → **In-app products**
2. Click **Create product**
3. Điền:
   - **Product ID**: `fresh_keeper_premium_lifetime`
   - **Name**: Fresh Keeper Premium - Lifetime
   - **Description**: Mua 1 lần, dùng mãi mãi. Không cần đăng ký hàng tháng
   - **Price**: 999,000 VND
4. **Status**: Active
5. Click **Save**

### Bước 3: Tạo Internal Testing Track

1. Sidebar → **Release** → **Testing** → **Internal testing**
2. Click **Create new release**
3. Upload APK/AAB:
   ```bash
   flutter build appbundle --release
   ```
4. APK sẽ ở: `build/app/outputs/bundle/release/app-release.aab`
5. Upload file này lên Google Play Console
6. Click **Save** → **Review release** → **Start rollout to Internal testing**

### Bước 4: Thêm Test Accounts (License Testers)

1. Sidebar → **Setup** → **License testing**
2. Trong **License testers** section:
   - Click **Create list** hoặc **Add**
   - Thêm email Gmail của người test
   - VD: `your.email@gmail.com`
3. **License test response**: Chọn **Respond normally**
4. Click **Save changes**

**QUAN TRỌNG**: License testers có thể test IAP **MIỄN PHÍ** mà không bị charge!

### Bước 5: Join Internal Testing

1. Vào **Internal testing** track
2. Copy **Opt-in URL**
3. Mở URL trên thiết bị Android (đăng nhập với test account)
4. Click **Become a tester**
5. Download app từ Play Store
6. Giờ bạn có thể test IAP miễn phí!

### Bước 6: Test IAP trên Android

1. Mở app Fresh Keeper
2. Vào **Settings** → Click **Premium**
3. Chọn gói subscription
4. Click **Xác nhận**
5. Play Store payment dialog hiện ra
6. Vì bạn là license tester → **KHÔNG BỊ CHARGE TIỀN**
7. Confirm purchase
8. App sẽ nhận được premium status ngay lập tức

**Expected behavior:**
```
I/flutter: ✅ Purchase completed successfully
I/flutter: 🔄 Premium status changed: true
I/flutter: 💎 User is now Premium!
```

---

## 🍎 iOS - App Store Testing

### Bước 1: Tạo App trong App Store Connect

1. Đăng nhập: https://appstoreconnect.apple.com/
2. Click **My Apps** → **+** → **New App**
3. Điền thông tin:
   - **Platform**: iOS
   - **Name**: Fresh Keeper
   - **Primary Language**: Vietnamese
   - **Bundle ID**: com.example.fresh_keeper (hoặc bundle ID của bạn)
   - **SKU**: fresh_keeper_001
   - **User Access**: Full Access
4. Click **Create**

### Bước 2: Tạo In-App Purchases

1. Trong app của bạn, click **In-App Purchases**
2. Click **+** button

#### Product 1: Monthly Auto-Renewable Subscription

1. Select **Auto-Renewable Subscription**
2. Click **Create**
3. Điền thông tin:
   - **Reference Name**: Fresh Keeper Premium Monthly
   - **Product ID**: `fresh_keeper_premium_monthly` (PHẢI GIỐNG CODE!)
   - **Subscription Group**: Click **Create New**
     - **Subscription Group Reference Name**: Fresh Keeper Premium
     - Click **Create**

4. **Subscription Duration**: 1 Month
5. **Subscription Prices**:
   - Click **Add Subscription Pricing**
   - **Price**: Tier 10 (~$2.99 / 69,000 VND)
   - **Start Date**: Today
   - Click **Next**

6. **Localizations** (Vietnamese):
   - **Display Name**: Fresh Keeper Premium - Tháng
   - **Description**: Trải nghiệm không giới hạn, không quảng cáo. Gia hạn tự động mỗi tháng.

7. **Review Information**:
   - **Screenshot**: Upload 1 screenshot của Premium screen
   - **Review Notes**: "Premium subscription for ad-free experience"

8. Click **Save**

#### Product 2: Yearly Auto-Renewable Subscription

1. Click **+** trong In-App Purchases
2. Select **Auto-Renewable Subscription**
3. Điền:
   - **Reference Name**: Fresh Keeper Premium Yearly
   - **Product ID**: `fresh_keeper_premium_yearly`
   - **Subscription Group**: Fresh Keeper Premium (same group)
   - **Duration**: 1 Year
   - **Price**: Tier 50 (~$29.99 / 699,000 VND) - 32% savings
   - **Display Name**: Fresh Keeper Premium - Năm
   - **Description**: Tiết kiệm 32% so với gói tháng. Gia hạn tự động mỗi năm.

4. Click **Save**

#### Product 3: Lifetime Non-Consumable

1. Click **+** trong In-App Purchases
2. Select **Non-Consumable**
3. Điền:
   - **Reference Name**: Fresh Keeper Premium Lifetime
   - **Product ID**: `fresh_keeper_premium_lifetime`
   - **Price**: Tier 100 (~$99.99 / 2,290,000 VND)
   - **Display Name**: Fresh Keeper Premium - Trọn đời
   - **Description**: Mua 1 lần, sử dụng mãi mãi. Không cần đăng ký hàng tháng.

4. Click **Save**

### Bước 3: Submit In-App Purchases for Review

1. Sau khi tạo xong cả 3 products
2. Mỗi product → Click **Submit for Review**
3. Apple sẽ review (có thể mất 1-2 ngày)
4. **NOTE**: Bạn có thể test ngay cả khi chưa approved!

### Bước 4: Tạo Sandbox Test Account

1. Vào **Users and Access** (ở top menu)
2. Click **Sandbox** tab
3. Click **+** để thêm tester mới
4. Điền thông tin:
   - **First Name**: Test
   - **Last Name**: User
   - **Email**: `testuser@example.com` (email ảo, không cần tồn tại thật)
   - **Password**: Tạo password mạnh
   - **Confirm Password**: Nhập lại
   - **Region**: Vietnam
   - **App Store Territory**: Vietnam

5. Click **Invite**

**QUAN TRỌNG**:
- Email này KHÔNG cần là email thật
- Đây là sandbox account chỉ dùng để test
- Bạn có thể test IAP **MIỄN PHÍ** với account này

### Bước 5: Setup TestFlight (Optional nhưng recommended)

1. Trong App Store Connect, vào app của bạn
2. Click **TestFlight** tab
3. Build app:
   ```bash
   flutter build ipa --release
   ```
4. Upload lên App Store Connect qua **Transporter** app
5. Sau khi processing xong:
   - Vào **TestFlight** → **Internal Testing**
   - Click **+** → Thêm internal tester
   - Thêm email thật của bạn
   - Click **Start Testing**

6. Install **TestFlight** app từ App Store
7. Mở link invite → Install Fresh Keeper

### Bước 6: Test IAP trên iOS

**Cách 1: Test trên Simulator (KHÔNG thể test IAP thật)**
- IAP không hoạt động trên Simulator
- Chỉ có thể test UI/UX

**Cách 2: Test trên Real Device với Sandbox Account**

1. **QUAN TRỌNG**: Logout khỏi App Store account thật:
   - Settings → Your Name → Media & Purchases → Sign Out
   - **KHÔNG** sign out khỏi iCloud, chỉ sign out App Store!

2. Build và run app lên device:
   ```bash
   flutter run --release
   ```

3. Mở Fresh Keeper app
4. Vào **Settings** → **Premium**
5. Chọn gói subscription → Click **Xác nhận**
6. iOS sẽ hiện popup:
   ```
   Sign In to Continue

   Use Existing Apple ID
   Create New Apple ID
   Cancel
   ```

7. Click **Use Existing Apple ID**
8. Nhập **Sandbox test account**:
   - Email: `testuser@example.com`
   - Password: (password bạn đã tạo)

9. iOS sẽ hiển thị:
   ```
   [SANDBOX ENVIRONMENT]
   Fresh Keeper Premium - Tháng
   69,000đ

   Subscribe
   ```

10. Click **Subscribe**
11. Confirm với Face ID/Touch ID
12. **KHÔNG BỊ CHARGE TIỀN** vì đây là sandbox!
13. App nhận premium status ngay lập tức

**Expected behavior:**
```
I/flutter: ✅ Purchase completed successfully
I/flutter: 🔄 Premium status changed: true
I/flutter: 💎 User is now Premium!
I/flutter: 🚫 Ads hidden - User is Premium
```

---

## 🧪 Testing Checklist

### Pre-Testing Setup
- [ ] **Android**: App uploaded lên Internal Testing
- [ ] **Android**: Products created (2 subscriptions + 1 in-app)
- [ ] **Android**: License tester added
- [ ] **Android**: Joined internal testing track
- [ ] **iOS**: App created in App Store Connect
- [ ] **iOS**: 3 IAP products created
- [ ] **iOS**: Sandbox test account created
- [ ] **iOS**: Logged out of real App Store account on device

### Test Scenarios

#### 1. Test Purchase Flow
- [ ] Open Premium screen
- [ ] Verify 3 products display with correct prices
- [ ] Tap Monthly subscription
- [ ] Confirmation dialog appears
- [ ] Click Xác nhận
- [ ] Payment sheet appears
- [ ] Complete purchase
- [ ] Purchase success message
- [ ] Premium badge appears in Settings
- [ ] Banner ads disappear
- [ ] Interstitial ads disabled

#### 2. Test Premium Benefits
- [ ] Navigate to all screens - NO banner ads
- [ ] Add 3+ products - NO interstitial ads
- [ ] Premium icon/badge visible
- [ ] Premium screen shows "Bạn là thành viên Premium!"

#### 3. Test Restore Purchases
- [ ] Uninstall app
- [ ] Reinstall app
- [ ] Open Premium screen
- [ ] Should show as non-premium initially
- [ ] Click "Khôi phục gói đã mua"
- [ ] Premium status restored
- [ ] Ads disappear again

#### 4. Test Subscription Management

**Android:**
- [ ] Open Play Store
- [ ] Menu → Subscriptions
- [ ] Fresh Keeper Premium appears
- [ ] Can cancel subscription
- [ ] Can resubscribe

**iOS:**
- [ ] Settings → [Your Name] → Subscriptions
- [ ] Fresh Keeper Premium appears
- [ ] Can cancel subscription
- [ ] Can change plan

---

## 🐛 Common Issues & Solutions

### Issue 1: "No products available" trên Android

**Nguyên nhân:**
- Products chưa Active trong Play Console
- App chưa được published (ít nhất Internal Testing)
- License tester chưa được add

**Giải pháp:**
1. Verify products Active trong Play Console
2. Đảm bảo app đã upload lên Internal Testing
3. Add email vào License Testing
4. Wait 2-4 hours để Google sync

### Issue 2: "Cannot connect to iTunes Store" trên iOS

**Nguyên nhân:**
- Chưa logout App Store account
- Sandbox account chưa được tạo
- Network issue

**Giải pháp:**
1. Settings → Media & Purchases → Sign Out
2. Verify sandbox account trong App Store Connect
3. Thử lại với wifi khác
4. Restart device

### Issue 3: Purchase completed nhưng vẫn thấy ads

**Nguyên nhân:**
- `SubscriptionProvider` chưa cập nhật state
- Firebase chưa sync

**Giải pháp:**
1. Check logs:
   ```
   I/flutter: 🔄 Premium status changed: true
   ```
2. Restart app
3. Click "Khôi phục gói đã mua"

### Issue 4: "This is a test environment" popup liên tục

**iOS Sandbox:**
- Normal behavior
- Mỗi lần test purchase sẽ có popup này
- Click OK để continue

**Android:**
- Đảm bảo là License Tester
- Check setting trong License Testing

---

## 📊 Testing Timeline

### Google Play (Android)
- **Setup time**: 2-4 hours (cho products sync)
- **First test**: Có thể test ngay sau khi join Internal Testing
- **Repeated tests**: Instant (không bị charge)
- **Subscription renewal**: Test ngay lập tức (1 month = 5 minutes trong test mode)

### App Store (iOS)
- **Setup time**: 1-2 days (nếu submit for review)
- **First test**: Có thể test ngay với sandbox (không cần approval)
- **Repeated tests**: Instant (không bị charge)
- **Subscription renewal**: Test accelerated (1 month = 5 minutes)

---

## 💰 Sandbox vs Production

### Sandbox Testing (Development)
- ✅ Không bị charge tiền thật
- ✅ Có thể test unlimited lần
- ✅ Subscription renew nhanh (5 mins thay vì 1 month)
- ✅ Có thể cancel/refund tự do
- ❌ Chỉ hoạt động với test accounts
- ❌ Không có revenue thật

### Production (Live Users)
- ✅ Revenue thật vào tài khoản
- ✅ Users thật có thể mua
- ✅ Subscription auto-renew theo thời gian thật
- ⚠️ Cần careful testing trước khi release
- ⚠️ Refund policy phức tạp

---

## 🚀 Ready for Production

Trước khi release lên Production:

### Google Play
- [ ] All products Active
- [ ] Privacy Policy URL added
- [ ] Subscription cancellation policy clear
- [ ] App reviewed và approved
- [ ] Removed all test/debug code

### App Store
- [ ] All IAP products approved
- [ ] Privacy Policy in app
- [ ] Terms of Service clear
- [ ] Subscription management documented
- [ ] App reviewed và approved

---

## 📞 Support & Resources

### Google Play IAP
- Docs: https://developer.android.com/google/play/billing
- Testing: https://developer.android.com/google/play/billing/test
- Console: https://play.google.com/console

### App Store IAP
- Docs: https://developer.apple.com/in-app-purchase/
- Testing: https://developer.apple.com/documentation/storekit/in-app_purchase/testing
- Connect: https://appstoreconnect.apple.com/

### Flutter in_app_purchase plugin
- Package: https://pub.dev/packages/in_app_purchase
- Example: https://github.com/flutter/packages/tree/main/packages/in_app_purchase

---

**Last Updated**: 2024-11-12
**Version**: 1.0.0

**TÓM TẮT**:
- Android: Cần Internal Testing + License Tester để test miễn phí
- iOS: Cần Sandbox Account để test miễn phí
- Cả hai platform đều test được mà KHÔNG bị charge tiền!
