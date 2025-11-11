import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../config/app_localizations.dart';
import '../../providers/settings_provider.dart';

/// Settings Screen
/// App settings and preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              // User Profile Section
              _buildProfileSection(context, settings, l10n),

              const Divider(height: 32),

              // Preferences Section
              _buildSectionHeader(l10n.preferences),

              _buildListTile(
                icon: Icons.language_outlined,
                title: l10n.language,
                subtitle: settings.language == 'vi' ? l10n.vietnamese : l10n.english,
                onTap: () {
                  _showLanguageDialog(context, settings, l10n);
                },
              ),

              _buildListTile(
                icon: Icons.dark_mode_outlined,
                title: l10n.darkMode,
                subtitle: settings.themeMode == ThemeMode.dark ? l10n.on : l10n.off,
                trailing: Switch(
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    settings.toggleTheme();
                  },
                ),
              ),

              const Divider(height: 32),

              // App Info Section
              _buildSectionHeader(l10n.application),

              _buildListTile(
                icon: Icons.info_outline,
                title: '${l10n.about} ${AppConstants.appName}',
                subtitle: '${l10n.version} ${AppConstants.appVersion}',
                onTap: () {
                  _showAboutDialog(context, l10n);
                },
              ),

              _buildListTile(
                icon: Icons.star_outline,
                title: l10n.rateApp,
                subtitle: l10n.rateAppSubtitle,
                onTap: () => _rateApp(context, l10n),
              ),

              _buildListTile(
                icon: Icons.share_outlined,
                title: l10n.shareApp,
                subtitle: l10n.shareAppSubtitle,
                onTap: () => _shareApp(context, l10n),
              ),

              const Divider(height: 32),

              // Data Section
              _buildSectionHeader(l10n.data),

              _buildListTile(
                icon: Icons.delete_outline,
                iconColor: Theme.of(context).colorScheme.error,
                title: l10n.clearAllData,
                subtitle: l10n.cannotUndo,
                titleColor: Theme.of(context).colorScheme.error,
                onTap: () {
                  _showClearDataDialog(context, settings, l10n);
                },
              ),

              const SizedBox(height: 32),

              // App Info Footer
              Center(
                child: Column(
                  children: [
                    const Text(
                      '🧊',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.appTagline,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Made with ❤️ in Vietnam',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              settings.userName.isNotEmpty
                  ? settings.userName[0].toUpperCase()
                  : '👤',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settings.userName.isNotEmpty
                      ? settings.userName
                      : l10n.user,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    _showEditNameDialog(context, settings, l10n);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                  ),
                  child: Text(l10n.editName),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Builder(
      builder: (context) {
        return ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: titleColor != null
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: titleColor)
                : Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : null,
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        );
      },
    );
  }

  void _showEditNameDialog(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    final controller = TextEditingController(text: settings.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.enterYourName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              settings.updateUserProfile(name: controller.text.trim());
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.vietnamese),
              value: 'vi',
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settings.setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settings.setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('🧊', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Text(AppConstants.appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appTagline,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '${l10n.version}: ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 Fresh Keeper',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearDataConfirm),
        content: Text(l10n.clearDataWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await settings.clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.allDataCleared),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  /// Share app with friends
  Future<void> _shareApp(BuildContext context, AppLocalizations l10n) async {
    try {
      const String appName = AppConstants.appName;
      final String appTagline = l10n.appTagline;
      const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.freshkeeper.app';
      const String appStoreUrl = 'https://apps.apple.com/app/fresh-keeper/id123456789';

      final String shareText = l10n.isVietnamese
          ? '''
🧊 $appName

$appTagline

📱 Tải ngay tại:
Android: $playStoreUrl
iOS: $appStoreUrl

Cùng quản lý tủ lạnh thông minh và giảm lãng phí thực phẩm! 🌱
'''
          : '''
🧊 $appName

$appTagline

📱 Download now:
Android: $playStoreUrl
iOS: $appStoreUrl

Manage your fridge smartly and reduce food waste! 🌱
''';

      await Share.share(
        shareText,
        subject: appName,
      );

      debugPrint('✅ App shared successfully');
    } catch (e) {
      debugPrint('⚠️ Error sharing app: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.isVietnamese
                ? '⚠️ Không thể chia sẻ ứng dụng'
                : '⚠️ Cannot share app'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  /// Open app store to rate the app
  Future<void> _rateApp(BuildContext context, AppLocalizations l10n) async {
    try {
      // For Android - Google Play Store
      const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.freshkeeper.app';

      // For iOS - App Store
      const String appStoreUrl = 'https://apps.apple.com/app/fresh-keeper/id123456789';

      // Try to launch the store URL
      final Uri playStoreUri = Uri.parse(playStoreUrl);
      final Uri appStoreUri = Uri.parse(appStoreUrl);

      // Check platform and launch appropriate store
      if (Theme.of(context).platform == TargetPlatform.android) {
        if (await canLaunchUrl(playStoreUri)) {
          await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
          debugPrint('✅ Opened Play Store for rating');
        } else {
          throw Exception('Could not launch Play Store');
        }
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(appStoreUri)) {
          await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
          debugPrint('✅ Opened App Store for rating');
        } else {
          throw Exception('Could not launch App Store');
        }
      } else {
        // For other platforms, show a thank you message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.isVietnamese
                  ? 'Cảm ơn bạn đã quan tâm! 💚'
                  : 'Thank you for your interest! 💚'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error opening store: $e');
      if (context.mounted) {
        // Show thank you message as fallback
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(l10n.thankYou),
              ],
            ),
            content: Text(l10n.developmentPhase),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
        );
      }
    }
  }
}
