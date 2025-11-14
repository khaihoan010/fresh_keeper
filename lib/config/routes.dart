import 'package:flutter/material.dart';

import '../data/models/user_product.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/add_product/add_product_screen.dart';
import '../presentation/screens/all_items/all_items_screen.dart';
import '../presentation/screens/expiring_soon/expiring_soon_screen.dart';
import '../presentation/screens/product_detail/product_detail_screen.dart';
import '../presentation/screens/edit_product/edit_product_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/premium/premium_screen.dart';

/// Application Routes
class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String addProduct = '/add_product';
  static const String allItems = '/all_items';
  static const String expiringSoon = '/expiring_soon';
  static const String productDetail = '/product_detail';
  static const String editProduct = '/edit_product';
  static const String settings = '/settings';
  static const String premium = '/premium';
  static const String notificationSettings = '/notification_settings';
  static const String themeSettings = '/theme_settings';
  static const String languageSettings = '/language_settings';
  static const String about = '/about';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _buildRoute(
          const SplashScreen(),
          routeSettings,
        );

      case onboarding:
        return _buildRoute(
          const OnboardingScreen(),
          routeSettings,
        );

      case home:
        return _buildRoute(
          const HomeScreen(),
          routeSettings,
        );

      case dashboard:
        return _buildRoute(
          const DashboardScreen(),
          routeSettings,
        );

      case addProduct:
        return _buildRoute(
          const AddProductScreen(),
          routeSettings,
          fullscreenDialog: true,
        );

      case allItems:
        return _buildRoute(
          const AllItemsScreen(),
          routeSettings,
        );

      case expiringSoon:
        return _buildRoute(
          const ExpiringSoonScreen(),
          routeSettings,
        );

      case productDetail:
        final product = routeSettings.arguments as UserProduct;
        return _buildRoute(
          ProductDetailScreen(product: product),
          routeSettings,
        );

      case editProduct:
        final product = routeSettings.arguments as UserProduct;
        return _buildRoute(
          EditProductScreen(product: product),
          routeSettings,
          fullscreenDialog: true,
        );

      case settings:
        return _buildRoute(
          const SettingsScreen(),
          routeSettings,
        );

      case premium:
        return _buildRoute(
          const PremiumScreen(),
          routeSettings,
        );

      case notificationSettings:
        return _buildRoute(
          const Placeholder(), // TODO: Replace with NotificationSettingsScreen()
          routeSettings,
        );

      case themeSettings:
        return _buildRoute(
          const Placeholder(), // TODO: Replace with ThemeSettingsScreen()
          routeSettings,
        );

      case languageSettings:
        return _buildRoute(
          const Placeholder(), // TODO: Replace with LanguageSettingsScreen()
          routeSettings,
        );

      case about:
        return _buildRoute(
          const Placeholder(), // TODO: Replace with AboutScreen()
          routeSettings,
        );

      default:
        return _buildRoute(
          _ErrorScreen(routeName: routeSettings.name ?? 'unknown'),
          routeSettings,
        );
    }
  }

  /// Build route with custom transition
  static MaterialPageRoute _buildRoute(
    Widget page,
    RouteSettings settings, {
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// Build route with custom page transition
  static PageRoute _buildPageRoute(
    Widget page,
    RouteSettings settings, {
    RouteTransitionType transitionType = RouteTransitionType.slide,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case RouteTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );

          case RouteTransitionType.slide:
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );

          case RouteTransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            );

          case RouteTransitionType.none:
            return child;
        }
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

/// Route transition types
enum RouteTransitionType {
  slide,
  fade,
  scale,
  none,
}

/// Error Screen for unknown routes
class _ErrorScreen extends StatelessWidget {
  final String routeName;

  const _ErrorScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Route not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Route: $routeName',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
