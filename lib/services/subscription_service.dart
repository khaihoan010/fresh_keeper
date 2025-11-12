import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'auth_service.dart';

/// Subscription/VIP Membership Service
/// Handles in-app purchases and premium subscription management
class SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;
  FirebaseFirestore? _firestore;
  final AuthService _authService;

  // Lazy initialization of Firestore
  FirebaseFirestore? get _firestoreInstance {
    try {
      if (Firebase.apps.isEmpty) {
        debugPrint('⚠️ Firebase not initialized - Firestore unavailable');
        return null;
      }
      _firestore ??= FirebaseFirestore.instance;
      return _firestore;
    } catch (e) {
      debugPrint('⚠️ Firestore not available: $e');
      return null;
    }
  }

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Product IDs - Replace these with your actual product IDs from App Store Connect and Google Play Console
  static const String premiumMonthlyId = 'fresh_keeper_premium_monthly';
  static const String premiumYearlyId = 'fresh_keeper_premium_yearly';
  static const String premiumLifetimeId = 'fresh_keeper_premium_lifetime';

  // All product IDs
  static const Set<String> _productIds = {
    premiumMonthlyId,
    premiumYearlyId,
    premiumLifetimeId,
  };

  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isPremium = false;

  SubscriptionService(this._authService);

  bool get isAvailable => _isAvailable;
  bool get isPremium => _isPremium;
  List<ProductDetails> get products => _products;

  /// Initialize subscription service
  Future<void> initialize() async {
    try {
      // Check if IAP is available
      _isAvailable = await _iap.isAvailable();

      if (!_isAvailable) {
        debugPrint('⚠️ In-app purchase not available');
        return;
      }

      // Note: Pending purchases are enabled by default in newer versions
      // No need to call enablePendingPurchases() anymore

      // Listen to purchase updates
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) => debugPrint('❌ Purchase stream error: $error'),
      );

      // Load products
      await loadProducts();

      // Load premium status
      await loadPremiumStatus();

      debugPrint('✅ Subscription service initialized');
    } catch (e) {
      debugPrint('❌ Error initializing subscription service: $e');
    }
  }

  /// Load available products from store
  Future<void> loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_productIds);

      if (response.error != null) {
        debugPrint('❌ Error loading products: ${response.error}');
        return;
      }

      _products = response.productDetails;
      debugPrint('✅ Loaded ${_products.length} products');

      for (final product in _products) {
        debugPrint('  - ${product.id}: ${product.price}');
      }
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
    }
  }

  /// Load premium status from Firestore
  Future<void> loadPremiumStatus() async {
    try {
      final firestore = _firestoreInstance;
      if (firestore == null) {
        _isPremium = false;
        return;
      }

      final userId = _authService.userId;
      if (userId == null) {
        _isPremium = false;
        return;
      }

      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        _isPremium = false;
        return;
      }

      final data = doc.data();
      _isPremium = data?['isPremium'] ?? false;

      // Check if subscription is still active
      if (_isPremium) {
        final expiryTimestamp = data?['premiumExpiryDate'] as Timestamp?;
        if (expiryTimestamp != null) {
          final expiryDate = expiryTimestamp.toDate();
          if (DateTime.now().isAfter(expiryDate)) {
            // Subscription expired
            _isPremium = false;
            await _updatePremiumStatus(false);
          }
        }
      }

      debugPrint('✅ Premium status: $_isPremium');
    } catch (e) {
      debugPrint('❌ Error loading premium status: $e');
      _isPremium = false;
    }
  }

  /// Purchase a product
  Future<void> purchaseProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // For subscriptions on iOS, use purchaseSubscription
      // For Android, subscriptions are treated as regular purchases
      if (Platform.isIOS &&
          (product.id == premiumMonthlyId || product.id == premiumYearlyId)) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }

      debugPrint('✅ Purchase initiated for: ${product.id}');
    } catch (e) {
      debugPrint('❌ Error purchasing product: $e');
      rethrow;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      debugPrint('✅ Restore purchases initiated');
    } catch (e) {
      debugPrint('❌ Error restoring purchases: $e');
      rethrow;
    }
  }

  /// Handle purchase updates
  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint('📱 Purchase update: ${purchaseDetails.status}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        debugPrint('⏳ Purchase pending');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Show error
        debugPrint('❌ Purchase error: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Verify and deliver product
        await _verifyAndDeliverProduct(purchaseDetails);
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// Verify and deliver purchased product
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      // TODO: Implement server-side verification for production
      // For now, we trust the purchase

      final productId = purchaseDetails.productID;
      debugPrint('✅ Delivering product: $productId');

      // Calculate expiry date based on product type
      DateTime? expiryDate;
      if (productId == premiumMonthlyId) {
        expiryDate = DateTime.now().add(const Duration(days: 30));
      } else if (productId == premiumYearlyId) {
        expiryDate = DateTime.now().add(const Duration(days: 365));
      } else if (productId == premiumLifetimeId) {
        expiryDate = DateTime(2099, 12, 31); // Far future date
      }

      // Update premium status
      await _updatePremiumStatus(true, expiryDate: expiryDate);
      _isPremium = true;

      debugPrint('✅ Premium activated until: $expiryDate');
    } catch (e) {
      debugPrint('❌ Error delivering product: $e');
    }
  }

  /// Update premium status in Firestore
  Future<void> _updatePremiumStatus(
    bool isPremium, {
    DateTime? expiryDate,
  }) async {
    try {
      final firestore = _firestoreInstance;
      if (firestore == null) {
        debugPrint('⚠️ Firestore not available - cannot update premium status');
        return;
      }

      final userId = _authService.userId;
      if (userId == null) return;

      final data = {
        'isPremium': isPremium,
        'premiumExpiryDate':
            expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('users').doc(userId).set(
            data,
            SetOptions(merge: true),
          );

      debugPrint('✅ Premium status updated in Firestore');
    } catch (e) {
      debugPrint('❌ Error updating premium status: $e');
    }
  }

  /// Dispose
  void dispose() {
    _subscription?.cancel();
  }
}
