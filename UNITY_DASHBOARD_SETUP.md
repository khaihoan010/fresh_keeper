# 🎮 Unity Dashboard Setup Guide

## Step 1: Login to Unity Dashboard

1. Go to https://dashboard.unity3d.com/
2. Login with your Unity account
3. Select your project

## Step 2: Enable Monetization

1. In the left sidebar, click **Monetization**
2. If not enabled, click **Enable Monetization**
3. Read and accept the Unity Ads Terms of Service

## Step 3: Get Your Game IDs

Your Game IDs are already in the code:
- **Android Game ID**: `5983297`
- **iOS Game ID**: `5983296`

Verify these match your Unity Dashboard:
1. Go to **Monetization → Settings**
2. Check **Game ID** for Android and iOS
3. If they don't match, update the IDs in `lib/services/ads_service.dart`

## Step 4: Create Ad Placements

You need to create custom ad placements for each platform and ad type.

### 4.1 Create Banner Placements

1. Go to **Monetization → Ad Units** (or **Placements**)
2. Click **Add Placement** or **Create New Placement**
3. Create the following banner placements:

**Banner for Android:**
- **Placement ID**: `Banner_Android`
- **Placement Type**: Banner
- **Platform**: Android
- **Default State**: Enabled

**Banner for iOS:**
- **Placement ID**: `Banner_iOS`
- **Placement Type**: Banner
- **Platform**: iOS
- **Default State**: Enabled

### 4.2 Create Interstitial Placements

**Interstitial for Android:**
- **Placement ID**: `Interstitial_Android`
- **Placement Type**: Interstitial (or Video)
- **Platform**: Android
- **Default State**: Enabled

**Interstitial for iOS:**
- **Placement ID**: `Interstitial_iOS`
- **Placement Type**: Interstitial (or Video)
- **Platform**: iOS
- **Default State**: Enabled

### 4.3 (Optional) Create Rewarded Placements

If you plan to add rewarded ads in the future:

**Rewarded for Android:**
- **Placement ID**: `Rewarded_Android`
- **Placement Type**: Rewarded
- **Platform**: Android

**Rewarded for iOS:**
- **Placement ID**: `Rewarded_iOS`
- **Placement Type**: Rewarded
- **Platform**: iOS

## Step 5: Verify Settings

After creating placements:

1. Go to **Monetization → Ad Units**
2. Verify all placements are **Active**
3. Check that placement IDs match exactly:
   ```
   ✅ Banner_Android
   ✅ Banner_iOS
   ✅ Interstitial_Android
   ✅ Interstitial_iOS
   ```

## Step 6: Test Mode Settings

During development, always use **Test Mode**:

1. In your code (`lib/presentation/providers/ads_provider.dart`):
   ```dart
   await _adsService.initialize(testMode: true); // ← Keep true for development
   ```

2. Unity Dashboard will show test ads regardless of your monetization status

## Step 7: Wait for Approval (If Needed)

- New Unity projects may require approval
- This can take 24-48 hours
- During this time, use **Test Mode** to see test ads
- Check project status: **Monetization → Overview**

## Common Issues

### Issue 1: Placements not found
**Error**: `UnityAdsBannerError.webView - unknown error`

**Solution**:
- Verify placement IDs in Dashboard match exactly (case-sensitive)
- Wait 5-10 minutes after creating placements for changes to propagate
- Clear app data and restart

### Issue 2: Project not approved yet
**Error**: No ads showing even with correct placements

**Solution**:
- Ensure Test Mode is enabled
- Test ads should show immediately in Test Mode
- Production ads require project approval

### Issue 3: Game ID mismatch
**Error**: `INVALID_GAME_ID`

**Solution**:
- Double-check Game IDs in Dashboard
- Update `lib/services/ads_service.dart` with correct IDs

## Alternative: Use Default Test Placements

While setting up custom placements, you can temporarily use Unity's default test placements:

**In `lib/services/ads_service.dart`:**
```dart
// Temporary: Use default test placements
static String get _bannerAdUnitId => 'banner';
static String get _interstitialAdUnitId => 'video';
```

**After Dashboard setup is complete:**
```dart
// Production: Use custom placements
static String get _bannerAdUnitId =>
    Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';
static String get _interstitialAdUnitId => Platform.isAndroid
    ? 'Interstitial_Android'
    : 'Interstitial_iOS';
```

## Verification Checklist

Before running the app:

- [ ] Logged into Unity Dashboard
- [ ] Monetization enabled for project
- [ ] Game IDs verified (5983297 Android, 5983296 iOS)
- [ ] Created `Banner_Android` placement
- [ ] Created `Banner_iOS` placement
- [ ] Created `Interstitial_Android` placement
- [ ] Created `Interstitial_iOS` placement
- [ ] All placements are **Active**
- [ ] Test Mode enabled in code

## Next Steps

After completing setup:

1. Restart your app completely
2. Check logs for:
   ```
   ✅ Unity Ads initialized successfully
   ✅ Banner Ad loaded: Banner_Android
   ```
3. Banner ads should appear at bottom of screens
4. Test interstitial by adding 3 products

## Support

If issues persist:
- Unity Ads Documentation: https://docs.unity.com/ads/
- Unity Forum: https://forum.unity.com/forums/unity-ads.67/
- Unity Ads Status: https://status.unity.com/

---

**Created**: 2024-11-12
**Version**: 1.0.0
