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
          return const SizedBox.shrink();
        }

        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: UnityBannerAd(
                placementId: adsProvider.isInitialized
                    ? 'Banner_Android' // Will auto-switch to Banner_iOS on iOS
                    : '',
                onLoad: (placementId) {
                  debugPrint('✅ Banner Ad loaded: $placementId');
                },
                onClick: (placementId) {
                  debugPrint('👆 Banner Ad clicked: $placementId');
                },
                onFailed: (placementId, error, message) {
                  debugPrint('❌ Banner Ad failed: $error - $message');
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
