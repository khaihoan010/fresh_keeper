# 🔍 Unity Ads Troubleshooting Guide

## Current Error Analysis

### Error in Logs:
```
❌ Banner ad failed to load: UnityAdsLoadError.internalError - unknown error
❌ Banner Ad failed: UnityAdsBannerError.webView - unknown error
   Placement ID: Banner_Android
```

### What This Means:

**Good News:**
- ✅ Unity Ads SDK initializes successfully
- ✅ Game ID is correct (5983297)
- ✅ Test mode is enabled
- ✅ Network permissions are now fixed

**The Problem:**
The error `UnityAdsBannerError.webView - unknown error` indicates the WebView failed to load the ad. This happens when:

1. **Placement ID doesn't exist in Unity Dashboard** ⚠️ MOST LIKELY CAUSE
2. No ad fill available (unlikely in test mode)
3. WebView configuration issues
4. Unity project not properly configured

---

## Root Cause Analysis

### Issue #1: Missing Placement IDs (PRIMARY CAUSE)

**Evidence:**
- Error specifically says `UnityAdsBannerError.webView - unknown error`
- This error occurs when Unity Ads tries to load a placement that doesn't exist
- Your code is looking for `Banner_Android` but this placement hasn't been created in Unity Dashboard yet

**Solution:** You MUST create the placement IDs in Unity Dashboard

**How to Fix:**
Follow the complete guide in `UNITY_DASHBOARD_SETUP.md`:

1. Go to https://dashboard.unity3d.com/
2. Navigate to: **Monetization → Ad Units** (or **Placements**)
3. Create these 4 placements:
   - `Banner_Android` (Banner, Android, Active)
   - `Banner_iOS` (Banner, iOS, Active)
   - `Interstitial_Android` (Video, Android, Active)
   - `Interstitial_iOS` (Video, iOS, Active)
4. Wait 2-5 minutes for changes to sync
5. Restart your app completely

### Issue #2: Missing Android Permissions (FIXED ✅)

**Evidence:**
```
W/UnityAds: Unity Ads was not able to get current network type due to missing permission
```

**Status:** ✅ **FIXED** - Added `INTERNET` and `ACCESS_NETWORK_STATE` permissions to AndroidManifest.xml

**Permissions Added:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

## Step-by-Step Fix Instructions

### Step 1: Verify Permissions (Already Done ✅)

The required Android permissions have been added to `AndroidManifest.xml`:
- ✅ `android.permission.INTERNET`
- ✅ `android.permission.ACCESS_NETWORK_STATE`

### Step 2: Create Placement IDs in Unity Dashboard (YOU MUST DO THIS)

This is the **CRITICAL STEP** that must be completed before ads will work:

1. **Login to Unity Dashboard**
   - Go to: https://dashboard.unity3d.com/
   - Login with your Unity account
   - Select your project

2. **Navigate to Ad Units**
   - Click: **Monetization** → **Ad Units** (or **Placements**)
   - You should see an "Add Ad Unit" or "Create Placement" button

3. **Create Banner_Android**
   - Click "Add Ad Unit"
   - **Ad Unit Name**: `Banner_Android` (EXACT match, case-sensitive!)
   - **Platform**: Android
   - **Ad Format**: Banner
   - **Status**: Active/Enabled
   - Save

4. **Create Banner_iOS**
   - Click "Add Ad Unit"
   - **Ad Unit Name**: `Banner_iOS`
   - **Platform**: iOS
   - **Ad Format**: Banner
   - **Status**: Active/Enabled
   - Save

5. **Create Interstitial_Android**
   - Click "Add Ad Unit"
   - **Ad Unit Name**: `Interstitial_Android`
   - **Platform**: Android
   - **Ad Format**: Video or Interstitial
   - **Status**: Active/Enabled
   - Save

6. **Create Interstitial_iOS**
   - Click "Add Ad Unit"
   - **Ad Unit Name**: `Interstitial_iOS`
   - **Platform**: iOS
   - **Ad Format**: Video or Interstitial
   - **Status**: Active/Enabled
   - Save

7. **Verify All Placements Exist**
   - Go back to Ad Units list
   - Confirm you see all 4 placements:
     ```
     ✅ Banner_Android (Active)
     ✅ Banner_iOS (Active)
     ✅ Interstitial_Android (Active)
     ✅ Interstitial_iOS (Active)
     ```

### Step 3: Wait for Sync

After creating placements:
- Wait **2-5 minutes** for Unity's servers to sync
- Changes are not instant!

### Step 4: Rebuild and Restart App

Important - you must do a **full rebuild**:

```bash
# Clean build
flutter clean

# Rebuild with permissions
flutter build apk

# Or run fresh install
flutter run
```

