# Fresh Keeper - UI/UX Guidelines

## 🎨 Design Philosophy

**Core Principles:**
1. **Feminine & Friendly:** Thiết kế mềm mại, ấm áp, thu hút phụ nữ
2. **Simple & Intuitive:** Dễ sử dụng, không cần hướng dẫn
3. **Clean & Minimal:** Gọn gàng, không lộn xộn
4. **Trustworthy:** Chuyên nghiệp, đáng tin cậy

---

## 🎨 Color Palette

### Primary Colors

```
┌─────────────────────────────────────────┐
│  PRIMARY - Mint Green                   │
│  #7DDDC9                                │
│  RGB: 125, 221, 201                     │
│  ██████████████████████████████████     │
│  - Main brand color                     │
│  - CTA buttons                          │
│  - Active states                        │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  SECONDARY - Pink Pastel               │
│  #FFB6C1                                │
│  RGB: 255, 182, 193                     │
│  ██████████████████████████████████     │
│  - Accents                              │
│  - Highlights                           │
│  - Secondary buttons                    │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  ACCENT - Coral Red                     │
│  #FF6B6B                                │
│  RGB: 255, 107, 107                     │
│  ██████████████████████████████████     │
│  - Urgent alerts                        │
│  - Delete actions                       │
│  - Expired items                        │
└─────────────────────────────────────────┘
```

### Status Colors

```
┌──────────────┬──────────────┬──────────────┐
│  GREEN       │  ORANGE      │  RED         │
│  #4CAF50     │  #FF9800     │  #F44336     │
│  ████████    │  ████████    │  ████████    │
│  > 7 days    │  3-7 days    │  < 3 days    │
│  Fresh       │  Use soon    │  Urgent      │
└──────────────┴──────────────┴──────────────┘
```

### Neutral Colors

```
Background:
  - White:      #FFFFFF
  - Cream:      #FFFEF7 (warm white)
  - Light Gray: #F5F5F5

Text:
  - Primary:    #333333
  - Secondary:  #757575
  - Disabled:   #BDBDBD

Borders:
  - Light:      #E0E0E0
  - Medium:     #BDBDBD
  - Dark:       #757575
```

---

## 📝 Typography

### Font Families

**iOS:**
- Primary: SF Pro Display / SF Pro Text
- Fallback: System Default

**Android:**
- Primary: Roboto
- Fallback: System Default

### Font Styles

```
┌─────────────────────────────────────────┐
│  H1 - Page Title                        │
│  28pt, Bold, #333333                    │
│  Line Height: 34pt                      │
│  Fresh Keeper                           │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  H2 - Section Title                     │
│  24pt, Bold, #333333                    │
│  Line Height: 30pt                      │
│  Gần Hết Hạn                            │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  H3 - Card Title                        │
│  20pt, Semi-Bold, #333333               │
│  Line Height: 26pt                      │
│  Táo Fuji                               │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  Body 1 - Primary Text                  │
│  16pt, Regular, #333333                 │
│  Line Height: 24pt                      │
│  Đây là nội dung chính của ứng dụng    │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  Body 2 - Secondary Text                │
│  14pt, Regular, #757575                 │
│  Line Height: 20pt                      │
│  Thông tin phụ và mô tả                │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  Caption - Labels & Tags                │
│  12pt, Regular, #757575                 │
│  Line Height: 16pt                      │
│  Còn 5 ngày • Rau củ                    │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  Button Text                            │
│  16pt, Semi-Bold, #FFFFFF               │
│  Letter Spacing: 0.5pt                  │
│  THÊM SẢN PHẨM                          │
└─────────────────────────────────────────┘
```

### Font Weight Usage
- **Bold (700):** Headings, important info
- **Semi-Bold (600):** Buttons, emphasis
- **Medium (500):** Subheadings
- **Regular (400):** Body text
- **Light (300):** Captions, hints

---

## 📐 Spacing & Layout

### Grid System
- **Base Unit:** 8pt
- **Common Values:** 8, 12, 16, 24, 32, 48pt

