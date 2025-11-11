import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';

/// Settings Provider
/// Manages app settings and user preferences
class SettingsProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  // State
  String _language = AppConstants.defaultLanguage;
  ThemeMode _themeMode = ThemeMode.light;
  bool _onboardingCompleted = false;
  String _userName = '';
  String? _userAvatar;

  // Getters
  String get language => _language;
  ThemeMode get themeMode => _themeMode;
  bool get onboardingCompleted => _onboardingCompleted;
  String get userName => _userName;
  String? get userAvatar => _userAvatar;

  /// Initialize and load settings
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await loadSettings();
      debugPrint('✅ Settings initialized');
    } catch (e) {
      debugPrint('❌ Error initializing settings: $e');
    }
  }

  /// Load all settings from storage
  Future<void> loadSettings() async {
    if (_prefs == null) return;

    try {
      _language = _prefs!.getString(AppConstants.keyLanguage) ??
          AppConstants.defaultLanguage;

      final themeString = _prefs!.getString(AppConstants.keyThemeMode);
      _themeMode = _parseThemeMode(themeString);

      _onboardingCompleted =
          _prefs!.getBool(AppConstants.keyOnboardingCompleted) ?? false;

      _userName = _prefs!.getString(AppConstants.keyUserName) ?? '';
      _userAvatar = _prefs!.getString(AppConstants.keyUserAvatar);

      notifyListeners();
      debugPrint('📥 Settings loaded');
    } catch (e) {
      debugPrint('❌ Error loading settings: $e');
    }
  }

  /// Save all settings to storage
  Future<void> saveSettings() async {
    if (_prefs == null) return;

    try {
      await _prefs!.setString(AppConstants.keyLanguage, _language);
      await _prefs!.setString(AppConstants.keyThemeMode, _themeMode.name);
      await _prefs!.setBool(
        AppConstants.keyOnboardingCompleted,
        _onboardingCompleted,
      );
      await _prefs!.setString(AppConstants.keyUserName, _userName);
      if (_userAvatar != null) {
        await _prefs!.setString(AppConstants.keyUserAvatar, _userAvatar!);
      }

      debugPrint('💾 Settings saved');
    } catch (e) {
      debugPrint('❌ Error saving settings: $e');
    }
  }

  // ==================== LANGUAGE ====================

  /// Set language
  Future<void> setLanguage(String lang) async {
    if (_language != lang && (lang == 'vi' || lang == 'en')) {
      _language = lang;
      notifyListeners();
      await saveSettings();
      debugPrint('🌐 Language changed to: $lang');
    }
  }

  /// Toggle language between Vi and En
  Future<void> toggleLanguage() async {
    final newLang = _language == 'vi' ? 'en' : 'vi';
    await setLanguage(newLang);
  }

  // ==================== THEME ====================

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await saveSettings();
      debugPrint('🎨 Theme mode changed to: ${mode.name}');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String? value) {
    if (value == null) return ThemeMode.light;
    try {
      return ThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ThemeMode.light,
      );
    } catch (e) {
      return ThemeMode.light;
    }
  }

  // ==================== ONBOARDING ====================

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    if (!_onboardingCompleted) {
      _onboardingCompleted = true;
      notifyListeners();
      await saveSettings();
      debugPrint('✅ Onboarding completed');
    }
  }

  /// Reset onboarding (for testing)
  Future<void> resetOnboarding() async {
    _onboardingCompleted = false;
    notifyListeners();
    await saveSettings();
    debugPrint('🔄 Onboarding reset');
  }

  // ==================== USER PROFILE ====================

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? avatar,
  }) async {
    bool changed = false;

    if (name != null && _userName != name) {
      _userName = name;
      changed = true;
    }

    if (avatar != null && _userAvatar != avatar) {
      _userAvatar = avatar;
      changed = true;
    }

    if (changed) {
      notifyListeners();
      await saveSettings();
      debugPrint('👤 User profile updated');
    }
  }

  /// Clear user avatar
  Future<void> clearUserAvatar() async {
    if (_userAvatar != null) {
      _userAvatar = null;
      if (_prefs != null) {
        await _prefs!.remove(AppConstants.keyUserAvatar);
      }
      notifyListeners();
      debugPrint('🗑️ User avatar cleared');
    }
  }

  // ==================== DATA MANAGEMENT ====================

  /// Clear all app data
  Future<void> clearAllData() async {
    if (_prefs == null) return;

    try {
      // Keep only essential keys
      final language = _language;

      await _prefs!.clear();

      // Restore language
      await _prefs!.setString(AppConstants.keyLanguage, language);

      // Reset state
      _themeMode = ThemeMode.light;
      _onboardingCompleted = false;
      _userName = '';
      _userAvatar = null;

      notifyListeners();
      debugPrint('🗑️ All app data cleared');
    } catch (e) {
      debugPrint('❌ Error clearing data: $e');
    }
  }

  /// Export settings as JSON
  Map<String, dynamic> exportSettings() {
    return {
      'language': _language,
      'theme_mode': _themeMode.name,
      'onboarding_completed': _onboardingCompleted,
      'user_name': _userName,
      'user_avatar': _userAvatar,
    };
  }

  /// Import settings from JSON
  Future<void> importSettings(Map<String, dynamic> data) async {
    try {
      if (data.containsKey('language')) {
        _language = data['language'] as String;
      }
      if (data.containsKey('theme_mode')) {
        _themeMode = _parseThemeMode(data['theme_mode'] as String);
      }
      if (data.containsKey('onboarding_completed')) {
        _onboardingCompleted = data['onboarding_completed'] as bool;
      }
      if (data.containsKey('user_name')) {
        _userName = data['user_name'] as String;
      }
      if (data.containsKey('user_avatar')) {
        _userAvatar = data['user_avatar'] as String?;
      }

      notifyListeners();
      await saveSettings();
      debugPrint('📥 Settings imported');
    } catch (e) {
      debugPrint('❌ Error importing settings: $e');
    }
  }
}
