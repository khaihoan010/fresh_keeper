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

  String get expiringToday => isVietnamese ? 'Hết Hạn Hôm Nay' : 'Expiring Today';
  String get noExpiringProducts => isVietnamese
      ? 'Không có sản phẩm nào hết hạn hôm nay!'
      : 'No products expiring today!';

  // ==================== PRODUCT STATUS ====================
  String get fresh => isVietnamese ? 'Tươi' : 'Fresh';
  String get useSoon => isVietnamese ? 'Sử dụng sớm' : 'Use Soon';
  String get urgent => isVietnamese ? 'Gấp' : 'Urgent';
  String get expired => isVietnamese ? 'Đã hết hạn' : 'Expired';

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
  String get enterProductName =>
      isVietnamese ? 'Nhập tên sản phẩm' : 'Enter product name';
  String get enterQuantity =>
      isVietnamese ? 'Nhập số lượng' : 'Enter quantity';
  String get selectDate => isVietnamese ? 'Chọn ngày' : 'Select date';
  String get selectLocation => isVietnamese ? 'Chọn vị trí' : 'Select location';
  String get addNotes => isVietnamese ? 'Thêm ghi chú (tùy chọn)' : 'Add notes (optional)';
  String get productAdded => isVietnamese ? 'Đã thêm sản phẩm' : 'Product added';
  String get searching => isVietnamese ? 'Đang tìm kiếm...' : 'Searching...';
  String get searchingOnline => isVietnamese ? 'Đang tìm online...' : 'Searching online...';
  String get noResults => isVietnamese ? 'Không tìm thấy kết quả' : 'No results found';
  String get typeToSearch => isVietnamese ? 'Nhập để tìm kiếm' : 'Type to search';
  String get fridge => isVietnamese ? 'Tủ lạnh' : 'Fridge';
  String get freezer => isVietnamese ? 'Tủ đông' : 'Freezer';
  String get pantry => isVietnamese ? 'Tủ đồ khô' : 'Pantry';
  String get units => isVietnamese ? 'cái' : 'pcs';
  String get unit => isVietnamese ? 'Đơn vị' : 'Unit';
  String get nutritionInfo => isVietnamese ? 'Thông tin dinh dưỡng' : 'Nutrition Info';
  String get noNutritionInfoYet => isVietnamese
      ? 'Thông tin dinh dưỡng sẽ được cập nhật sau'
      : 'Nutrition information will be updated later';
  String get quickSearch => isVietnamese ? 'Tìm kiếm nhanh' : 'Quick Search';
  String get searchProductsLocalOnline => isVietnamese
      ? 'Tìm sản phẩm... (local + online)'
      : 'Search products... (local + online)';
  String get online => isVietnamese ? 'TRỰC TUYẾN' : 'ONLINE';
  String daysUnit(int days) => isVietnamese ? '$days ngày' : '$days days';
  String get example => isVietnamese ? 'Ví dụ' : 'Example';
  String get exampleTomato => isVietnamese ? 'Ví dụ: Cà chua' : 'e.g.: Tomato';
  String get pleaseEnterProductName => isVietnamese
      ? 'Vui lòng nhập tên sản phẩm'
      : 'Please enter product name';
  String get enterQuantityHint => isVietnamese ? 'Nhập số lượng' : 'Enter quantity';
  String get invalidNumber => isVietnamese ? 'Số không hợp lệ' : 'Invalid number';
  String get selectExpiryDate => isVietnamese
      ? 'Vui lòng chọn ngày hết hạn'
      : 'Please select expiry date';
  String get none => isVietnamese ? 'Không có' : 'None';
  String get productInformation => isVietnamese ? 'Thông tin sản phẩm' : 'Product Information';
  String get shelfLife => isVietnamese ? 'Hạn sử dụng' : 'Shelf Life';
  String get saveChanges => isVietnamese ? 'Lưu Thay Đổi' : 'Save Changes';
  String get storageLocation => isVietnamese ? 'Vị trí lưu trữ' : 'Storage Location';
  String get storageLocationHint => isVietnamese ? 'Ví dụ: Tủ lạnh, Kệ bếp' : 'e.g.: Fridge, Kitchen shelf';
  String productUpdated(String name) => isVietnamese
      ? '✅ Đã cập nhật $name'
      : '✅ Updated $name';
  String get cannotUpdateProduct => isVietnamese
      ? 'Không thể cập nhật sản phẩm'
      : 'Cannot update product';
  String get storage => isVietnamese ? 'Bảo quản' : 'Storage';
  String get benefits => isVietnamese ? 'Lợi ích' : 'Benefits';
  String barcodeFound(String productName) => isVietnamese
      ? '✅ Đã tìm thấy: $productName'
      : '✅ Found: $productName';
  String get barcodeNotFound => isVietnamese
      ? '⚠️ Không tìm thấy sản phẩm với mã vạch này'
      : '⚠️ No product found with this barcode';
  String get barcodeScanError => isVietnamese
      ? '❌ Lỗi khi quét mã vạch'
      : '❌ Error scanning barcode';
  String productAddedSuccess(String productName) => isVietnamese
      ? '✅ Đã thêm $productName'
      : '✅ Added $productName';
  String get cannotAddProduct => isVietnamese
      ? 'Không thể thêm sản phẩm'
      : 'Cannot add product';
  String get positionBarcodeInFrame => isVietnamese
      ? 'Đưa mã vạch vào khung hình'
      : 'Position barcode in frame';

  // ==================== ALL ITEMS SCREEN ====================
  String get sortBy => isVietnamese ? 'Sắp xếp theo' : 'Sort by';
  String get filterBy => isVietnamese ? 'Lọc theo' : 'Filter by';
  String get filterByCategory => isVietnamese ? 'Lọc theo danh mục' : 'Filter by Category';
  String get all => isVietnamese ? 'Tất cả' : 'All';
  String get expiryDateSoon => isVietnamese ? 'Hạn sử dụng (gần nhất)' : 'Expiry Date (Soonest)';
  String get expiryDateLate => isVietnamese ? 'Hạn sử dụng (xa nhất)' : 'Expiry Date (Latest)';
  String get nameAZ => isVietnamese ? 'Tên (A-Z)' : 'Name (A-Z)';
  String get nameZA => isVietnamese ? 'Tên (Z-A)' : 'Name (Z-A)';
  String get addedNewest => isVietnamese ? 'Mới thêm nhất' : 'Recently Added';
  String get addedOldest => isVietnamese ? 'Cũ nhất' : 'Oldest';
  String get allCategories => isVietnamese ? 'Tất cả danh mục' : 'All Categories';
  String get allLocations => isVietnamese ? 'Tất cả vị trí' : 'All Locations';
  String get noProducts => isVietnamese ? 'Chưa có sản phẩm nào' : 'No products yet';
  String get noProductsFound => isVietnamese ? 'Không tìm thấy sản phẩm' : 'No products found';
  String get tryDifferentKeyword => isVietnamese ? 'Thử từ khóa khác' : 'Try a different keyword';
  String get noProductsInCategory => isVietnamese
      ? 'Chưa có sản phẩm nào trong danh mục này'
      : 'No products in this category';
  String get addFirstProduct => isVietnamese
      ? 'Thêm sản phẩm đầu tiên của bạn!'
      : 'Add your first product!';
  String productsCount(int count) => isVietnamese
      ? '$count sản phẩm'
      : '$count product${count != 1 ? 's' : ''}';

  // ==================== EXPIRING SOON ====================
  String get expiringSoon => isVietnamese ? 'Gần Hết Hạn' : 'Expiring Soon';
  String get within3Days => isVietnamese ? 'Trong 3 ngày' : 'Within 3 days';
  String get within7Days => isVietnamese ? 'Trong 7 ngày' : 'Within 7 days';
  String get allExpiring => isVietnamese ? 'Tất cả sắp hết hạn' : 'All Expiring';
  String get noExpiringItems => isVietnamese
      ? 'Không có sản phẩm nào sắp hết hạn'
      : 'No products expiring soon';
  String get greatNews => isVietnamese ? 'Tuyệt vời!' : 'Great!';
  String get allFresh => isVietnamese
      ? 'Tất cả sản phẩm của bạn đều còn tươi ngon'
      : 'All your products are still fresh';
  String get productsExpiringSoon => isVietnamese
      ? 'Sản phẩm gần hết hạn'
      : 'Products expiring soon';
  String get useSoonToAvoidWaste => isVietnamese
      ? 'Hãy sử dụng sớm để tránh lãng phí'
      : 'Use soon to avoid waste';
  String get expiredItems => isVietnamese ? '❌ Đã Hết Hạn' : '❌ Expired';
  String get expiringToday2 => isVietnamese ? '⏰ Hết Hạn Hôm Nay' : '⏰ Expiring Today';
  String get urgentDays => isVietnamese ? '🚨 Khẩn Cấp (1-2 ngày)' : '🚨 Urgent (1-2 days)';
  String get useSoonDays => isVietnamese ? '⚠️ Sử Dụng Sớm (3-7 ngày)' : '⚠️ Use Soon (3-7 days)';
  String get days => isVietnamese ? 'ngày' : 'days';

  // Days remaining text helpers
  String daysRemaining(int days) {
    if (days == 0) {
      return isVietnamese ? 'Hết hạn hôm nay' : 'Expires today';
    } else if (days == 1) {
      return isVietnamese ? 'Còn 1 ngày' : '1 day left';
    } else {
      return isVietnamese ? 'Còn $days ngày' : '$days days left';
    }
  }

  String daysOverdue(int days) {
    if (days == 0) {
      return isVietnamese ? 'Hết hạn hôm nay' : 'Expired today';
    } else {
      return isVietnamese ? 'Quá hạn $days ngày' : '$days days overdue';
    }
  }

  String expiresIn(int days) {
    if (days == 0) {
      return isVietnamese ? 'Hết hạn hôm nay' : 'Expires today';
    } else if (days == 1) {
      return isVietnamese ? 'Hết hạn ngày mai' : 'Expires tomorrow';
    } else {
      return isVietnamese ? 'Hết hạn sau $days ngày' : 'Expires in $days days';
    }
  }

  // ==================== PRODUCT DETAIL - EXTENDED ====================
  String get basicInfo => isVietnamese ? 'Thông tin cơ bản' : 'Basic Information';
  String get nutritionValue => isVietnamese ? 'Giá Trị Dinh Dưỡng' : 'Nutrition Value';
  String get servingSize => isVietnamese ? 'Khẩu phần ăn' : 'Serving Size';
  String get calories => isVietnamese ? 'Calo' : 'Calories';
  String get protein => isVietnamese ? 'Protein' : 'Protein';
  String get carbohydrates => isVietnamese ? 'Carbohydrate' : 'Carbohydrates';
  String get fat => isVietnamese ? 'Chất béo' : 'Fat';
  String get fiber => isVietnamese ? 'Chất xơ' : 'Fiber';
  String get sugar => isVietnamese ? 'Đường' : 'Sugar';
  String get vitamins => isVietnamese ? 'Vitamin' : 'Vitamins';
  String get minerals => isVietnamese ? 'Khoáng chất' : 'Minerals';
  String get markUsed => isVietnamese ? 'Đánh dấu đã dùng' : 'Mark as used';

  // ==================== HOME SCREEN - EXTENDED ====================
  String get welcomeBack => isVietnamese ? 'Chào mừng trở lại!' : 'Welcome back!';
  String get yourFridge => isVietnamese ? 'Tủ lạnh của bạn' : 'Your Fridge';
  String get itemsTotal => isVietnamese ? 'tổng cộng' : 'total';
  String get items => isVietnamese ? 'sản phẩm' : 'items';
  String get needAttention => isVietnamese ? 'cần chú ý' : 'need attention';
  String get viewAll => isVietnamese ? 'Xem tất cả' : 'View All';
  String get recentlyAdded => isVietnamese ? 'Mới thêm gần đây' : 'Recently Added';
  String get noRecentProducts => isVietnamese
      ? 'Chưa có sản phẩm nào'
      : 'No recent products';

  // ==================== BUTTONS & ACTIONS ====================
  String get add => isVietnamese ? 'Thêm' : 'Add';
  String get edit => isVietnamese ? 'Sửa' : 'Edit';
  String get update => isVietnamese ? 'Cập nhật' : 'Update';
  String get remove => isVietnamese ? 'Xóa' : 'Remove';
  String get confirm => isVietnamese ? 'Xác nhận' : 'Confirm';
  String get done => isVietnamese ? 'Xong' : 'Done';
  String get back => isVietnamese ? 'Quay lại' : 'Back';
  String get next => isVietnamese ? 'Tiếp theo' : 'Next';
  String get skip => isVietnamese ? 'Bỏ qua' : 'Skip';
  String get retry => isVietnamese ? 'Thử lại' : 'Retry';
  String get refresh => isVietnamese ? 'Làm mới' : 'Refresh';
  String get clear => isVietnamese ? 'Xóa' : 'Clear';
  String get apply => isVietnamese ? 'Áp dụng' : 'Apply';
  String get reset => isVietnamese ? 'Đặt lại' : 'Reset';
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
