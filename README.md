# 🧊 Fresh Keeper - Quản Lý Tủ Lạnh Thông Minh

> Ứng dụng Flutter giúp quản lý thực phẩm trong tủ lạnh, giảm lãng phí và theo dõi dinh dưỡng

---

## 📋 Tổng Quan

**Fresh Keeper** là ứng dụng mobile (iOS & Android) giúp người dùng:
- ✅ Quản lý tất cả thực phẩm trong tủ lạnh
- ✅ Nhận thông báo trước khi thực phẩm hết hạn
- ✅ Xem thông tin dinh dưỡng và lợi ích sức khỏe
- ✅ Tìm kiếm thông minh với gợi ý sản phẩm
- ✅ Giao diện đẹp, thân thiện, dễ sử dụng

**Target Users:** Phụ nữ nội trợ, người quan tâm sức khỏe, người sống một mình

---

## 🎯 Trạng Thái Dự Án

**Giai đoạn:** Planning & Documentation ✅

- [x] Phân tích yêu cầu
- [x] Viết user stories
- [x] Thiết kế wireframes
- [x] Định nghĩa data structure
- [x] Chọn tech stack
- [x] Viết prompts để code
- [ ] **Bắt đầu coding** ← You are here!

---

## 📚 Documentation

Tất cả tài liệu được lưu trong thư mục [`docs/`](docs/):

### 1. [REQUIREMENTS.md](docs/REQUIREMENTS.md)
**Yêu cầu tổng quan của dự án**
- Mục tiêu, đối tượng người dùng
- Tính năng chính
- Yêu cầu UI/UX
- Phases phát triển

👉 **Đọc đầu tiên** để hiểu tổng quan dự án

---

### 2. [USER_STORIES.md](docs/USER_STORIES.md)
**User stories chi tiết**
- 6 epics chính
- 20+ user stories
- Story mapping

👉 Dùng để hiểu nhu cầu người dùng

---

### 3. [FEATURES.md](docs/FEATURES.md)
**Chi tiết từng tính năng**
- Cấu trúc màn hình
- Components UI
- Business logic

👉 Tham khảo khi implement features

---

### 4. [DATA_STRUCTURE.md](docs/DATA_STRUCTURE.md)
**Database schema và models**
- SQLite table schemas
- Dart model classes
- Sample data format

👉 **Quan trọng** cho database và models

---

### 5. [WIREFRAMES.md](docs/WIREFRAMES.md)
**Wireframes chi tiết cho tất cả màn hình**
- 15+ screens với ASCII art
- Interaction states
- Design specifications

👉 **Bắt buộc đọc** trước khi code UI

---

### 6. [UI_UX_GUIDELINES.md](docs/UI_UX_GUIDELINES.md)
**Hướng dẫn thiết kế UI/UX**
- Color palette
- Typography
- Components
- Animations

👉 Tham khảo khi code UI

---

### 7. [TECH_STACK.md](docs/TECH_STACK.md)
**Technology stack và architecture**
- Flutter packages
- Architecture pattern
- Project structure

👉 Setup project và chọn packages

---

### 8. [API_OPTIONS.md](docs/API_OPTIONS.md)
**Các lựa chọn API và data source**
- USDA API, Open Food Facts
- Local database approach
- Data collection plan

👉 Quyết định data strategy

---

### 9. [PROMPTS.md](docs/PROMPTS.md) ⭐
**Prompts để code với AI assistant**
- 50+ prompts chi tiết
- Development sequence
- Quick start commands

👉 **FILE QUAN TRỌNG NHẤT** để bắt đầu code!

---

## 🚀 Bắt Đầu Coding

### Bước 1: Đọc Documentation
1. Đọc [REQUIREMENTS.md](docs/REQUIREMENTS.md) - hiểu tổng quan
2. Xem [WIREFRAMES.md](docs/WIREFRAMES.md) - biết app trông như thế nào
3. Review [DATA_STRUCTURE.md](docs/DATA_STRUCTURE.md) - hiểu database
4. Check [TECH_STACK.md](docs/TECH_STACK.md) - biết dùng gì
5. Mở [PROMPTS.md](docs/PROMPTS.md) - ready to code!

