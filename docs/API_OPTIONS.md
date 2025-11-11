# Fresh Keeper - API & Data Source Options

## 🎯 Mục Tiêu

Tìm nguồn dữ liệu **MIỄN PHÍ** và **KHÔNG PHÍ LƯU TRỮ** cho:
1. Thông tin sản phẩm (tên, aliases)
2. Thời gian bảo quản (shelf life)
3. Thông tin dinh dưỡng (nutrition facts)
4. Lợi ích/cảnh báo sức khỏe

---

## 📊 Các Nguồn API Miễn Phí

### ⭐ Option 1: USDA FoodData Central API (RECOMMENDED)

**Provider:** U.S. Department of Agriculture
**URL:** https://fdc.nal.usda.gov/api-guide.html

#### Pros
- ✅ Hoàn toàn miễn phí
- ✅ Dữ liệu chính thống, chính xác
- ✅ Thông tin dinh dưỡng chi tiết
- ✅ Nhiều loại thực phẩm (>800,000)
- ✅ API key miễn phí, không giới hạn request
- ✅ Hỗ trợ search

#### Cons
- ❌ Chủ yếu là tiếng Anh
- ❌ Không có thời gian bảo quản
- ❌ Dữ liệu thiên về thực phẩm Mỹ

#### API Endpoint Example
```bash
# Get API Key (Free)
https://fdc.nal.usda.gov/api-key-signup.html

# Search foods
GET https://api.nal.usda.gov/fdc/v1/foods/search?api_key=YOUR_KEY&query=apple

# Response
{
  "foods": [
    {
      "fdcId": 171688,
      "description": "Apple, raw",
      "dataType": "SR Legacy",
      "foodNutrients": [
        {
          "nutrientName": "Energy",
          "value": 52,
          "unitName": "kcal"
        },
        {
          "nutrientName": "Protein",
          "value": 0.26,
          "unitName": "g"
        }
      ]
    }
  ]
}
```

#### Implementation
```dart
class USDAService {
  static const String apiKey = 'YOUR_API_KEY';
  static const String baseUrl = 'https://api.nal.usda.gov/fdc/v1';

  Future<List<Product>> searchFood(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/foods/search?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['foods'] as List)
          .map((food) => Product.fromUSDA(food))
          .toList();
    }

    throw Exception('Failed to search food');
  }
}
```

---

### ⭐ Option 2: Open Food Facts API

**Provider:** Open Food Facts (Community)
**URL:** https://world.openfoodfacts.org/

#### Pros
- ✅ Hoàn toàn miễn phí
- ✅ Không cần API key
- ✅ Dữ liệu toàn cầu, nhiều ngôn ngữ
- ✅ Có thông tin về bao bì, brand
- ✅ Hỗ trợ barcode lookup
- ✅ Community-driven (có thể đóng góp)

#### Cons
- ❌ Dữ liệu không nhất quán (do cộng đồng)
- ❌ Không có thời gian bảo quản
- ❌ Một số sản phẩm thiếu thông tin

#### API Endpoint Example
```bash
# Search products
GET https://world.openfoodfacts.org/cgi/search.pl?search_terms=apple&json=1

# Get product by barcode
GET https://world.openfoodfacts.org/api/v0/product/[barcode].json

# Response
{
  "product": {
    "product_name": "Apple",
    "brands": "Fresh Farm",
    "nutriments": {
      "energy-kcal": 52,
      "proteins": 0.3,
      "carbohydrates": 14,
      "fat": 0.2,
      "fiber": 2.4
    }
  }
}
```

#### Implementation
```dart
class OpenFoodFactsService {
  static const String baseUrl = 'https://world.openfoodfacts.org';

  Future<List<Product>> searchFood(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cgi/search.pl?search_terms=$query&json=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((product) => Product.fromOpenFoodFacts(product))
          .toList();
    }

    throw Exception('Failed to search food');
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v0/product/$barcode.json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        return Product.fromOpenFoodFacts(data['product']);
      }
    }

    return null;
  }
}
```

---

### Option 3: Nutritionix API

**Provider:** Nutritionix
**URL:** https://www.nutritionix.com/business/api

#### Pros
- ✅ Free tier available (5,000 requests/month)
- ✅ Dữ liệu chính xác
- ✅ Natural language processing
- ✅ Hỗ trợ nhiều loại thực phẩm

#### Cons
- ❌ Giới hạn request (5,000/month)
- ❌ Cần đăng ký API key
- ❌ Không có thời gian bảo quản
- ❌ Chủ yếu tiếng Anh