### Margins & Padding

```
Screen Margins:
  - Left/Right: 16pt
  - Top/Bottom: 16pt (safe area aware)

Card Padding:
  - Internal: 16pt
  - Between elements: 12pt

List Item Spacing:
  - Between items: 12pt
  - Item padding: 16pt

Section Spacing:
  - Between sections: 24pt
  - Section title margin: 16pt bottom
```

### Touch Targets
```
Minimum: 44x44pt (iOS HIG requirement)
Recommended: 48x48pt

Examples:
  - Buttons: 48pt height minimum
  - List items: 56pt height minimum
  - Icons: 24x24pt with 10pt padding
  - Checkboxes: 24x24pt
```

---

## 🔘 Components

### Buttons

#### Primary Button
```
┌───────────────────────────────┐
│      THÊM SẢN PHẨM            │
└───────────────────────────────┘

Style:
  - Background: #7DDDC9 (Primary)
  - Text: #FFFFFF, 16pt, Semi-Bold
  - Height: 48pt
  - Border Radius: 8pt
  - Shadow: 0 2px 4px rgba(0,0,0,0.1)

States:
  - Normal: Full opacity
  - Pressed: 0.8 opacity
  - Disabled: 0.4 opacity
```

#### Secondary Button
```
┌───────────────────────────────┐
│           Hủy                 │
└───────────────────────────────┘

Style:
  - Background: #FFFFFF
  - Border: 1pt solid #7DDDC9
  - Text: #7DDDC9, 16pt, Semi-Bold
  - Height: 48pt
  - Border Radius: 8pt
```

#### Text Button
```
┌───────────────────────────────┐
│  Xem tất cả →                 │
└───────────────────────────────┘

Style:
  - Background: Transparent
  - Text: #7DDDC9, 14pt, Semi-Bold
  - Padding: 8pt
```

#### Floating Action Button (FAB)
```
    ┌─────┐
    │  +  │
    └─────┘

Style:
  - Size: 56x56pt
  - Background: #7DDDC9
  - Icon: #FFFFFF, 24x24pt
  - Border Radius: 28pt (circular)
  - Shadow: 0 4px 8px rgba(0,0,0,0.2)
  - Position: Bottom center, 16pt from bottom bar
```

### Cards

```
┌─────────────────────────────────────┐
│  🍎 Táo Fuji               🟢      │
│  Trái cây • Còn 10 ngày             │
│  Số lượng: 5 cái                    │
│  HSD: 30/01/2025                    │
└─────────────────────────────────────┘

Style:
  - Background: #FFFFFF
  - Border Radius: 12pt
  - Shadow: 0 2px 8px rgba(0,0,0,0.08)
  - Padding: 16pt
  - Margin: 12pt between cards
```

### Input Fields

```
┌─────────────────────────────────────┐
│  🔍 Tìm kiếm sản phẩm...            │
└─────────────────────────────────────┘

Style:
  - Height: 48pt
  - Background: #F5F5F5
  - Border: 1pt solid transparent
  - Border Radius: 8pt
  - Padding: 12pt 16pt
  - Text: 16pt, #333333
  - Placeholder: 16pt, #BDBDBD

Focus State:
  - Background: #FFFFFF
  - Border: 1pt solid #7DDDC9
```

### Dropdown

```
┌─────────────────────────────────────┐
│  🥬 Rau củ quả              [▼]    │
└─────────────────────────────────────┘

Style:
  - Same as input field
  - Icon: 20x20pt chevron
  - Expandable list with checkmarks
```

### Chips (Category)

```
[🥬 Rau củ: 12] [🍎 Trái cây: 8] →

Style:
  - Height: 32pt
  - Background: #F5F5F5 (unselected)
  - Background: #7DDDC9 (selected)
  - Text: 14pt, #333333 / #FFFFFF
  - Border Radius: 16pt
  - Padding: 8pt 12pt
  - Icon: 16x16pt emoji
```

### Badges