### Bước 2: Sử dụng Prompts
1. Mở file `docs/PROMPTS.md`
2. Copy Prompt 1.1 (Setup Project)
3. Paste vào AI assistant (Claude, ChatGPT, v.v.)
4. Nhận code và implement
5. Tiếp tục với Prompt 1.2, 1.3, ...

### Bước 3: Development Timeline
```
Week 1-2:  Setup + Database + Models
Week 3-4:  Repositories + State Management
Week 5-6:  UI Screens
Week 7-8:  Advanced Features
Week 9-10: Testing + Polish
```

---

## 📁 Cấu Trúc Project

```
fresh_keeper/
├── README.md                  ← You are here
├── docs/                      ← All documentation
│   ├── REQUIREMENTS.md
│   ├── USER_STORIES.md
│   ├── FEATURES.md
│   ├── DATA_STRUCTURE.md
│   ├── WIREFRAMES.md
│   ├── UI_UX_GUIDELINES.md
│   ├── TECH_STACK.md
│   ├── API_OPTIONS.md
│   └── PROMPTS.md            ← Start here!
│
├── lib/                       ← Flutter source code
├── assets/                    ← Images, data, fonts
├── test/                      ← Tests
└── pubspec.yaml              ← Dependencies
```

---

## 🛠️ Tech Stack

- **Framework:** Flutter 3.3+
- **Language:** Dart 3.0+
- **State Management:** Provider
- **Database:** SQLite
- **Notifications:** flutter_local_notifications
- **Platform:** iOS 13.0+ & Android 5.0+

---

## 🎨 Design Highlights

### Colors
- 🟢 **Primary:** #7DDDC9 (Mint Green)
- 🩷 **Secondary:** #FFB6C1 (Pink Pastel)
- 🔴 **Accent:** #FF6B6B (Coral Red)

### Key Features
- Feminine, friendly design
- Color-coded expiry status (🟢🟡🔴)
- Smart search with suggestions
- Local notifications
- Offline-first

---

## 📱 Screenshots Preview

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Home       │  │  Add Product │  │  All Items   │
│   Dashboard  │  │  With Search │  │  Color Coded │
│              │  │              │  │              │
│  📊 Stats    │  │  🔍 Search   │  │  🟢 Fresh    │
│  ⚠️  Expiring│  │  📅 Dates    │  │  🟡 Soon     │
│  🆕 Recent   │  │  💡 Auto-fill│  │  🔴 Urgent   │
└──────────────┘  └──────────────┘  └──────────────┘
```

Chi tiết: [WIREFRAMES.md](docs/WIREFRAMES.md)

---

## ✅ Checklist Trước Khi Code

### Documentation
- [ ] Đọc xong REQUIREMENTS.md
- [ ] Xem hết WIREFRAMES.md
- [ ] Hiểu DATA_STRUCTURE.md
- [ ] Sẵn sàng với PROMPTS.md

### Setup
- [ ] Flutter SDK installed
- [ ] IDE setup (VS Code / Android Studio)
- [ ] Git initialized

---

## 🤖 Làm Việc Với AI Assistant

### Cách Sử Dụng Prompts

1. Mở file `docs/PROMPTS.md`
2. Copy prompt cần dùng
3. Paste vào AI assistant
4. Review code được generate
5. Test và commit!

### Tips
- ✅ Làm từng module nhỏ
- ✅ Test ngay sau khi code
- ✅ Commit thường xuyên
- ✅ Đọc kỹ documentation

---

## 🎉 Ready to Start!

### Next Step:
```bash
# Open PROMPTS.md
open docs/PROMPTS.md

# Start with Prompt 1.1
# Copy → Paste to AI → Code → Test → Commit!
```

---

## 📈 Roadmap

### Q1 2025
- [x] Planning & Documentation
- [ ] MVP Development
- [ ] Beta Release

### Q2 2025
- [ ] Public Release
- [ ] Phase 2 Features

---

**Let's build Fresh Keeper! 🚀**

_Documentation created: January 2025_
