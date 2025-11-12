import 'package:flutter/foundation.dart';

import '../../services/ads_service.dart';
import 'subscription_provider.dart';

/// Ads Provider
/// Manages ads state and controls ad display based on premium status
class AdsProvider with ChangeNotifier {
  final AdsService _adsService;
  final SubscriptionProvider _subscriptionProvider;

  bool _isInitialized = false;
  bool _isBannerLoaded = false;

  AdsProvider({
    required AdsService adsService,
    required SubscriptionProvider subscriptionProvider,
  })  : _adsService = adsService,
        _subscriptionProvider = subscriptionProvider {
    // Listen to premium status changes
    _subscriptionProvider.addListener(_onPremiumStatusChanged);
  }

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isBannerLoaded => _isBannerLoaded;
  bool get shouldShowAds => !_subscriptionProvider.isPremium;

  /// Initialize ads service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Only initialize if user is not premium
    if (_subscriptionProvider.isPremium) {
      debugPrint('⚠️ User is premium, skipping ads initialization');
      return;
    }

    try {
      // Initialize Unity Ads with test mode for now
      // Set testMode: false when ready for production
      await _adsService.initialize(testMode: true);

      _isInitialized = _adsService.isInitialized;

      if (_isInitialized) {
        // Load banner ad
        await loadBannerAd();
      }

      debugPrint('✅ AdsProvider initialized');
    } catch (e) {
      debugPrint('❌ Error initializing AdsProvider: $e');
    }

    notifyListeners();
  }

  /// Load banner ad
  Future<void> loadBannerAd() async {
    if (!_isInitialized || !shouldShowAds) {
      debugPrint('⚠️ Cannot load banner ad');
      return;
    }

    try {
      await _adsService.loadBannerAd();
      _isBannerLoaded = true;
      debugPrint('✅ Banner ad loaded');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading banner ad: $e');
    }
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() async {
    if (!_isInitialized || !shouldShowAds) {
      debugPrint('⚠️ Cannot show interstitial ad');
      return false;
    }

    try {
      final shown = await _adsService.showInterstitialAd();
      debugPrint('🎬 Interstitial ad shown: $shown');
      return shown;
    } catch (e) {
      debugPrint('❌ Error showing interstitial ad: $e');
      return false;
    }
  }

  /// Handle product added (for interstitial ad frequency control)
  Future<void> onProductAdded() async {
    if (!shouldShowAds) return;

    try {
      final shouldShowAd = await _adsService.onProductAdded();
      if (shouldShowAd) {
        debugPrint('🎬 Showing interstitial ad after product threshold');
      }
    } catch (e) {
      debugPrint('❌ Error handling product added: $e');
    }
  }

  /// Check if interstitial ad is ready
  bool isInterstitialReady() {
    if (!shouldShowAds) return false;
    return _adsService.isInterstitialReady();
  }

  /// Get time until next interstitial ad
  Duration? getTimeUntilNextInterstitial() {
    if (!shouldShowAds) return null;
    return _adsService.getTimeUntilNextInterstitial();
  }

  /// Handle premium status change
  void _onPremiumStatusChanged() {
    final isPremium = _subscriptionProvider.isPremium;
    debugPrint('🔄 Premium status changed: $isPremium');

    if (isPremium) {
      // User became premium - reset ad counter
      _adsService.resetAddProductCount();
      _isBannerLoaded = false;
    } else if (!_isInitialized) {
      // User is no longer premium and ads not initialized - initialize
      initialize();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _subscriptionProvider.removeListener(_onPremiumStatusChanged);
    super.dispose();
  }
}
