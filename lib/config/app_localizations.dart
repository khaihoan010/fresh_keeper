import 'package:flutter/material.dart';

/// App Localizations
/// Simple localization system for Vietnamese and English
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('vi', ''),
    Locale('en', ''),
  ];

  bool get isVietnamese => locale.languageCode == 'vi';

  // ==================== COMMON ====================
  String get appName => 'Fresh Keeper';
  String get appTagline => isVietnamese
      ? 'Quản lý tủ lạnh thông minh'
      : 'Smart Fridge Management';

  // ==================== HOME SCREEN ====================
  String get home => isVietnamese ? 'Trang Chủ' : 'Home';
  String get allItems => isVietnamese ? 'Tất Cả' : 'All Items';
  String get analytics => isVietnamese ? 'Thống Kê' : 'Analytics';
  String get settings => isVietnamese ? 'Cài Đặt' : 'Settings';

  String get greeting => isVietnamese ? 'Xin chào' : 'Hello';
  String get addProduct => isVietnamese ? 'Thêm Sản Phẩm' : 'Add Product';
  String get quickStats => isVietnamese ? 'Tổng Quan' : 'Quick Stats';

  String get totalProducts =>
      isVietnamese ? 'Tổng sản phẩm' : 'Total Products';
  String get expiringItems =>
      isVietnamese ? 'Sắp hết hạn' : 'Expiring Soon';
  String get expiredItems => isVietnamese ? 'Đã hết hạn' : 'Expired';

  String get expiringToday => isVietnamese ? 'Hết Hạn Hôm Nay' : 'Expiring Today';
  String get noExpiringProducts => isVietnamese
      ? 'Không có sản phẩm nào hết hạn hôm nay!'
      : 'No products expiring today!';

  // ==================== PRODUCT STATUS ====================
  String get fresh => isVietnamese ? 'Tươi' : 'Fresh';
  String get useSoon => isVietnamese ? 'Sử dụng sớm' : 'Use Soon';
  String get urgent => isVietnamese ? 'Gấp' : 'Urgent';
  String get expired => isVietnamese ? 'Đã hết hạn' : 'Expired';

  String daysRemaining(int days) => isVietnamese
      ? '$days ngày còn lại'
      : '$days days remaining';

  String daysText(int days) {
    if (days > 1) {
      return isVietnamese ? '$days ngày' : '$days days';
    } else if (days == 1) {
      return isVietnamese ? '1 ngày' : '1 day';
    } else {
      return isVietnamese ? 'Hôm nay' : 'Today';
    }
  }

  // ==================== PRODUCT DETAIL ====================
  String get productDetail =>
      isVietnamese ? 'Chi Tiết Sản Phẩm' : 'Product Detail';
  String get information => isVietnamese ? 'Thông Tin' : 'Information';
  String get nutrition => isVietnamese ? 'Dinh Dưỡng' : 'Nutrition';
  String get health => isVietnamese ? 'Sức Khỏe' : 'Health';

  String get quantity => isVietnamese ? 'Số lượng' : 'Quantity';
  String get purchaseDate => isVietnamese ? 'Ngày mua' : 'Purchase Date';
  String get expiryDate => isVietnamese ? 'Ngày hết hạn' : 'Expiry Date';
  String get location => isVietnamese ? 'Vị trí' : 'Location';
  String get notes => isVietnamese ? 'Ghi chú' : 'Notes';
  String get storageTips => isVietnamese ? '💡 Mẹo bảo quản' : '💡 Storage Tips';

  String get markAsUsed =>
      isVietnamese ? 'Đánh Dấu Đã Dùng' : 'Mark as Used';
  String get deleteProduct => isVietnamese ? 'Xóa Sản Phẩm' : 'Delete Product';
  String get editProduct =>
      isVietnamese ? 'Chỉnh sửa sản phẩm' : 'Edit Product';

  String get noNutritionData => isVietnamese
      ? 'Chưa có thông tin dinh dưỡng'
      : 'No nutrition information';
  String get noHealthData =>
      isVietnamese ? 'Chưa có thông tin sức khỏe' : 'No health information';

  String get healthBenefits =>
      isVietnamese ? '✅ Lợi Ích Sức Khỏe' : '✅ Health Benefits';
  String get healthWarnings => isVietnamese ? '⚠️ Lưu Ý' : '⚠️ Warnings';

  // ==================== SETTINGS ====================
  String get preferences => isVietnamese ? 'Tùy chỉnh' : 'Preferences';
  String get language => isVietnamese ? 'Ngôn ngữ' : 'Language';
  String get darkMode => isVietnamese ? 'Chế độ tối' : 'Dark Mode';
  String get on => isVietnamese ? 'Bật' : 'On';
  String get off => isVietnamese ? 'Tắt' : 'Off';

  String get application => isVietnamese ? 'Ứng dụng' : 'Application';
  String get about => isVietnamese ? 'Về' : 'About';
  String get version => isVietnamese ? 'Phiên bản' : 'Version';
  String get rateApp =>
      isVietnamese ? 'Đánh giá ứng dụng' : 'Rate App';
  String get rateAppSubtitle => isVietnamese
      ? 'Hỗ trợ chúng tôi phát triển'
      : 'Support our development';
  String get shareApp =>
      isVietnamese ? 'Chia sẻ ứng dụng' : 'Share App';
  String get shareAppSubtitle =>
      isVietnamese ? 'Giới thiệu cho bạn bè' : 'Tell your friends';

  String get data => isVietnamese ? 'Dữ liệu' : 'Data';
  String get clearAllData =>
      isVietnamese ? 'Xóa tất cả dữ liệu' : 'Clear All Data';
  String get cannotUndo =>
      isVietnamese ? 'Không thể hoàn tác' : 'Cannot be undone';

  String get editName => isVietnamese ? 'Chỉnh sửa tên' : 'Edit Name';
  String get enterYourName =>
      isVietnamese ? 'Nhập tên của bạn' : 'Enter your name';
  String get user => isVietnamese ? 'Người dùng' : 'User';

  // ==================== DIALOGS ====================
  String get cancel => isVietnamese ? 'Hủy' : 'Cancel';
  String get save => isVietnamese ? 'Lưu' : 'Save';
  String get delete => isVietnamese ? 'Xóa' : 'Delete';
  String get close => isVietnamese ? 'Đóng' : 'Close';
  String get ok => isVietnamese ? 'OK' : 'OK';

  String get confirmDelete => isVietnamese
      ? 'Xóa sản phẩm?'
      : 'Delete product?';
  String confirmDeleteProduct(String name) => isVietnamese
      ? 'Bạn có chắc muốn xóa "$name"?'
      : 'Are you sure you want to delete "$name"?';

  String get clearDataConfirm =>
      isVietnamese ? 'Xóa tất cả dữ liệu?' : 'Clear all data?';
  String get clearDataWarning => isVietnamese
      ? 'Hành động này sẽ xóa toàn bộ dữ liệu ứng dụng và không thể hoàn tác.'
      : 'This action will delete all app data and cannot be undone.';

  String get selectLanguage =>
      isVietnamese ? 'Chọn ngôn ngữ' : 'Select Language';
  String get vietnamese => 'Tiếng Việt';
  String get english => 'English';

  // ==================== MESSAGES ====================
  String productDeleted(String name) => isVietnamese
      ? '✅ Đã xóa $name'
      : '✅ Deleted $name';

  String productMarkedAsUsed(String name) => isVietnamese
      ? '✅ Đã đánh dấu "$name" là đã dùng'
      : '✅ Marked "$name" as used';

  String get allDataCleared =>
      isVietnamese ? '✅ Đã xóa tất cả dữ liệu' : '✅ All data cleared';

  String get thankYou => isVietnamese ? 'Cảm ơn bạn!' : 'Thank You!';
  String get developmentPhase => isVietnamese
      ? 'Cảm ơn bạn đã muốn đánh giá ứng dụng! Ứng dụng đang trong giai đoạn phát triển. Hãy quay lại sau nhé! 💚'
      : 'Thank you for wanting to rate the app! The app is under development. Please check back later! 💚';

  // ==================== CATEGORIES ====================
  String get vegetables => isVietnamese ? 'Rau củ' : 'Vegetables';
  String get fruits => isVietnamese ? 'Trái cây' : 'Fruits';
  String get meat => isVietnamese ? 'Thịt' : 'Meat';
  String get seafood => isVietnamese ? 'Hải sản' : 'Seafood';
  String get dairy => isVietnamese ? 'Sữa' : 'Dairy';
  String get eggs => isVietnamese ? 'Trứng' : 'Eggs';
  String get beverages => isVietnamese ? 'Đồ uống' : 'Beverages';
  String get condiments => isVietnamese ? 'Gia vị' : 'Condiments';
  String get other => isVietnamese ? 'Khác' : 'Other';

  // ==================== ADD PRODUCT ====================
  String get searchProduct =>
      isVietnamese ? 'Tìm kiếm sản phẩm...' : 'Search product...';
  String get scanBarcode =>
      isVietnamese ? 'Quét mã vạch' : 'Scan Barcode';
  String get productName =>
      isVietnamese ? 'Tên sản phẩm' : 'Product Name';
  String get category => isVietnamese ? 'Danh mục' : 'Category';
  String get selectCategory =>
      isVietnamese ? 'Chọn danh mục' : 'Select Category';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
