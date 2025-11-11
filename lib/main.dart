import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'config/routes.dart';
import 'config/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize services
  // - Database
  // - Notifications
  // - SharedPreferences

  runApp(const FreshKeeperApp());
}

class FreshKeeperApp extends StatelessWidget {
  const FreshKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // TODO: Add providers here
        // ChangeNotifierProvider(create: (_) => ProductProvider()),
        // ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme, // TODO: Implement dark theme
        themeMode: ThemeMode.light,

        // Routes
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,

        // Localization (TODO: Implement later)
        // localizationsDelegates: [
        //   AppLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   Locale('vi', ''),
        //   Locale('en', ''),
        // ],
      ),
    );
  }
}