#### API Endpoint Example
```bash
# Natural language query
POST https://trackapi.nutritionix.com/v2/natural/nutrients
Headers:
  x-app-id: YOUR_APP_ID
  x-app-key: YOUR_APP_KEY
Body: {"query": "1 apple"}

# Response
{
  "foods": [
    {
      "food_name": "apple",
      "nf_calories": 52,
      "nf_protein": 0.3,
      "nf_total_carbohydrate": 14
    }
  ]
}
```

---

### Option 4: Edamam Food Database API

**Provider:** Edamam
**URL:** https://developer.edamam.com/food-database-api

#### Pros
- ✅ Free tier (100 requests/day)
- ✅ Dữ liệu chính xác
- ✅ Parser API (natural language)

#### Cons
- ❌ Giới hạn request
- ❌ Cần đăng ký
- ❌ Không có shelf life

---

## 🗃️ Option 5: LOCAL DATABASE (RECOMMENDED for MVP)

### Approach: Tự Tạo Database JSON/SQLite

#### Pros
- ✅ Không phụ thuộc internet
- ✅ Không giới hạn request
- ✅ Tùy chỉnh dữ liệu theo nhu cầu Việt Nam
- ✅ Không phát sinh chi phí
- ✅ Nhanh, reliable
- ✅ Có thể thêm shelf life data

#### Cons
- ❌ Cần tạo dữ liệu ban đầu
- ❌ Giới hạn số lượng sản phẩm
- ❌ Cần cập nhật thủ công

### Data Sources để Crawl/Tổng Hợp

#### 1. Wikipedia
- Thông tin dinh dưỡng của thực phẩm phổ biến
- Có tiếng Việt
- https://vi.wikipedia.org/wiki/Danh_sách_thực_phẩm

#### 2. Vinmec/VNExpress Sức Khỏe
- Lợi ích sức khỏe
- Cách bảo quản
- Tiếng Việt

#### 3. FDA Food Storage Chart
- https://www.fda.gov/food/consumers/food-product-dating
- Thời gian bảo quản chính xác

#### 4. StillTasty.com
- http://www.stilltasty.com/
- Comprehensive shelf life data

### Initial Database Structure

**products_database.json**
```json
{
  "version": "1.0.0",
  "last_updated": "2025-01-20",
  "total_products": 500,
  "products": [
    {
      "id": "apple_fuji",
      "name_vi": "Táo Fuji",
      "name_en": "Fuji Apple",
      "aliases": ["táo", "tao", "apple", "fuji"],
      "category": "fruits",
      "shelf_life": {
        "refrigerated_days": 7,
        "frozen_days": 240,
        "opened_days": 3,
        "room_temp_days": 5
      },
      "nutrition": {
        "serving_size": "100g",
        "calories": 52,
        "protein": 0.3,
        "carbohydrates": 14,
        "fat": 0.2,
        "fiber": 2.4,
        "sugar": 10.3,
        "vitamins": {
          "vitamin_c_mg": 4.6,
          "vitamin_a_iu": 54
        },
        "minerals": {
          "potassium_mg": 107,
          "calcium_mg": 6,
          "iron_mg": 0.12
        }
      },
      "health_benefits": [
        "Giàu chất xơ, tốt cho tiêu hóa",
        "Chứa vitamin C, tăng cường miễn dịch",
        "Ít calories, phù hợp giảm cân",
        "Chất chống oxy hóa cao"
      ],
      "health_warnings": [
        "Người dị ứng táo nên tránh",
        "Rửa sạch trước khi ăn"
      ],
      "storage_tips": "Bảo quản trong ngăn rau củ của tủ lạnh",
      "suitable_for": ["weight_loss", "diabetes", "kids"],
      "tags": ["fresh", "organic", "vitamin_c"]
    }
    // ... 500-1000 products
  ]
}
```

### Priority Products List (500 items minimum)

#### Rau Củ Quả (100 items)
- Cà chua, dưa chuột, rau cải, rau muống, cải bắp, súp lơ, bông cải xanh, cà rốt, khoai tây, khoai lang, củ cải, hành tây, tỏi, ớt, cà tím, bí đỏ, bí xanh, đậu cove, đậu đũa, đỗ, nấm các loại...

#### Trái Cây (80 items)
- Táo, chuối, cam, quýt, bưởi, xoài, đu đủ, dưa hấu, dứa, nho, dâu tây, việt quất, cherry, đào, lê, mận, kiwi, thanh long, chôm chôm, nhãn, vải, măng cụt...

#### Thịt (60 items)
- Thịt bò, thịt heo, thịt gà, thịt vịt, thịt cừu, thịt nai, gan, tim, lưỡi, thịt băm, sườn, ba chỉ, nạc, móng giò...

