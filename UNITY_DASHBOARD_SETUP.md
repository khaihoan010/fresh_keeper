# 🎮 Unity Dashboard Setup Guide

## ⚠️ IMPORTANT - You MUST complete this setup before ads will work!

The error `placement not found: banner` means your Unity project **has no ad placements created yet**. You need to create them in Unity Dashboard first.

---

## Step 1: Login to Unity Dashboard

1. Go to https://dashboard.unity3d.com/
2. Login with your Unity account
3. Select your project (should show Game IDs: 5983297 for Android, 5983296 for iOS)

## Step 2: Enable Monetization (If Not Already Enabled)

1. In the left sidebar, click **Monetization** or **Grow**
2. If not enabled, click **Enable Monetization**
3. Read and accept the Unity Ads Terms of Service
4. Wait for email confirmation (may take a few minutes)

## Step 3: Navigate to Ad Units / Placements

**Option A (Newer Dashboard):**
1. Click **Monetization** → **Ad Units**
2. You should see a page with "Add Ad Unit" button

**Option B (Older Dashboard):**
1. Click **Monetization** → **Placements**
2. You should see "Add Placement" or "Create Placement" button

## Step 4: Create Ad Placements (CRITICAL STEP)

⚠️ **You MUST create these exact placement IDs or ads will not work!**

### 4.1 Create Banner for Android

Click **Add Ad Unit** (or **Add Placement**) and fill in:

- **Ad Unit Name / Placement Name**: `Banner_Android`
- **Platform**: Android ✅
- **Ad Format / Ad Type**: Banner
- **Setup Type**: Waterfall (or Bidding if available)
- **Status**: Enabled / Active ✅

Click **Create** or **Save**

### 4.2 Create Banner for iOS

Click **Add Ad Unit** again:

- **Ad Unit Name / Placement Name**: `Banner_iOS`
- **Platform**: iOS ✅
- **Ad Format / Ad Type**: Banner
- **Setup Type**: Waterfall (or Bidding)
- **Status**: Enabled / Active ✅

Click **Create** or **Save**

### 4.3 Create Interstitial for Android

Click **Add Ad Unit** again:

- **Ad Unit Name / Placement Name**: `Interstitial_Android`
- **Platform**: Android ✅
- **Ad Format / Ad Type**: Video or Interstitial
- **Setup Type**: Waterfall (or Bidding)
- **Status**: Enabled / Active ✅

Click **Create** or **Save**

### 4.4 Create Interstitial for iOS

Click **Add Ad Unit** again:

- **Ad Unit Name / Placement Name**: `Interstitial_iOS`
- **Platform**: iOS ✅
- **Ad Format / Ad Type**: Video or Interstitial
- **Setup Type**: Waterfall (or Bidding)
- **Status**: Enabled / Active ✅

Click **Create** or **Save**

## Step 5: Verify All Placements Are Created

After creating all 4 placements, go to **Monetization → Ad Units** (or **Placements**) and verify:

```
✅ Banner_Android        (Banner, Android, Active)
✅ Banner_iOS            (Banner, iOS, Active)
✅ Interstitial_Android  (Video/Interstitial, Android, Active)
✅ Interstitial_iOS      (Video/Interstitial, iOS, Active)
```

**IMPORTANT**: The placement names must match **EXACTLY** (case-sensitive!)

## Step 6: Wait for Changes to Propagate & Restart App

After creating placements:
1. Wait 2-5 minutes for Unity Dashboard changes to sync
2. **Stop your app completely** (don't just reload)
3. **Restart the app** from scratch
4. If still not working, clear app data and try again

## Step 7: Expected Results

After completing setup and restarting, you should see in logs:

```
✅ Unity Ads initialized successfully
✅ Banner Ad loaded: Banner_Android
✅ AdsProvider initialization complete
```

And banner ads should appear at the bottom of all screens.

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

---

## ✅ SETUP COMPLETION CHECKLIST

Before running the app, verify you've completed ALL steps:

- [ ] Logged into Unity Dashboard (https://dashboard.unity3d.com/)
- [ ] Monetization enabled for project
- [ ] Game IDs verified (5983297 Android, 5983296 iOS)
- [ ] Created **Banner_Android** placement (Banner, Android, Active)
- [ ] Created **Banner_iOS** placement (Banner, iOS, Active)
- [ ] Created **Interstitial_Android** placement (Video, Android, Active)
- [ ] Created **Interstitial_iOS** placement (Video, iOS, Active)
- [ ] Waited 2-5 minutes after creating placements
- [ ] Stopped app completely and restarted

## After Setup: Testing

1. Launch your app
2. Check logs for success messages:
   ```
   ✅ Unity Ads initialized successfully
   ✅ Banner Ad loaded: Banner_Android
   ✅ AdsProvider initialization complete
   ```
3. Banner ads should appear at bottom of all screens:
   - Home Screen
   - All Items Screen
   - Expiring Soon Screen
   - Settings Screen
4. Test interstitial ads by adding 3 products

## Support

If issues persist:
- Unity Ads Documentation: https://docs.unity.com/ads/
- Unity Forum: https://forum.unity.com/forums/unity-ads.67/
- Unity Ads Status: https://status.unity.com/

---

**Created**: 2024-11-12
**Version**: 1.0.0