**Stop the app completely** (don't just hot reload) and **restart it**.

### Step 5: Verify Success

After restart, check logs for:

```
✅ Unity Ads initialized successfully
✅ Banner Ad loaded: Banner_Android
✅ AdsProvider initialization complete
```

You should see banner ads at the bottom of all screens:
- Home Screen
- All Items Screen
- Expiring Soon Screen
- Settings Screen

---

## Diagnostic Checklist

Before asking for help, verify ALL of these:

### Unity Dashboard Configuration
- [ ] Logged into Unity Dashboard (https://dashboard.unity3d.com/)
- [ ] Monetization is enabled for the project
- [ ] Game ID verified: `5983297` (Android) and `5983296` (iOS)
- [ ] Created `Banner_Android` placement
- [ ] Created `Banner_iOS` placement
- [ ] Created `Interstitial_Android` placement
- [ ] Created `Interstitial_iOS` placement
- [ ] All placements are **Active** (not disabled)
- [ ] Placement names match **EXACTLY** (case-sensitive!)
- [ ] Waited 2-5 minutes after creating placements

### App Configuration
- [ ] Android permissions added to AndroidManifest.xml
- [ ] App rebuilt with `flutter clean && flutter build apk`
- [ ] App completely stopped and restarted (not hot reload)
- [ ] Test mode is enabled in code
- [ ] Using correct placement IDs in code

### Network & Device
- [ ] Device has internet connection
- [ ] Not using VPN or proxy that blocks ads
- [ ] Device can access Unity's ad servers

---

## Expected vs Actual Behavior

### Current Behavior (Before Fix):
```
✅ Unity Ads initialized successfully
❌ Banner ad failed to load: UnityAdsLoadError.internalError
❌ Banner Ad failed: UnityAdsBannerError.webView - unknown error
```

### Expected Behavior (After Fix):
```
✅ Unity Ads initialized successfully
✅ Banner Ad loaded: Banner_Android
✅ AdsProvider initialization complete
[Banner ads visible on screen]
```

---

## Additional Troubleshooting

### If ads still don't work after creating placements:

1. **Check Unity Dashboard Status**
   - Go to: Monetization → Overview
   - Check if project is "Approved" or "Pending Review"
   - Test mode should work regardless, but verify status

2. **Verify Test Mode**
   - Check `lib/presentation/providers/ads_provider.dart`
   - Ensure: `await _adsService.initialize(testMode: true);`
   - Test mode = true should show test ads immediately

3. **Clear App Data**
   ```bash
   # Uninstall app completely
   flutter clean

   # Clear device cache
   adb shell pm clear com.example.fresh_keeper

   # Reinstall
   flutter run
   ```

4. **Check Unity Ads Status**
   - Visit: https://status.unity.com/
   - Verify Unity Ads services are operational

5. **Enable Verbose Logging**
   - All Unity Ads logs are already enabled with `debugPrint`
   - Check for any additional error messages in logcat

---

## Common Mistakes

### ❌ Mistake #1: Placement ID typo
- **Wrong**: `banner_android` (lowercase)
- **Correct**: `Banner_Android` (exact case match)

### ❌ Mistake #2: Not waiting for sync
- Created placements and immediately tested
- **Solution**: Wait 2-5 minutes after creating placements

### ❌ Mistake #3: Hot reload instead of restart
- Used hot reload or hot restart
- **Solution**: Stop app completely and restart

### ❌ Mistake #4: Forgot to rebuild
- Changed AndroidManifest.xml but didn't rebuild
- **Solution**: Run `flutter clean && flutter build apk`

### ❌ Mistake #5: Created placements in wrong project
- Unity Dashboard has multiple projects
- **Solution**: Verify you're in the project with Game ID 5983297

---

## Quick Test

To quickly verify if placements exist, check Unity Dashboard:

1. Login to https://dashboard.unity3d.com/
2. Go to: Monetization → Ad Units
3. Search for: `Banner_Android`

**If you see it:** ✅ Placement exists
**If you don't see it:** ❌ You need to create it

---

## Summary

**What was wrong:**
1. ✅ **FIXED**: Missing Android permissions (`INTERNET` and `ACCESS_NETWORK_STATE`)
2. ⚠️ **ACTION REQUIRED**: Placement IDs don't exist in Unity Dashboard yet

**What you need to do:**
1. ✅ Permissions are now fixed automatically
2. 🎯 **YOU MUST**: Go to Unity Dashboard and create the 4 placement IDs
3. 🎯 **YOU MUST**: Wait 2-5 minutes after creating them
4. 🎯 **YOU MUST**: Rebuild app with `flutter clean && flutter run`

**After completing these steps:**
- Banner ads will appear on all screens
- Interstitial ads will show after adding 3 products
- All monetization features will work

---

## Need More Help?

If ads still don't work after:
- ✅ Creating all placements in Unity Dashboard
- ✅ Waiting 2-5 minutes
- ✅ Rebuilding app completely
- ✅ Restarting app (not hot reload)

Then check:
- Unity Ads Documentation: https://docs.unity.com/ads/
- Unity Forum: https://forum.unity.com/forums/unity-ads.67/
- Unity Support: Contact Unity support with your Game ID

---

**Last Updated**: 2024-11-12
**Version**: 1.1.0
