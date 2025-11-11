# Fresh Keeper - User Stories

## 👤 User Personas

### Persona 1: Chị Mai - Nội trợ bận rộn
- **Tuổi:** 35
- **Nghề nghiệp:** Nội trợ, có 2 con nhỏ
- **Pain points:**
  - Hay quên thực phẩm trong tủ lạnh đến khi hư
  - Không nhớ mua thực phẩm gì, khi nào
  - Muốn nấu ăn dinh dưỡng cho gia đình
- **Goals:**
  - Giảm lãng phí thực phẩm
  - Quản lý tủ lạnh có tổ chức
  - Biết thực phẩm nào tốt cho con

### Persona 2: Cô Linh - Người làm việc độc thân
- **Tuổi:** 28
- **Nghề nghiệp:** Marketing, sống một mình
- **Pain points:**
  - Đi làm nhiều, hay quên thực phẩm trong tủ lạnh
  - Mua ít nhưng vẫn bị hỏng
  - Muốn ăn healthy nhưng không rành dinh dưỡng
- **Goals:**
  - Nhắc nhở trước khi thực phẩm hết hạn
  - Tìm hiểu dinh dưỡng đơn giản
  - Tiết kiệm tiền

### Persona 3: Bà Hương - Người cao tuổi
- **Tuổi:** 58
- **Nghề nghiệp:** Hưu trí
- **Pain points:**
  - Hay quên ngày mua đồ
  - Nhìn không rõ hạn sử dụng trên bao bì
  - Khó nhớ thực phẩm nào để ở đâu
- **Goals:**
  - App đơn giản, dễ dùng
  - Chữ to, rõ ràng
  - Nhắc nhở tự động

---

## 📖 User Stories - Epic 1: Quản Lý Sản Phẩm

### US-1.1: Thêm Sản Phẩm Mới
**As a** người dùng
**I want to** thêm sản phẩm vào danh sách tủ lạnh một cách nhanh chóng
**So that** tôi có thể theo dõi tất cả thực phẩm tôi có

**Acceptance Criteria:**
- ✅ Có nút "Thêm sản phẩm" rõ ràng trên màn hình chính
- ✅ Chọn category từ dropdown (Rau củ, Trái cây, Thịt, Trứng, etc.)
- ✅ Nhập tên sản phẩm với tính năng tìm kiếm
- ✅ Khi gõ 2 ký tự, hiển thị gợi ý sản phẩm
- ✅ Tự động điền ngày hết hạn nếu sản phẩm có trong database
- ✅ Cho phép chỉnh sửa ngày hết hạn đề xuất
- ✅ Nhập số lượng
- ✅ Có thể thêm ghi chú (optional)
- ✅ Lưu sản phẩm thành công, hiển thị trong danh sách

**Priority:** HIGH
**Estimate:** 5 points

---

### US-1.2: Tìm Kiếm Sản Phẩm Thông Minh
**As a** người dùng
**I want to** tìm kiếm sản phẩm khi nhập tên
**So that** tôi không phải gõ toàn bộ tên và được gợi ý thông minh

**Acceptance Criteria:**
- ✅ Search box responsive, không lag
- ✅ Hiển thị kết quả sau khi gõ 2 ký tự
- ✅ Gợi ý 5-10 sản phẩm phù hợp nhất
- ✅ Highlight ký tự đã gõ trong kết quả
- ✅ Hỗ trợ tiếng Việt có dấu và không dấu
- ✅ Ví dụ: Gõ "ta" → hiển thị "Táo", "Tảo biển", "Tá lá"
- ✅ Có thể chọn từ danh sách gợi ý
- ✅ Có thể nhập tên custom nếu không tìm thấy

**Priority:** HIGH
**Estimate:** 3 points

---

### US-1.3: Xem Danh Sách Sản Phẩm
**As a** người dùng
**I want to** xem tất cả sản phẩm trong tủ lạnh của tôi
**So that** tôi biết tôi có những gì

**Acceptance Criteria:**
- ✅ Danh sách hiển thị đầy đủ thông tin: tên, category, hạn sử dụng
- ✅ Màu sắc thể hiện trạng thái:
  - Xanh: Còn hạn > 7 ngày
  - Vàng: Còn 3-7 ngày
  - Đỏ: Còn < 3 ngày
