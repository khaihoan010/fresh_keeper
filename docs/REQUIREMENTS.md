# Fresh Keeper - Yêu Cầu Dự Án

## 📋 Tổng Quan Dự Án

**Tên ứng dụng:** Fresh Keeper
**Nền tảng:** iOS và Android
**Mục đích:** Quản lý thực phẩm trong tủ lạnh, giúp người dùng theo dõi hạn sử dụng, dinh dưỡng và giảm lãng phí thực phẩm

---

## 🎯 Mục Tiêu Chính

1. **Quản lý thực phẩm hiệu quả:** Giúp người dùng theo dõi tất cả thực phẩm trong tủ lạnh
2. **Cảnh báo hết hạn:** Thông báo trước khi thực phẩm hết hạn sử dụng
3. **Thông tin dinh dưỡng:** Cung cấp thông tin dinh dưỡng và lợi ích sức khỏe
4. **Trải nghiệm tốt:** UI/UX đơn giản, đẹp mắt, thân thiện với phụ nữ
5. **Không chi phí:** Không phát sinh chi phí lưu trữ dữ liệu

---

## 👥 Đối Tượng Người Dùng

### Đối tượng chính:
- **Phụ nữ nội trợ** (25-45 tuổi)
- **Người làm việc bận rộn** cần quản lý thực phẩm hiệu quả
- **Người quan tâm đến sức khỏe** và dinh dưỡng

### Đặc điểm người dùng:
- Muốn giảm lãng phí thực phẩm
- Cần nhắc nhở về hạn sử dụng
- Quan tâm đến dinh dưỡng và sức khỏe
- Thích giao diện đơn giản, dễ sử dụng

---

## 🔑 Tính Năng Chính

### 1. Quản Lý Thực Phẩm

#### 1.1 Thêm Sản Phẩm
- **Category dropdown:** Chọn loại thực phẩm
  - Rau củ quả
  - Trái cây
  - Thịt
  - Trứng
  - Sữa và chế phẩm từ sữa
  - Đồ khô
  - Đồ đông lạnh
  - Gia vị
  - Khác

- **Tìm kiếm thông minh:**
  - Input text với tính năng search-as-you-type
  - Auto-suggest khi gõ (VD: gõ "ta" → gợi ý "táo", "tảo biển")
  - Hiển thị 5-10 gợi ý phù hợp nhất
  - Hỗ trợ cả tiếng Việt có dấu và không dấu

- **Tự động điền thông tin:**
  - Ngày hết hạn dự kiến (dựa trên database)
  - Thông tin dinh dưỡng
  - Cách bảo quản đề xuất

- **Thông tin nhập thủ công:**
  - Ngày mua/ngày cho vào tủ lạnh
  - Số lượng
  - Ghi chú (tùy chọn)
  - Ảnh sản phẩm (tùy chọn)

#### 1.2 Xem Danh Sách Sản Phẩm
- **Danh sách tất cả:** Hiển thị tất cả thực phẩm
- **Lọc theo category:** Xem theo từng loại
- **Sắp xếp:**
  - Theo ngày hết hạn (gần nhất trước)
  - Theo tên A-Z
  - Theo ngày thêm mới

- **Trạng thái màu sắc:**
  - 🟢 Xanh: Còn hạn > 7 ngày
  - 🟡 Vàng: Còn 3-7 ngày
  - 🔴 Đỏ: Còn < 3 ngày hoặc đã hết hạn

#### 1.3 Chỉnh Sửa/Xóa
- Chỉnh sửa thông tin sản phẩm
- Đánh dấu đã sử dụng
- Xóa sản phẩm

### 2. Cảnh Báo & Thông Báo

#### 2.1 Thông Báo Push
- Cảnh báo 3 ngày trước khi hết hạn
- Cảnh báo 1 ngày trước khi hết hạn
- Cảnh báo ngày hết hạn

