import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../services/auth_service.dart';
import '../../services/subscription_service.dart';

/// Subscription Provider
/// Manages premium subscription state
class SubscriptionProvider with ChangeNotifier {
  final AuthService _authService;
  final SubscriptionService _subscriptionService;

  // 🧪 DEBUG MODE - Test Premium Features MIỄN PHÍ
  // Set true để test premium features mà không cần IAP
  // ⚠️ PHẢI SET FALSE trước khi release production!
  static const bool _debugForcePremium = false; // ← Change to true để test

  bool _isInitialized = false;
  bool _isPremium = false;
  bool _isLoading = false;
  List<ProductDetails> _products = [];
  String? _error;

  SubscriptionProvider({
    required AuthService authService,
    required SubscriptionService subscriptionService,
  })  : _authService = authService,
        _subscriptionService = subscriptionService;

  // Getters
  bool get isInitialized => _isInitialized;

  /// Check if user has premium status
  /// In debug mode with _debugForcePremium=true, always returns true
  bool get isPremium {
    // 🧪 Debug mode: Force premium for testing
    if (kDebugMode && _debugForcePremium) {
      return true;
    }

    // Production: Return actual premium status
    return _isPremium;
  }
  bool get isLoading => _isLoading;
  List<ProductDetails> get products => _products;
  String? get error => _error;
  bool get isSignedIn => _authService.isSignedIn;
  String? get userId => _authService.userId;

  /// Initialize subscription service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Sign in anonymously if not signed in
      if (!_authService.isSignedIn) {
        await _authService.signInAnonymously();
      }

      // Initialize subscription service
      await _subscriptionService.initialize();

      // Load products and premium status
      await _subscriptionService.loadProducts();
      await _subscriptionService.loadPremiumStatus();

      _isPremium = _subscriptionService.isPremium;
      _products = _subscriptionService.products;
      _isInitialized = true;

      debugPrint('✅ SubscriptionProvider initialized');
      debugPrint('   - Premium: $isPremium'); // Uses getter (checks debug flag)
      debugPrint('   - Products: ${_products.length}');

      // 🧪 Debug mode notification
      if (kDebugMode && _debugForcePremium) {
        debugPrint('');
        debugPrint('🧪 ════════════════════════════════════════');
        debugPrint('🧪 DEBUG MODE: Premium FORCED ENABLED');
        debugPrint('🧪 User will have premium features');
        debugPrint('🧪 Ads will be HIDDEN');
        debugPrint('🧪 No IAP required');
        debugPrint('🧪 ════════════════════════════════════════');
        debugPrint('');
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error initializing SubscriptionProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Purchase a product
  Future<void> purchaseProduct(ProductDetails product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _subscriptionService.purchaseProduct(product);
      debugPrint('✅ Purchase initiated for: ${product.id}');
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error purchasing product: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _subscriptionService.restorePurchases();
      await _subscriptionService.loadPremiumStatus();
      _isPremium = _subscriptionService.isPremium;

      debugPrint('✅ Purchases restored. Premium: $_isPremium');
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error restoring purchases: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh premium status
  Future<void> refreshPremiumStatus() async {
    try {
      await _subscriptionService.loadPremiumStatus();
      _isPremium = _subscriptionService.isPremium;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error refreshing premium status: $e');
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailPassword(email, password);
      await _subscriptionService.loadPremiumStatus();
      _isPremium = _subscriptionService.isPremium;

      debugPrint('✅ Signed in and loaded premium status');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error signing in: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create account with email and password
  Future<bool> createAccount(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.createAccountWithEmailPassword(email, password);
      await _subscriptionService.loadPremiumStatus();
      _isPremium = _subscriptionService.isPremium;

      debugPrint('✅ Account created and loaded premium status');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error creating account: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _isPremium = false;
      notifyListeners();
      debugPrint('✅ Signed out');
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
    }
  }

  @override
  void dispose() {
    _subscriptionService.dispose();
    super.dispose();
  }
}
