/// Application Constants
class AppConstants {
  // App Information
  static const String appName = 'Fresh Keeper';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Quản lý tủ lạnh thông minh';
  static const String appTagline = 'Giảm lãng phí thực phẩm';

  // Database
  static const String databaseName = 'fresh_keeper.db';
  static const int databaseVersion = 5;

  // Table Names
  static const String tableUserProducts = 'user_products';
  static const String tableProductTemplates = 'product_templates';
  static const String tableCategories = 'categories';
  static const String tableNotifications = 'notifications';
  static const String tableSettings = 'settings';

  // Notification Channels
  static const String notificationChannelId = 'fresh_keeper_channel';
  static const String notificationChannelName = 'Fresh Keeper Notifications';
  static const String notificationChannelDescription =
      'Thông báo về sản phẩm gần hết hạn';

  // Storage Keys (SharedPreferences)
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyReminderDays = 'reminder_days';
  static const String keyNotificationTime = 'notification_time';
  static const String keyUserName = 'user_name';
  static const String keyUserAvatar = 'user_avatar';

  // Default Values
  static const String defaultLanguage = 'vi';
  static const List<int> defaultReminderDays = [7, 3, 1, 0];
  static const String defaultNotificationTime = '15:00';
  static const bool defaultNotificationsEnabled = true;

  // Expiry Status Thresholds (in days)
  static const int expiryGreenThreshold = 7; // > 7 days = Green
  static const int expiryYellowThreshold = 3; // 3-7 days = Yellow
  // < 3 days = Red

  // UI Configuration
  static const int searchMinChars = 2;
  static const int searchSuggestionLimit = 10;
  static const int recentProductsLimit = 5;
  static const int expiringSoonDays = 7;

  // Image Configuration
  static const int maxImageWidth = 800;
  static const int imageQuality = 85;
  static const String imageFormat = 'jpg';

  // Categories
  static const List<String> categoryIds = [
    'vegetables',
    'fruits',
    'meat',
    'eggs',
    'dairy',
    'dry_food',
    'frozen',
    'condiments',
    'other',
  ];

  static const Map<String, String> categoryNamesVi = {
    'vegetables': 'Rau củ quả',
    'fruits': 'Trái cây',
    'meat': 'Thịt',
    'eggs': 'Trứng',
    'dairy': 'Sữa & chế phẩm',
    'dry_food': 'Đồ khô',
    'frozen': 'Đồ đông lạnh',
    'condiments': 'Gia vị',
    'other': 'Khác',
  };

  static const Map<String, String> categoryNamesEn = {
    'vegetables': 'Vegetables',
    'fruits': 'Fruits',
    'meat': 'Meat',
    'eggs': 'Eggs',
    'dairy': 'Dairy',
    'dry_food': 'Dry Food',
    'frozen': 'Frozen',
    'condiments': 'Condiments',
    'other': 'Other',
  };

  static const Map<String, String> categoryIcons = {
    'vegetables': '🥬',
    'fruits': '🍎',
    'meat': '🥩',
    'eggs': '🥚',
    'dairy': '🥛',
    'dry_food': '🍞',
    'frozen': '🧊',
    'condiments': '🧂',
    'other': '📦',
  };

  /// Get categories as a list of maps (for UI dropdowns)
  static List<Map<String, String>> get categories {
    return categoryIds.map((id) {
      return {
        'id': id,
        'name_vi': categoryNamesVi[id] ?? '',
        'name_en': categoryNamesEn[id] ?? '',
        'icon': categoryIcons[id] ?? '📦',
      };
    }).toList();
  }

  // Units
  static const List<String> quantityUnits = [
    'cái',
    'quả',
    'bó',
    'gói',
    'kg',
    'g',
    'lít',
    'ml',
    'hộp',
    'chai',
    'lon',
    'túi',
  ];

  /// Alias for quantityUnits (for convenience)
  static List<String> get units => quantityUnits;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Error Messages
  static const String errorGeneric = 'Đã xảy ra lỗi. Vui lòng thử lại.';
  static const String errorNetwork = 'Không có kết nối mạng.';
  static const String errorDatabase = 'Lỗi cơ sở dữ liệu.';
  static const String errorPermission = 'Không có quyền truy cập.';
  static const String errorNotFound = 'Không tìm thấy dữ liệu.';

  // Success Messages
  static const String successProductAdded = 'Đã thêm sản phẩm thành công!';
  static const String successProductUpdated = 'Đã cập nhật sản phẩm!';
  static const String successProductDeleted = 'Đã xóa sản phẩm!';
  static const String successProductMarkedUsed = 'Đã đánh dấu đã sử dụng!';

  // Confirmation Messages
  static const String confirmDelete = 'Bạn có chắc muốn xóa sản phẩm này?';
  static const String confirmClearAll = 'Bạn có chắc muốn xóa tất cả dữ liệu?';

  // Animation Durations (in milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 250;
  static const int animationSlow = 400;

  // API Configuration (for future use)
  // static const String apiBaseUrl = '';
  // static const String apiKey = '';

  // Assets Paths
  static const String assetsImages = 'assets/images/';
  static const String assetsData = 'assets/data/';
  static const String assetsIcons = 'assets/icons/';

  // Data Files
  static const String productsDataFile = 'assets/data/products_database.json';
  static const String categoriesDataFile = 'assets/data/categories.json';

  // URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@freshkeeper.com';
  static const String feedbackUrl = 'https://example.com/feedback';
}