#### 2.2 Màn Hình Cảnh Báo
- Tab/Section riêng cho sản phẩm gần hết hạn
- Danh sách ưu tiên sử dụng
- Số lượng sản phẩm gần hết hạn

### 3. Thông Tin Dinh Dưỡng

#### 3.1 Hiển Thị Dinh Dưỡng (per 100g)
- Calories (kcal)
- Protein (g)
- Carbohydrates (g)
- Fat (g)
- Fiber (g)
- Vitamin & khoáng chất chính

#### 3.2 Lợi Ích Sức Khỏe
- **Tốt cho sức khỏe:** ✅
  - Giải thích lợi ích
  - Vitamin và khoáng chất nổi bật

- **Cần lưu ý:** ⚠️
  - Cảnh báo cho người đặc biệt (tiểu đường, huyết áp cao...)
  - Hướng dẫn sử dụng đúng cách

#### 3.3 Thời Gian Bảo Quản
- Bảo quản ở ngăn mát: X ngày
- Bảo quản ở ngăn đông: X tháng
- Sau khi mở: X ngày

### 4. Dashboard & Thống Kê

- Tổng số sản phẩm trong tủ lạnh
- Số sản phẩm gần hết hạn
- Sản phẩm được thêm gần đây
- Đề xuất món ăn từ thực phẩm hiện có (tùy chọn phase 2)

---

## 🎨 Yêu Cầu UI/UX

### Phong Cách Thiết Kế