- ✅ Sắp xếp mặc định theo ngày hết hạn (gần nhất trước)
- ✅ Có thể lọc theo category
- ✅ Có thể sắp xếp theo tên A-Z
- ✅ Pull to refresh
- ✅ Empty state đẹp khi chưa có sản phẩm

**Priority:** HIGH
**Estimate:** 3 points

---

### US-1.4: Chỉnh Sửa Sản Phẩm
**As a** người dùng
**I want to** chỉnh sửa thông tin sản phẩm
**So that** tôi có thể cập nhật khi thông tin thay đổi

**Acceptance Criteria:**
- ✅ Tap vào sản phẩm để xem chi tiết
- ✅ Nút "Chỉnh sửa" rõ ràng
- ✅ Có thể sửa tất cả thông tin (tên, ngày, số lượng, ghi chú)
- ✅ Validation input hợp lệ
- ✅ Lưu thay đổi và cập nhật danh sách
- ✅ Hiển thị confirmation khi lưu thành công

**Priority:** MEDIUM
**Estimate:** 2 points

---

### US-1.5: Xóa Sản Phẩm
**As a** người dùng
**I want to** xóa sản phẩm đã sử dụng hết
**So that** danh sách của tôi luôn chính xác

**Acceptance Criteria:**
- ✅ Swipe to delete (iOS style) hoặc long press (Android)
- ✅ Hiển thị confirmation dialog trước khi xóa
- ✅ Có option "Đã sử dụng" thay vì xóa
- ✅ Animation mượt khi xóa
- ✅ Có thể undo trong 3 giây

**Priority:** MEDIUM
**Estimate:** 2 points

---

### US-1.6: Đánh Dấu Đã Sử Dụng
**As a** người dùng
**I want to** đánh dấu sản phẩm đã sử dụng
**So that** tôi có thể theo dõi lịch sử tiêu thụ

**Acceptance Criteria:**
- ✅ Checkbox hoặc button "Đã dùng"
- ✅ Sản phẩm đã dùng chuyển sang archive (không hiển thị trong danh sách chính)
- ✅ Có thể xem lịch sử sản phẩm đã dùng
- ✅ Animation khi đánh dấu

**Priority:** LOW
**Estimate:** 2 points

---

## 📖 User Stories - Epic 2: Cảnh Báo & Thông Báo

### US-2.1: Nhận Thông Báo Gần Hết Hạn
**As a** người dùng
**I want to** nhận thông báo khi sản phẩm gần hết hạn
**So that** tôi có thể sử dụng trước khi bị hỏng

**Acceptance Criteria:**
- ✅ Thông báo 3 ngày trước hết hạn
- ✅ Thông báo 1 ngày trước hết hạn
- ✅ Thông báo ngày hết hạn
- ✅ Notification hiển thị tên sản phẩm và số ngày còn lại
- ✅ Tap vào notification mở app đến chi tiết sản phẩm
- ✅ Có thể tắt notification cho từng sản phẩm
- ✅ Settings để chọn thời gian nhận thông báo

**Priority:** HIGH
**Estimate:** 5 points

---

### US-2.2: Xem Danh Sách Gần Hết Hạn
**As a** người dùng
**I want to** có một tab riêng cho sản phẩm gần hết hạn
**So that** tôi biết cần ưu tiên sử dụng gì

**Acceptance Criteria:**
- ✅ Tab "Gần hết hạn" trên bottom navigation
- ✅ Danh sách sắp xếp theo độ ưu tiên (hết hạn sớm nhất trước)
- ✅ Hiển thị số lượng sản phẩm gần hết hạn (badge)
- ✅ Chỉ hiển thị sản phẩm còn < 7 ngày
- ✅ Empty state khi không có sản phẩm gần hết hạn

**Priority:** HIGH
**Estimate:** 3 points

---

### US-2.3: Tùy Chỉnh Cài Đặt Thông Báo
**As a** người dùng
**I want to** tùy chỉnh thời gian nhận thông báo
**So that** phù hợp với thói quen của tôi

**Acceptance Criteria:**
- ✅ Settings page để cấu hình
- ✅ Chọn số ngày cảnh báo trước (1, 3, 5, 7 ngày)
- ✅ Chọn giờ nhận thông báo (morning, afternoon, evening)
- ✅ Bật/tắt notification toàn bộ
- ✅ Lưu settings locally

**Priority:** MEDIUM
**Estimate:** 3 points

---

## 📖 User Stories - Epic 3: Thông Tin Dinh Dưỡng