#### Hải Sản (50 items)
- Cá thu, cá hồi, cá ngừ, cá chép, tôm, cua, ghẹ, mực, bạch tuộc, sò, nghêu, ốc, hàu...

#### Trứng & Sữa (40 items)
- Trứng gà, trứng vịt, trứng cút, sữa tươi, sữa chua, phô mai, bơ, kem, yogurt...

#### Đồ Khô (80 items)
- Gạo, mì, bún, phở, miến, bánh mì, bánh quy, ngũ cốc, yến mạch, đậu các loại, hạt điều, hạt macadamia...

#### Gia Vị (40 items)
- Muối, đường, nước mắm, tương ớt, tương đen, dầu ăn, giấm, tiêu, ớt bột, nghệ, gừng...

#### Đồ Đông Lạnh (50 items)
- Kem, pizza đông lạnh, dimsum, há cảo, chả giò, xúc xích...

---

## 🎯 Recommended Strategy: HYBRID APPROACH

### Phase 1: MVP (Local Only)
```
1. Tạo local database với 500 sản phẩm phổ biến
2. Load từ JSON file vào SQLite khi first launch
3. User search trong local database
4. Offline-first, không cần internet
```

**Pros:**
- Fast to implement
- No cost
- Offline support
- Control over data quality

**Implementation Timeline:** 2-3 weeks for data collection

### Phase 2: Enhancement (Hybrid)
```
1. Local database làm primary source
2. Fallback sang API nếu không tìm thấy
3. Cache kết quả từ API vào local database
4. Gradually expand local database
```

**APIs to integrate:**
- USDA for nutrition data
- Open Food Facts for barcode support

### Phase 3: Community (Future)
```
1. Allow users to add custom products
2. Share community database (optional)
3. Crowdsource data quality improvements
```

---

## 📊 Data Collection Plan

### Week 1: Research & Setup
- [ ] Research Vietnamese food names
- [ ] Setup crawling scripts
- [ ] Define data schema
- [ ] Setup validation rules

### Week 2-3: Data Collection
- [ ] 100 vegetables (priority: common ones)
- [ ] 80 fruits
- [ ] 60 meats
- [ ] 50 seafood
- [ ] 40 eggs & dairy
- [ ] 80 dry food
- [ ] 40 condiments
- [ ] 50 frozen food

### Week 4: Validation & Testing
- [ ] Verify nutrition data
- [ ] Check shelf life accuracy
- [ ] Test search functionality
- [ ] User testing with real data

---

## 🛠️ Crawling Script Example

```python
import requests
from bs4 import BeautifulSoup
import json

def crawl_food_data(food_name):
    # Wikipedia
    wiki_url = f"https://vi.wikipedia.org/wiki/{food_name}"
    response = requests.get(wiki_url)
    soup = BeautifulSoup(response.content, 'html.parser')

    # Parse nutrition table
    nutrition_table = soup.find('table', class_='infobox')

    # USDA API
    usda_url = f"https://api.nal.usda.gov/fdc/v1/foods/search"
    params = {
        'api_key': 'YOUR_KEY',
        'query': food_name
    }
    usda_response = requests.get(usda_url, params=params)
    usda_data = usda_response.json()

    # Combine data
    product = {
        'name_vi': food_name,
        'nutrition': parse_usda_nutrition(usda_data),
        'shelf_life': get_shelf_life_from_fda(food_name),
        'health_info': parse_wiki_health(soup)
    }

    return product

# Save to JSON
with open('products_database.json', 'w', encoding='utf-8') as f:
    json.dump(products, f, ensure_ascii=False, indent=2)
```

---

## ✅ Final Recommendation

### For MVP (Phase 1)
**Use Local Database JSON + SQLite**

**Rationale:**
1. No dependency on internet
2. Fast & reliable
3. No cost
4. Full control over Vietnamese data
5. Can always add API later

**Data Strategy:**
- Start with 500 most common products
- Focus on Vietnamese market
- Use USDA/Open Food Facts as reference
- Manual curation for quality

### For Phase 2
**Add API Integration**
- USDA for nutrition lookup
- Open Food Facts for barcode
- Cache results locally

### Database File Size Estimate
```
500 products with full data:
- JSON: ~2-3 MB
- SQLite: ~5 MB
- Images: ~50 MB (100KB each)
Total: ~60 MB initial app size
```

This is acceptable for mobile apps.

---

## 📝 Action Items

- [ ] Create products_database.json template
- [ ] Collect 500 product data
- [ ] Implement database loader
- [ ] Test search performance
- [ ] Validate data accuracy
- [ ] (Optional) Setup API integration for Phase 2