#### Màu Sắc
- **Primary:** Xanh mint nhạt (#7DDDC9) hoặc hồng pastel (#FFB6C1)
- **Secondary:** Tím lavender (#E6E6FA)
- **Background:** Trắng (#FFFFFF) hoặc kem nhạt (#FFFEF7)
- **Accent:** Cam coral (#FF6B6B) cho cảnh báo
- **Text:** Xám đậm (#333333)

#### Typography
- Font: San Francisco (iOS), Roboto (Android)
- Title: 24-28pt, Bold
- Subtitle: 18-20pt, Medium
- Body: 14-16pt, Regular
- Caption: 12pt, Light

#### Icons
- Rounded, friendly style
- Line icons hoặc soft filled
- Size: 24x24pt cho navigation, 20x20pt cho content

### Nguyên Tắc UX

1. **Đơn giản và rõ ràng**
   - Tối đa 3 bước để thêm sản phẩm
   - Label rõ ràng, dễ hiểu
   - Feedback tức thời

2. **Thân thiện và ấm áp**
   - Rounded corners cho tất cả elements
   - Soft shadows thay vì hard edges
   - Animation mượt mà, nhẹ nhàng

3. **Trực quan**
   - Màu sắc thể hiện trạng thái
   - Icons dễ nhận biết
   - Visual hierarchy rõ ràng

4. **Dễ tiếp cận**
   - Text size đủ lớn
   - Contrast tốt
   - Touch target tối thiểu 44x44pt

---

## 💾 Yêu Cầu Dữ Liệu

### Ưu Tiên Data Source

#### Priority 1: API Miễn Phí
- **USDA FoodData Central API** (Miễn phí, có key)
- **Open Food Facts API** (Miễn phí, không cần key)
- **Nutritionix API** (Free tier)

#### Priority 2: Tự Tạo Database
- Crawl dữ liệu từ các nguồn công khai
- Tổng hợp từ các trang dinh dưỡng Việt Nam
- Lưu trong JSON hoặc SQLite

#### Priority 3: Hybrid Approach
- Database local cho sản phẩm phổ biến (500-1000 items)
- Cache từ API cho sản phẩm ít gặp
- User có thể thêm sản phẩm custom

### Cấu Trúc Dữ Liệu Cần Thiết

```json
{
  "product_id": "string",
  "name_vi": "string",
  "name_en": "string",
  "category": "string",
  "aliases": ["array of strings"],
  "shelf_life": {
    "refrigerated_days": "number",
    "frozen_days": "number",
    "after_opened_days": "number"
  },
  "nutrition": {
    "serving_size": "100g",
    "calories": "number",
    "protein": "number",
    "carbs": "number",
    "fat": "number",
    "fiber": "number",
    "vitamins": {},
    "minerals": {}
  },
  "health_benefits": ["array"],
  "health_warnings": ["array"],
  "storage_tips": "string"
}
```

### Lưu Trữ Cục Bộ
- **SQLite:** Cho user data (sản phẩm đã thêm)
- **JSON file:** Cho product database
- **SharedPreferences:** Cho settings và preferences
- **Local notifications:** Cho reminder

---

## 🔧 Yêu Cầu Kỹ Thuật

### Platform Support
- **iOS:** 13.0+
- **Android:** API Level 21+ (Android 5.0+)

### Performance
- App size < 50MB
- Launch time < 2s
- Smooth 60fps animation
- Offline-first approach

### Localization
- Tiếng Việt (primary)
- Tiếng Anh (secondary)

### Permissions
- Notifications (cho reminder)
- Camera (tùy chọn, cho chụp ảnh sản phẩm)
- Storage (cho lưu ảnh)

---

## 📱 Platform-Specific Requirements

### iOS
- Tuân thủ Human Interface Guidelines
- Support Dark Mode
- Support Dynamic Type
- Use native navigation patterns

### Android
- Tuân thủ Material Design 3
- Support Android 12+ notification styles
- Adaptive icons
- Edge-to-edge display

---

## 🚀 Phases Phát Triển

### Phase 1 - MVP (Minimum Viable Product)
- ✅ Thêm/sửa/xóa sản phẩm
- ✅ Tìm kiếm với auto-suggest
- ✅ Hiển thị danh sách với trạng thái màu
- ✅ Local notifications cho hết hạn
- ✅ Basic product database (500 items)
- ✅ Thông tin dinh dưỡng cơ bản

### Phase 2 - Enhancement
- 📊 Thống kê và báo cáo
- 🍳 Đề xuất công thức từ thực phẩm hiện có
- 📸 Scan barcode
- ☁️ Cloud backup (optional)
- 👥 Chia sẻ danh sách

### Phase 3 - Advanced
- 🤖 AI đề xuất thực đơn
- 🛒 Tích hợp shopping list
- 📈 Phân tích xu hướng tiêu dùng
- 🌐 Community features

---

## ✅ Checklist Trước Khi Launch

### Functionality
- [ ] Tất cả tính năng core hoạt động
- [ ] Không có crash hoặc bug nghiêm trọng
- [ ] Notifications hoạt động đúng
- [ ] Database load nhanh

### UI/UX
- [ ] Responsive trên nhiều màn hình
- [ ] Animation mượt mà
- [ ] Dark mode support (iOS)
- [ ] Accessibility labels

### Testing
- [ ] Unit tests cho business logic
- [ ] Widget tests cho UI
- [ ] Integration tests
- [ ] Manual testing trên real devices

### Store Requirements
- [ ] App icons (tất cả sizes)
- [ ] Screenshots (iOS và Android)
- [ ] App description
- [ ] Privacy policy
- [ ] Terms of service

---

## 📊 Success Metrics

### Launch Targets
- 1000 downloads trong tháng đầu
- 4.0+ rating trên cả iOS và Android
- < 5% crash rate

### Engagement
- Daily Active Users (DAU) > 30%
- Trung bình 3 products added per user
- Notification click-through rate > 40%

---

## 🔒 Privacy & Security

- Không thu thập thông tin cá nhân
- Tất cả dữ liệu lưu local
- Không tracking users
- Tuân thủ GDPR (nếu có user châu Âu)
- Clear privacy policy

---

## 📝 Notes

- Tập trung vào trải nghiệm người dùng
- Keep it simple và dễ sử dụng
- Ưu tiên performance và offline capability
- Design for women/homemakers
- No ads trong MVP version