### US-3.1: Xem Thông Tin Dinh Dưỡng
**As a** người dùng
**I want to** xem thông tin dinh dưỡng của sản phẩm
**So that** tôi biết giá trị dinh dưỡng của thực phẩm

**Acceptance Criteria:**
- ✅ Tap vào sản phẩm để xem chi tiết
- ✅ Tab "Dinh dưỡng" hiển thị:
  - Calories
  - Protein
  - Carbs
  - Fat
  - Fiber
  - Vitamin & khoáng chất chính
- ✅ Thông tin per 100g
- ✅ Visual chart đẹp mắt (bar chart hoặc pie chart)
- ✅ Có placeholder nếu không có data dinh dưỡng

**Priority:** HIGH
**Estimate:** 5 points

---

### US-3.2: Xem Lợi Ích Sức Khỏe
**As a** người dùng
**I want to** biết sản phẩm này tốt hay xấu cho sức khỏe
**So that** tôi có thể lựa chọn thực phẩm phù hợp

**Acceptance Criteria:**
- ✅ Section "Lợi ích sức khỏe" với icon ✅
- ✅ Danh sách các lợi ích (bullet points)
- ✅ Section "Lưu ý" với icon ⚠️
- ✅ Cảnh báo cho người đặc biệt (tiểu đường, huyết áp cao...)
- ✅ Ngôn ngữ đơn giản, dễ hiểu
- ✅ Có thể mở rộng/thu gọn sections

**Priority:** MEDIUM
**Estimate:** 3 points

---

### US-3.3: Xem Hướng Dẫn Bảo Quản
**As a** người dùng
**I want to** biết cách bảo quản sản phẩm đúng cách
**So that** thực phẩm giữ được lâu hơn

**Acceptance Criteria:**
- ✅ Section "Cách bảo quản"
- ✅ Thời gian bảo quản ở ngăn mát
- ✅ Thời gian bảo quản ở ngăn đông
- ✅ Tips bảo quản (nếu có)
- ✅ Icon trực quan

**Priority:** LOW
**Estimate:** 2 points

---

## 📖 User Stories - Epic 4: Dashboard & Tổng Quan

### US-4.1: Xem Dashboard
**As a** người dùng
**I want to** thấy tổng quan về tủ lạnh của tôi
**So that** tôi nắm được tình hình một cách nhanh chóng

**Acceptance Criteria:**
- ✅ Cards hiển thị:
  - Tổng số sản phẩm
  - Số sản phẩm gần hết hạn
  - Sản phẩm được thêm gần đây
- ✅ Quick stats với numbers lớn, dễ nhìn
- ✅ Visual indicators (progress bars, icons)
- ✅ Tap vào card để xem chi tiết
- ✅ Refresh data khi mở app

**Priority:** MEDIUM
**Estimate:** 3 points

---

### US-4.2: Lọc Theo Category
**As a** người dùng
**I want to** xem sản phẩm theo từng loại
**So that** tôi dễ dàng tìm thấy thực phẩm cần thiết

**Acceptance Criteria:**
- ✅ Chips hoặc tabs cho từng category
- ✅ Tap để lọc
- ✅ Hiển thị số lượng sản phẩm trong mỗi category
- ✅ "Tất cả" để xem toàn bộ
- ✅ Animation mượt khi chuyển category

**Priority:** MEDIUM
**Estimate:** 3 points

---

## 📖 User Stories - Epic 5: Onboarding & Settings

### US-5.1: Onboarding Lần Đầu
**As a** người dùng mới
**I want to** hiểu cách sử dụng app
**So that** tôi có thể bắt đầu nhanh chóng

**Acceptance Criteria:**
- ✅ 3-4 màn hình onboarding với illustrations
- ✅ Giải thích tính năng chính:
  - Thêm sản phẩm
  - Nhận thông báo
  - Xem dinh dưỡng
- ✅ Nút "Skip" để bỏ qua
- ✅ Nút "Bắt đầu" ở màn cuối
- ✅ Chỉ hiển thị lần đầu, lưu state

**Priority:** MEDIUM
**Estimate:** 3 points

---

### US-5.2: Cài Đặt Ngôn Ngữ
**As a** người dùng
**I want to** chọn ngôn ngữ hiển thị
**So that** tôi dùng app bằng ngôn ngữ quen thuộc