```
🔔 (5)

Style:
  - Size: 20x20pt minimum
  - Background: #FF6B6B
  - Text: #FFFFFF, 12pt, Bold
  - Border Radius: 10pt (circular)
  - Border: 2pt solid #FFFFFF
```

### Status Indicators

```
🟢 🟡 🔴

Style:
  - Size: 12x12pt
  - Colors: Green, Orange, Red
  - Border Radius: 6pt (circular)
  - Position: Top right of card
```

---

## 🎭 Icons

### Icon Style
- **Type:** Rounded, friendly style
- **Weight:** Regular (not too thin, not too bold)
- **Size:** 24x24pt for navigation, 20x20pt for inline

### Icon Set
```
Navigation:
  🏠 Home
  ⚠️  Expiring
  ➕ Add
  📋 All Items
  ⚙️  Settings

Actions:
  ✏️  Edit
  🗑️  Delete
  ✓  Done
  ✕  Close
  ↻  Refresh

Categories:
  🥬 Vegetables
  🍎 Fruits
  🥩 Meat
  🥚 Eggs
  🥛 Dairy
  🍞 Dry Food
  🧊 Frozen
  🧂 Condiments
  📦 Other

Misc:
  🔍 Search
  🔔 Notification
  📅 Calendar
  📷 Camera
  🖼️  Gallery
  ℹ️  Info
```

### Icon Colors
- Active: #7DDDC9
- Inactive: #BDBDBD
- On Primary: #FFFFFF
- Destructive: #FF6B6B

---

## 🎬 Animations & Transitions

### Principles
1. **Fast & Responsive:** 150-300ms
2. **Natural & Physics-based:** Ease-in-out curves
3. **Meaningful:** Animations should guide user attention
4. **Subtle:** Don't distract from content

### Common Animations

#### Page Transitions
```
Duration: 250ms
Easing: ease-in-out

Push (Navigate forward):
  - Slide from right to left
  - Fade in simultaneously

Pop (Navigate back):
  - Slide from left to right
  - Fade out simultaneously
```

#### Button Press
```
Duration: 100ms
Easing: ease-out

States:
  - Normal → Pressed: Scale to 0.95
  - Pressed → Normal: Scale to 1.0
```

#### Card Tap
```
Duration: 150ms
Easing: ease-out

Effect:
  - Slight elevation increase
  - Shadow grows
  - Subtle scale (1.02)
```

#### List Item Swipe
```
Duration: 250ms
Easing: ease-in-out

Reveal:
  - Swipe left reveals actions
  - Actions slide in from right
  - Haptic feedback at threshold
```

#### Loading States
```
Skeleton Shimmer:
  - Duration: 1000ms
  - Direction: Left to right
  - Gradient overlay animation

Spinner:
  - Size: 24x24pt
  - Color: #7DDDC9
  - Continuous rotation
```

#### Success Feedback
```
Duration: 400ms
Easing: spring (bounce)

Effect:
  - Checkmark scale animation
  - Green background pulse
  - Haptic success feedback
```

---

## 📱 Platform-Specific Guidelines

### iOS

#### Navigation
- Use native UINavigationController
- Large title for main screens
- Standard navigation bar
- Swipe from left edge to go back

#### Tab Bar
- Bottom navigation with 5 items max
- Icons with labels
- Selected state: Primary color
- Unselected state: Gray

#### Gestures
- Swipe actions on list items
- Pull to refresh
- Long press for context menu

#### Feedback
- Haptic feedback for important actions
- Native alerts and action sheets

### Android

#### Navigation
- Material You design principles
- Top app bar with title
- Back button in navigation
- Material motion for transitions

#### Bottom Navigation
- Material bottom navigation bar
- 5 items with icons + labels
- Ripple effect on tap

#### Gestures
- Swipe actions (with undo snackbar)
- Pull to refresh
- Long press for selection mode

#### Feedback
- Material ripple effects
- Snackbars for feedback
- Material dialogs

---

## ♿ Accessibility

