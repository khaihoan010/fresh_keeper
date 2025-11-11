import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../providers/settings_provider.dart';

/// Settings Screen
/// App settings and preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              // User Profile Section
              _buildProfileSection(context, settings),

              const Divider(height: 32),

              // Preferences Section
              _buildSectionHeader('Tùy chỉnh'),

              _buildListTile(
                icon: Icons.language_outlined,
                title: 'Ngôn ngữ',
                subtitle: settings.language == 'vi' ? 'Tiếng Việt' : 'English',
                onTap: () {
                  _showLanguageDialog(context, settings);
                },
              ),

              _buildListTile(
                icon: Icons.dark_mode_outlined,
                title: 'Chế độ tối',
                subtitle: 'Đang phát triển',
                trailing: Switch(
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: null, // Disabled for now
                ),
              ),

              const Divider(height: 32),

              // App Info Section
              _buildSectionHeader('Ứng dụng'),

              _buildListTile(
                icon: Icons.info_outline,
                title: 'Về ${AppConstants.appName}',
                subtitle: 'Phiên bản ${AppConstants.appVersion}',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),

              _buildListTile(
                icon: Icons.star_outline,
                title: 'Đánh giá ứng dụng',
                subtitle: 'Hỗ trợ chúng tôi phát triển',
                onTap: () {
                  // TODO: Open store rating
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cảm ơn bạn đã quan tâm!'),
                    ),
                  );
                },
              ),

              _buildListTile(
                icon: Icons.share_outlined,
                title: 'Chia sẻ ứng dụng',
                subtitle: 'Giới thiệu cho bạn bè',
                onTap: () {
                  // TODO: Implement share
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chức năng đang phát triển'),
                    ),
                  );
                },
              ),

              const Divider(height: 32),

              // Data Section
              _buildSectionHeader('Dữ liệu'),

              _buildListTile(
                icon: Icons.delete_outline,
                iconColor: AppTheme.errorColor,
                title: 'Xóa tất cả dữ liệu',
                subtitle: 'Không thể hoàn tác',
                titleColor: AppTheme.errorColor,
                onTap: () {
                  _showClearDataDialog(context, settings);
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
                      style: AppTheme.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.appTagline,
                      style: AppTheme.body2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Made with ❤️ in Vietnam',
                      style: AppTheme.caption,
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

  Widget _buildProfileSection(BuildContext context, SettingsProvider settings) {
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
                      : 'Người dùng',
                  style: AppTheme.h3,
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    _showEditNameDialog(context, settings);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                  ),
                  child: const Text('Chỉnh sửa tên'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTheme.caption.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
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
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: titleColor != null
            ? AppTheme.body1.copyWith(color: titleColor)
            : AppTheme.body1,
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showEditNameDialog(BuildContext context, SettingsProvider settings) {
    final controller = TextEditingController(text: settings.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa tên'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nhập tên của bạn',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              settings.updateUserProfile(name: controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ngôn ngữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
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
              title: const Text('English'),
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

  void _showAboutDialog(BuildContext context) {
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
              AppConstants.appTagline,
              style: AppTheme.body1,
            ),
            const SizedBox(height: 16),
            Text(
              'Phiên bản: ${AppConstants.appVersion}',
              style: AppTheme.body2,
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 Fresh Keeper',
              style: AppTheme.caption,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả dữ liệu?'),
        content: const Text(
          'Hành động này sẽ xóa toàn bộ dữ liệu ứng dụng và không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              await settings.clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Đã xóa tất cả dữ liệu'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