**Acceptance Criteria:**
- ✅ Settings page
- ✅ Chọn tiếng Việt hoặc English
- ✅ App restart và hiển thị đúng ngôn ngữ
- ✅ Lưu preference

**Priority:** LOW
**Estimate:** 2 points

---

### US-5.3: Xem Thông Tin App
**As a** người dùng
**I want to** xem thông tin về app
**So that** tôi biết version, liên hệ support

**Acceptance Criteria:**
- ✅ Settings có section "About"
- ✅ Hiển thị version number
- ✅ Link đến Privacy Policy
- ✅ Link đến Terms of Service
- ✅ Contact/Feedback email
- ✅ Rate app button

**Priority:** LOW
**Estimate:** 1 point

---

## 📖 User Stories - Epic 6: Advanced Features (Phase 2)

### US-6.1: Scan Barcode
**As a** người dùng
**I want to** scan barcode để thêm sản phẩm nhanh
**So that** tôi không phải nhập thủ công

**Acceptance Criteria:**
- ✅ Button "Scan" ở màn thêm sản phẩm
- ✅ Mở camera để scan
- ✅ Nhận dạng barcode
- ✅ Tự động điền thông tin sản phẩm
- ✅ Fallback nếu không tìm thấy sản phẩm

**Priority:** LOW (Phase 2)
**Estimate:** 5 points

---

### US-6.2: Đề Xuất Công Thức Nấu Ăn
**As a** người dùng
**I want to** nhận gợi ý món ăn từ thực phẩm có sẵn
**So that** tôi không phải nghĩ nấu gì

**Acceptance Criteria:**
- ✅ Phân tích thực phẩm hiện có
- ✅ Gợi ý 3-5 công thức phù hợp
- ✅ Ưu tiên sản phẩm gần hết hạn
- ✅ Hiển thị ingredients cần thêm (nếu có)
- ✅ Link đến recipe chi tiết

**Priority:** LOW (Phase 2)
**Estimate:** 8 points

---

### US-6.3: Cloud Backup
**As a** người dùng
**I want to** backup data lên cloud
**So that** tôi không mất dữ liệu khi đổi máy

**Acceptance Criteria:**
- ✅ Optional cloud sync
- ✅ Google Drive hoặc iCloud
- ✅ Auto backup hàng ngày
- ✅ Restore data khi cài lại app
- ✅ Conflict resolution

**Priority:** LOW (Phase 2)
**Estimate:** 8 points

---

## 🎯 Story Mapping

### Now (MVP - Phase 1)
1. US-1.1: Thêm sản phẩm
2. US-1.2: Tìm kiếm thông minh
3. US-1.3: Xem danh sách
4. US-1.4: Chỉnh sửa
5. US-1.5: Xóa
6. US-2.1: Nhận thông báo
7. US-2.2: Xem gần hết hạn
8. US-3.1: Xem dinh dưỡng
9. US-4.1: Dashboard

### Next (Enhancement - Phase 2)
1. US-2.3: Tùy chỉnh thông báo
2. US-3.2: Lợi ích sức khỏe
3. US-3.3: Hướng dẫn bảo quản
4. US-4.2: Lọc theo category
5. US-5.1: Onboarding

### Later (Advanced - Phase 3)
1. US-6.1: Scan barcode
2. US-6.2: Đề xuất công thức
3. US-6.3: Cloud backup
4. US-5.2: Đa ngôn ngữ

---

## 📊 Priority Matrix

### High Priority (Must Have)
- Thêm/sửa/xóa sản phẩm
- Tìm kiếm thông minh
- Xem danh sách với màu sắc
- Thông báo hết hạn
- Thông tin dinh dưỡng cơ bản

### Medium Priority (Should Have)
- Dashboard
- Lọc theo category
- Lợi ích sức khỏe
- Tùy chỉnh thông báo
- Onboarding

### Low Priority (Nice to Have)
- Scan barcode
- Đề xuất công thức
- Cloud backup
- Settings nâng cao
- Multi-language

---

## ✅ Definition of Done

Mỗi User Story được coi là hoàn thành khi:
- [ ] Code được implement đầy đủ
- [ ] Unit tests pass
- [ ] UI tests pass
- [ ] Code review approved
- [ ] Tested trên cả iOS và Android
- [ ] Không có critical bugs
- [ ] Performance acceptable (no lag)
- [ ] Accessibility labels added
- [ ] Documentation updated
- [ ] Demo cho stakeholder và approved
