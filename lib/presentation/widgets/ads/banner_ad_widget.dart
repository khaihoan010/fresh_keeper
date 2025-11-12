import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../../providers/ads_provider.dart';

/// Banner Ad Widget
/// Displays Unity Ads banner at bottom of screen
/// Only shows if user is not premium
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  // Get correct placement ID based on platform
  String get _placementId {
    return Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, adsProvider, child) {
        // Don't show banner if user is premium
        if (!adsProvider.shouldShowAds) {
          return const SizedBox.shrink();
        }

        // Don't show if ads not initialized
        if (!adsProvider.isInitialized) {
          debugPrint('⚠️ Banner Ad not shown - Unity Ads not initialized');
          return const SizedBox.shrink();
        }

        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: UnityBannerAd(
                placementId: _placementId,
                onLoad: (placementId) {
                  debugPrint('✅ Banner Ad loaded: $placementId');
                },
                onClick: (placementId) {
                  debugPrint('👆 Banner Ad clicked: $placementId');
                },
                onFailed: (placementId, error, message) {
                  debugPrint('❌ Banner Ad failed: $error - $message');
                  debugPrint('   Placement ID: $placementId');
                  debugPrint('   Platform: ${Platform.isAndroid ? "Android" : "iOS"}');
                  debugPrint('   Expected ID: $_placementId');
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
