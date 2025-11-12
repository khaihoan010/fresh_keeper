import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Unity Ads Service
/// Manages banner and interstitial ads with frequency control
class AdsService {
  // Unity Ads Game IDs
  static const String _androidGameId = '5983297'; // Google Play Store
  static const String _iosGameId = '5983296'; // Apple App Store

  // Ad Unit IDs - Platform specific
  static String get _bannerAdUnitId =>
      Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';
  static String get _interstitialAdUnitId => Platform.isAndroid
      ? 'Interstitial_Android'
      : 'Interstitial_iOS';

  // Interstitial ad frequency control
  static const int _addProductCountThreshold = 3; // Show ad after 3 products added
  static const Duration _interstitialMinInterval =
      Duration(minutes: 3); // Minimum 3 minutes between ads

  bool _isInitialized = false;
  int _addProductCount = 0;
  DateTime? _lastInterstitialShown;

  bool get isInitialized => _isInitialized;

  /// Initialize Unity Ads
  Future<void> initialize({bool testMode = true}) async {
    try {
      final gameId = Platform.isAndroid ? _androidGameId : _iosGameId;

      await UnityAds.init(
        gameId: gameId,
        testMode: testMode,
        onComplete: () {
          debugPrint('✅ Unity Ads initialized successfully');
          _isInitialized = true;
          _loadPreferences();
        },
        onFailed: (error, message) {
          debugPrint('❌ Unity Ads initialization failed: $error - $message');
          _isInitialized = false;
        },
      );
    } catch (e) {
      debugPrint('❌ Error initializing Unity Ads: $e');
      _isInitialized = false;
    }
  }

  /// Load saved preferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _addProductCount = prefs.getInt('add_product_count') ?? 0;

      final lastShownTimestamp = prefs.getInt('last_interstitial_shown');
      if (lastShownTimestamp != null) {
        _lastInterstitialShown =
            DateTime.fromMillisecondsSinceEpoch(lastShownTimestamp);
      }

      debugPrint('📊 Loaded ad preferences:');
      debugPrint('  - Add product count: $_addProductCount');
      debugPrint('  - Last interstitial: $_lastInterstitialShown');
    } catch (e) {
      debugPrint('❌ Error loading preferences: $e');
    }
  }

  /// Save preferences
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('add_product_count', _addProductCount);

      if (_lastInterstitialShown != null) {
        await prefs.setInt(
          'last_interstitial_shown',
          _lastInterstitialShown!.millisecondsSinceEpoch,
        );
      }
    } catch (e) {
      debugPrint('❌ Error saving preferences: $e');
    }
  }

  /// Get banner ad unit ID
  String getBannerAdUnitId() {
    return Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';
  }

  /// Load banner ad
  Future<void> loadBannerAd() async {
    if (!_isInitialized) {
      debugPrint('⚠️ Unity Ads not initialized, cannot load banner');
      return;
    }

    try {
      await UnityAds.load(
        placementId: getBannerAdUnitId(),
        onComplete: (placementId) {
          debugPrint('✅ Banner ad loaded: $placementId');
        },
        onFailed: (placementId, error, message) {
          debugPrint('❌ Banner ad failed to load: $error - $message');
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading banner ad: $e');
    }
  }

  /// Show interstitial ad
  /// Returns true if ad was shown, false otherwise
  Future<bool> showInterstitialAd() async {
    if (!_isInitialized) {
      debugPrint('⚠️ Unity Ads not initialized, cannot show interstitial');
      return false;
    }

    try {
      // Load the ad first
      bool isLoaded = false;

      await UnityAds.load(
        placementId: _interstitialAdUnitId,
        onComplete: (placementId) {
          debugPrint('✅ Interstitial ad loaded: $placementId');
          isLoaded = true;
        },
        onFailed: (placementId, error, message) {
          debugPrint('❌ Interstitial ad failed to load: $error - $message');
        },
      );

      if (!isLoaded) {
        return false;
      }

      // Show the ad
      bool wasShown = false;

      await UnityAds.showVideoAd(
        placementId: _interstitialAdUnitId,
        onComplete: (placementId) {
          debugPrint('✅ Interstitial ad completed: $placementId');
          wasShown = true;
          _lastInterstitialShown = DateTime.now();
          _savePreferences();
        },
        onFailed: (placementId, error, message) {
          debugPrint('❌ Interstitial ad failed to show: $error - $message');
        },
        onStart: (placementId) {
          debugPrint('▶️ Interstitial ad started: $placementId');
        },
        onSkipped: (placementId) {
          debugPrint('⏭️ Interstitial ad skipped: $placementId');
          wasShown = true; // Count as shown even if skipped
          _lastInterstitialShown = DateTime.now();
          _savePreferences();
        },
      );

      return wasShown;
    } catch (e) {
      debugPrint('❌ Error showing interstitial ad: $e');
      return false;
    }
  }

  /// Increment add product count and check if we should show ad
  /// Returns true if an ad should be shown
  Future<bool> onProductAdded() async {
    _addProductCount++;
    debugPrint('📊 Product added. Count: $_addProductCount');

    // Check if we should show interstitial ad
    if (_addProductCount >= _addProductCountThreshold) {
      // Check time interval
      if (_lastInterstitialShown == null ||
          DateTime.now().difference(_lastInterstitialShown!) >=
              _interstitialMinInterval) {
        // Reset counter
        _addProductCount = 0;
        await _savePreferences();

        // Show ad
        debugPrint('🎬 Showing interstitial ad after product threshold');
        return await showInterstitialAd();
      } else {
        final remainingTime = _interstitialMinInterval -
            DateTime.now().difference(_lastInterstitialShown!);
        debugPrint(
            '⏳ Interstitial ad cooldown: ${remainingTime.inSeconds}s remaining');
      }
    }

    await _savePreferences();
    return false;
  }

  /// Reset add product count (call this when user becomes premium)
  Future<void> resetAddProductCount() async {
    _addProductCount = 0;
    await _savePreferences();
    debugPrint('🔄 Add product count reset');
  }

  /// Check if interstitial ad is ready to show
  bool isInterstitialReady() {
    if (_lastInterstitialShown == null) {
      return _addProductCount >= _addProductCountThreshold;
    }

    final timeSinceLastAd = DateTime.now().difference(_lastInterstitialShown!);
    return _addProductCount >= _addProductCountThreshold &&
        timeSinceLastAd >= _interstitialMinInterval;
  }

  /// Get time until next interstitial ad can be shown
  Duration? getTimeUntilNextInterstitial() {
    if (_lastInterstitialShown == null) return null;

    final timeSinceLastAd = DateTime.now().difference(_lastInterstitialShown!);
    if (timeSinceLastAd >= _interstitialMinInterval) return null;

    return _interstitialMinInterval - timeSinceLastAd;
  }
}
