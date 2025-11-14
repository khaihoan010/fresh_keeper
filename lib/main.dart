import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'config/routes.dart';
import 'config/constants.dart';
import 'config/app_localizations.dart';
import 'services/database_service.dart';
import 'services/auth_service.dart';
import 'services/subscription_service.dart';
import 'services/ads_service.dart';
import 'data/data_sources/local/product_local_data_source.dart';
import 'data/repositories/product_repository.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/subscription_provider.dart';
import 'presentation/providers/ads_provider.dart';
import 'presentation/providers/shopping_list_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization skipped (will run without monetization): $e');
  }

  // Initialize services
  final databaseService = DatabaseService();
  await databaseService.database; // Initialize database

  // Initialize settings
  final settingsProvider = SettingsProvider();
  await settingsProvider.initialize();

  runApp(FreshKeeperApp(
    databaseService: databaseService,
    settingsProvider: settingsProvider,
  ));
}

class FreshKeeperApp extends StatelessWidget {
  final DatabaseService databaseService;
  final SettingsProvider settingsProvider;

  const FreshKeeperApp({
    super.key,
    required this.databaseService,
    required this.settingsProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Create data source and repository
    final productDataSource = ProductLocalDataSource(databaseService);
    final productRepository = ProductRepository(productDataSource);

    // Create monetization services
    final authService = AuthService();
    final subscriptionService = SubscriptionService(authService);
    final adsService = AdsService();

    return MultiProvider(
      providers: [
        // Settings Provider
        ChangeNotifierProvider<SettingsProvider>.value(
          value: settingsProvider,
        ),

        // Product Repository (must be provided before ProductProvider)
        Provider<ProductRepository>(
          create: (_) => productRepository,
        ),

        // Product Provider
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(productRepository),
        ),

        // Shopping List Provider
        ChangeNotifierProvider<ShoppingListProvider>(
          create: (_) => ShoppingListProvider(),
        ),

        // Monetization Services (provided before their providers)
        Provider<AuthService>(
          create: (_) => authService,
        ),
        Provider<SubscriptionService>(
          create: (_) => subscriptionService,
        ),
        Provider<AdsService>(
          create: (_) => adsService,
        ),

        // Subscription Provider (depends on auth & subscription services)
        ChangeNotifierProvider<SubscriptionProvider>(
          create: (_) => SubscriptionProvider(
            authService: authService,
            subscriptionService: subscriptionService,
          )..initialize(),
        ),

        // Ads Provider (depends on ads service & subscription provider)
        ChangeNotifierProxyProvider<SubscriptionProvider, AdsProvider>(
          create: (context) => AdsProvider(
            adsService: adsService,
            subscriptionProvider: context.read<SubscriptionProvider>(),
          )..initialize(),
          update: (context, subscriptionProvider, previous) =>
              previous ??
              AdsProvider(
                adsService: adsService,
                subscriptionProvider: subscriptionProvider,
              ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,

            // Routes
            initialRoute: settings.onboardingCompleted
                ? AppRoutes.home
                : AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,

            // Localization
            locale: Locale(settings.language, ''),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