### Text Accessibility
```
Font Sizes (Support Dynamic Type):
  - Small: -2pt
  - Default: 0pt
  - Large: +2pt
  - Extra Large: +4pt
  - Accessibility 1: +8pt
  - Accessibility 2: +12pt
```

### Color Contrast
- **Text on White:** 4.5:1 minimum (WCAG AA)
- **Primary on White:** 3:1 minimum
- **Status indicators:** Use both color AND shape/text

### Touch Targets
- Minimum 44x44pt (iOS)
- Minimum 48x48dp (Android)
- Adequate spacing between tappable elements

### Screen Reader Support
- All images have alt text
- Buttons have descriptive labels
- Form fields have labels
- Proper heading hierarchy

### Voice Control
- All interactive elements have names
- Support for voice navigation
- Clear button labels

---

## 🌙 Dark Mode (Future)

### Color Adaptations
```
Background:
  Light: #FFFFFF → Dark: #121212

Surface:
  Light: #F5F5F5 → Dark: #1E1E1E

Text Primary:
  Light: #333333 → Dark: #E0E0E0

Text Secondary:
  Light: #757575 → Dark: #A0A0A0

Primary Color:
  Light: #7DDDC9 → Dark: #5DBAA8 (slightly darker)
```

---

## 📸 Imagery

### Product Images
- Aspect Ratio: 1:1 (square)
- Size: 200x200pt @2x, 300x300pt @3x
- Format: JPEG (photos), PNG (transparent)
- Compression: 80% quality

### Illustrations
- Style: Flat, friendly, colorful
- Use for: Onboarding, empty states
- Colors: From brand palette
- Format: SVG (scalable)

### Icons
- Format: Vector (SVG or Font)
- Size: 24x24pt standard
- Color: Tintable (single color)

---

## 🎨 Motion Design

### Micro-interactions

#### Add to List
```
1. Button press (scale down)
2. Item appears at top with slide down + fade in
3. List items below shift down
4. Success checkmark briefly appears
5. Badge counter updates with bounce
```

#### Mark as Used
```
1. Checkbox tap with haptic
2. Checkmark draws in (animated)
3. Item background changes to green
4. After 300ms, item slides out
5. Items below slide up to fill space
```

#### Delete Item
```
1. Swipe left to reveal delete button
2. Tap delete
3. Confirmation alert slides up
4. On confirm: Item fades out + slides left
5. Items below slide up
6. Snackbar appears: "Đã xóa" with UNDO
```

---

## ✅ UI/UX Checklist

### Before Development
- [ ] All screens have wireframes
- [ ] Color palette defined
- [ ] Typography scale established
- [ ] Component library planned
- [ ] Animation specs documented
- [ ] Accessibility requirements noted

### During Development
- [ ] Follow design system strictly
- [ ] Test on multiple screen sizes
- [ ] Verify color contrast
- [ ] Check touch target sizes
- [ ] Test with real content
- [ ] Verify dark mode (if applicable)

### Before Launch
- [ ] User testing completed
- [ ] Accessibility audit passed
- [ ] Performance optimization done
- [ ] Animations are smooth (60fps)
- [ ] All states are designed (loading, error, empty)
- [ ] Cross-platform consistency verified

---

## 🎯 Key Takeaways

1. **Consistency:** Use design system components everywhere
2. **Simplicity:** Remove unnecessary elements
3. **Feedback:** Always acknowledge user actions
4. **Performance:** Smooth animations, fast responses
5. **Accessibility:** Design for everyone
6. **Platform:** Respect platform conventions
7. **User Testing:** Validate with real users

---

## 📚 Resources

### Design Tools
- **Figma:** For UI design
- **Adobe Illustrator:** For illustrations
- **SF Symbols (iOS):** System icons
- **Material Icons (Android):** System icons

### Inspiration
- **Dribbble:** Food & health app designs
- **Behance:** UI/UX case studies
- **Mobbin:** Mobile app patterns
- **Pinterest:** Feminine design inspiration

### Guidelines
- **iOS HIG:** Human Interface Guidelines
- **Material Design:** Material Design 3
- **WCAG:** Web Content Accessibility Guidelines
