import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Mock IAP Service for Testing
/// Provides fake products and purchase flow for development
class MockIAPService {
  // 🧪 Enable/Disable Mock IAP
  static const bool useMockIAP = true; // Set to true để test

  /// Get mock products for testing
  static List<ProductDetails> getMockProducts() {
    return [
      _MockProductDetails(
        id: 'fresh_keeper_premium_monthly',
        title: 'Fresh Keeper Premium - Tháng',
        description: 'Không quảng cáo, sao lưu đám mây, themes độc quyền',
        price: '49.000₫',
        rawPrice: 49000,
        currencyCode: 'VND',
      ),
      _MockProductDetails(
        id: 'fresh_keeper_premium_yearly',
        title: 'Fresh Keeper Premium - Năm',
        description: 'Tiết kiệm 32% so với gói tháng. Tất cả tính năng premium.',
        price: '399.000₫',
        rawPrice: 399000,
        currencyCode: 'VND',
      ),
      _MockProductDetails(
        id: 'fresh_keeper_premium_lifetime',
        title: 'Fresh Keeper Premium - Trọn đời',
        description: 'Mua 1 lần, sử dụng mãi mãi. Không cần đăng ký hàng tháng.',
        price: '999.000₫',
        rawPrice: 999000,
        currencyCode: 'VND',
      ),
    ];
  }

  /// Simulate purchase process
  static Future<PurchaseResult> mockPurchase(String productId) async {
    debugPrint('');
    debugPrint('🧪 ════════════════════════════════════════');
    debugPrint('🧪 MOCK IAP: Starting purchase...');
    debugPrint('🧪 Product ID: $productId');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Random success/failure for realistic testing (90% success rate)
    final random = DateTime.now().millisecond % 10;
    if (random < 9) {
      // Success
      debugPrint('🧪 MOCK IAP: Purchase successful! ✅');
      debugPrint('🧪 User is now Premium 💎');
      debugPrint('🧪 ════════════════════════════════════════');
      debugPrint('');

      return PurchaseResult(
        success: true,
        message: 'Thanh toán thành công!',
      );
    } else {
      // Failure (for testing error handling)
      debugPrint('🧪 MOCK IAP: Purchase failed ❌');
      debugPrint('🧪 Reason: User cancelled');
      debugPrint('🧪 ════════════════════════════════════════');
      debugPrint('');

      return PurchaseResult(
        success: false,
        message: 'Thanh toán bị hủy',
      );
    }
  }

  /// Simulate restore purchases
  static Future<RestoreResult> mockRestorePurchases() async {
    debugPrint('');
    debugPrint('🧪 ════════════════════════════════════════');
    debugPrint('🧪 MOCK IAP: Restoring purchases...');

    await Future.delayed(const Duration(seconds: 1));

    // Simulate finding previous purchase (50% chance)
    final random = DateTime.now().millisecond % 2;
    if (random == 0) {
      debugPrint('🧪 MOCK IAP: Found previous purchase! ✅');
      debugPrint('🧪 Restored: fresh_keeper_premium_yearly');
      debugPrint('🧪 User is now Premium 💎');
      debugPrint('🧪 ════════════════════════════════════════');
      debugPrint('');

      return RestoreResult(
        found: true,
        productId: 'fresh_keeper_premium_yearly',
        message: 'Đã khôi phục gói Premium!',
      );
    } else {
      debugPrint('🧪 MOCK IAP: No previous purchases found ❌');
      debugPrint('🧪 ════════════════════════════════════════');
      debugPrint('');

      return RestoreResult(
        found: false,
        message: 'Không tìm thấy gói đăng ký nào',
      );
    }
  }
}

/// Mock ProductDetails for testing
class _MockProductDetails extends ProductDetails {
  _MockProductDetails({
    required String id,
    required String title,
    required String description,
    required String price,
    required double rawPrice,
    required String currencyCode,
  }) : super(
          id: id,
          title: title,
          description: description,
          price: price,
          rawPrice: rawPrice,
          currencyCode: currencyCode,
        );
}

/// Purchase result
class PurchaseResult {
  final bool success;
  final String message;

  PurchaseResult({
    required this.success,
    required this.message,
  });
}

/// Restore result
class RestoreResult {
  final bool found;
  final String? productId;
  final String message;

  RestoreResult({
    required this.found,
    this.productId,
    required this.message,
  });
}
