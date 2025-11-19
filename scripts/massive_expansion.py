#!/usr/bin/env python3
"""
Massive database expansion:
- Fruits: 100+ products
- Meat: Complete Vietnamese meat cuts
"""

import json
from pathlib import Path

# This will be a HUGE list - 78+ fruits
MASSIVE_FRUITS = [
    # Vietnamese citrus varieties
    {"id": "orange_sanh", "name_vi": "Cam sành", "name_en": "Sanh Orange", "shelf_life": 14},
    {"id": "orange_canh", "name_vi": "Cam canh", "name_en": "Canh Orange", "shelf_life": 14},
    {"id": "tangerine", "name_vi": "Quýt", "name_en": "Tangerine", "shelf_life": 10},
    {"id": "tangerine_hong", "name_vi": "Quýt hồng", "name_en": "Red Tangerine", "shelf_life": 10},
    {"id": "pomelo_green", "name_vi": "Bưởi da xanh", "name_en": "Green Pomelo", "shelf_life": 21},
    {"id": "pomelo_red", "name_vi": "Bưởi đỏ", "name_en": "Red Pomelo", "shelf_life": 21},
    {"id": "lime", "name_vi": "Chanh", "name_en": "Lime", "shelf_life": 14},
    {"id": "lemon", "name_vi": "Chanh vàng", "name_en": "Lemon", "shelf_life": 14},
    {"id": "kumquat", "name_vi": "Tắc", "name_en": "Kumquat", "shelf_life": 10},

    # Mango varieties
    {"id": "mango_cat", "name_vi": "Xoài cát", "name_en": "Cat Mango", "shelf_life": 7},
    {"id": "mango_tuong", "name_vi": "Xoài tượng", "name_en": "Elephant Mango", "shelf_life": 7},
    {"id": "mango_australia", "name_vi": "Xoài Úc", "name_en": "Australian Mango", "shelf_life": 7},
    {"id": "mango_green", "name_vi": "Xoài xanh", "name_en": "Green Mango", "shelf_life": 10},
    {"id": "mango_hoa_loc", "name_vi": "Xoài hoa lộc", "name_en": "Hoa Loc Mango", "shelf_life": 7},

    # Banana varieties
    {"id": "banana_tieu", "name_vi": "Chuối tiêu", "name_en": "Tieu Banana", "shelf_life": 5},
    {"id": "banana_ngu", "name_vi": "Chuối ngự", "name_en": "Royal Banana", "shelf_life": 5},
    {"id": "banana_su", "name_vi": "Chuối sứ", "name_en": "Su Banana", "shelf_life": 7},
    {"id": "banana_cau", "name_vi": "Chuối cau", "name_en": "Cau Banana", "shelf_life": 5},
    {"id": "banana_gia", "name_vi": "Chuối già", "name_en": "Old Banana", "shelf_life": 7},

    # Longan/Lychee/Rambutan varieties
    {"id": "longan_hungyen", "name_vi": "Nhãn Hưng Yên", "name_en": "Hung Yen Longan", "shelf_life": 7},
    {"id": "lychee_thieu", "name_vi": "Vải thiều", "name_en": "Thieu Lychee", "shelf_life": 5},
    {"id": "lychee_early", "name_vi": "Vải sớm", "name_en": "Early Lychee", "shelf_life": 5},

    # Durian varieties
    {"id": "durian_monthong", "name_vi": "Sầu riêng Monthong", "name_en": "Monthong Durian", "shelf_life": 5},
    {"id": "durian_ri6", "name_vi": "Sầu riêng Ri 6", "name_en": "Ri 6 Durian", "shelf_life": 5},
    {"id": "durian_musang", "name_vi": "Sầu riêng cơm vàng", "name_en": "Musang King", "shelf_life": 5},

    # Berries (International)
    {"id": "strawberry_dalat", "name_vi": "Dâu tây Đà Lạt", "name_en": "Dalat Strawberry", "shelf_life": 3},
    {"id": "blueberry", "name_vi": "Việt quất", "name_en": "Blueberry", "shelf_life": 7},
    {"id": "raspberry", "name_vi": "Mâm xôi", "name_en": "Raspberry", "shelf_life": 3},
    {"id": "blackberry", "name_vi": "Dâu đen", "name_en": "Blackberry", "shelf_life": 3},
    {"id": "cranberry", "name_vi": "Nam việt quất", "name_en": "Cranberry", "shelf_life": 14},
    {"id": "mulberry", "name_vi": "Dâu tằm", "name_en": "Mulberry", "shelf_life": 3},

    # Grapes
    {"id": "grape_black", "name_vi": "Nho đen", "name_en": "Black Grape", "shelf_life": 7},
    {"id": "grape_green", "name_vi": "Nho xanh", "name_en": "Green Grape", "shelf_life": 7},
    {"id": "grape_red", "name_vi": "Nho đỏ", "name_en": "Red Grape", "shelf_life": 7},
    {"id": "grape_ninh_thuan", "name_vi": "Nho Ninh Thuận", "name_en": "Ninh Thuan Grape", "shelf_life": 7},

    # Apples
    {"id": "apple_gala", "name_vi": "Táo Gala", "name_en": "Gala Apple", "shelf_life": 21},
    {"id": "apple_green", "name_vi": "Táo xanh", "name_en": "Green Apple", "shelf_life": 21},
    {"id": "apple_red", "name_vi": "Táo đỏ", "name_en": "Red Apple", "shelf_life": 21},
    {"id": "apple_envy", "name_vi": "Táo Envy", "name_en": "Envy Apple", "shelf_life": 21},
    {"id": "apple_pink_lady", "name_vi": "Táo Pink Lady", "name_en": "Pink Lady Apple", "shelf_life": 21},

    # Pears
    {"id": "pear_asian", "name_vi": "Lê", "name_en": "Asian Pear", "shelf_life": 14},
    {"id": "pear_european", "name_vi": "Lê Tây", "name_en": "European Pear", "shelf_life": 14},
    {"id": "pear_korean", "name_vi": "Lê Hàn Quốc", "name_en": "Korean Pear", "shelf_life": 14},

    # Melons
    {"id": "watermelon_red", "name_vi": "Dưa hấu ruột đỏ", "name_en": "Red Watermelon", "shelf_life": 7},
    {"id": "watermelon_yellow", "name_vi": "Dưa hấu vàng", "name_en": "Yellow Watermelon", "shelf_life": 7},
    {"id": "cantaloupe", "name_vi": "Dưa vàng", "name_en": "Cantaloupe", "shelf_life": 7},
    {"id": "honeydew", "name_vi": "Dưa gang", "name_en": "Honeydew", "shelf_life": 10},
    {"id": "melon_pepino", "name_vi": "Dưa pepino", "name_en": "Pepino Melon", "shelf_life": 7},

    # Exotic fruits
    {"id": "mangosteen", "name_vi": "Măng cụt", "name_en": "Mangosteen", "shelf_life": 5},
    {"id": "passion_fruit_yellow", "name_vi": "Chanh dây vàng", "name_en": "Yellow Passion Fruit", "shelf_life": 7},
    {"id": "avocado_booth", "name_vi": "Bơ Booth", "name_en": "Booth Avocado", "shelf_life": 7},
    {"id": "avocado_hass", "name_vi": "Bơ Hass", "name_en": "Hass Avocado", "shelf_life": 7},
    {"id": "dragon_fruit_white", "name_vi": "Thanh long trắng", "name_en": "White Dragon Fruit", "shelf_life": 7},
    {"id": "dragon_fruit_red", "name_vi": "Thanh long ruột đỏ", "name_en": "Red Dragon Fruit", "shelf_life": 7},
    {"id": "pitaya", "name_vi": "Thanh long vàng", "name_en": "Yellow Pitaya", "shelf_life": 7},

    # Vietnamese specialty
    {"id": "milk_fruit", "name_vi": "Vú sữa", "name_en": "Milk Fruit", "shelf_life": 5},
    {"id": "sapoche", "name_vi": "Sa kê", "name_en": "Sapoche", "shelf_life": 5},
    {"id": "green_skin_grapefruit", "name_vi": "Bưởi da xanh Bến Tre", "name_en": "Ben Tre Pomelo", "shelf_life": 21},
    {"id": "wax_apple", "name_vi": "Roi", "name_en": "Wax Apple", "shelf_life": 5},
    {"id": "water_apple", "name_vi": "Mận nước", "name_en": "Water Apple", "shelf_life": 5},

    # Tropical
    {"id": "guava_white", "name_vi": "Ổi trắng", "name_en": "White Guava", "shelf_life": 5},
    {"id": "guava_pink", "name_vi": "Ổi hồng", "name_en": "Pink Guava", "shelf_life": 5},
    {"id": "papaya_red", "name_vi": "Đu đủ ruột đỏ", "name_en": "Red Papaya", "shelf_life": 5},
    {"id": "papaya_yellow", "name_vi": "Đu đủ vàng", "name_en": "Yellow Papaya", "shelf_life": 5},
    {"id": "jackfruit_mi", "name_vi": "Mít mì", "name_en": "Honey Jackfruit", "shelf_life": 5},
    {"id": "jackfruit_tuoi", "name_vi": "Mít tơ", "name_en": "Soft Jackfruit", "shelf_life": 5},

    # Stone fruits
    {"id": "peach", "name_vi": "Đào", "name_en": "Peach", "shelf_life": 7},
    {"id": "nectarine", "name_vi": "Xuân đào", "name_en": "Nectarine", "shelf_life": 7},
    {"id": "apricot", "name_vi": "Mơ", "name_en": "Apricot", "shelf_life": 5},
    {"id": "cherry", "name_vi": "Anh đào", "name_en": "Cherry", "shelf_life": 5},
    {"id": "cherry_rainier", "name_vi": "Anh đào vàng", "name_en": "Rainier Cherry", "shelf_life": 5},

    # Dates and figs
    {"id": "date", "name_vi": "Chà là", "name_en": "Date", "shelf_life": 30},
    {"id": "fig", "name_vi": "Sung", "name_en": "Fig", "shelf_life": 5},

    # More tropical
    {"id": "tamarind", "name_vi": "Me", "name_en": "Tamarind", "shelf_life": 14},
    {"id": "santol", "name_vi": "Sơn trà", "name_en": "Santol", "shelf_life": 7},
    {"id": "cempedak", "name_vi": "Chôm chôm tía", "name_en": "Cempedak", "shelf_life": 5},
]

# Complete Vietnamese meat cuts
COMPLETE_MEAT = [
    # PORK - Complete cuts
    {"id": "pork_ham", "name_vi": "Móng giò heo", "name_en": "Pork Ham", "shelf_life": 3},
    {"id": "pork_ear", "name_vi": "Tai heo", "name_en": "Pork Ear", "shelf_life": 2},
    {"id": "pork_snout", "name_vi": "Mõm heo", "name_en": "Pork Snout", "shelf_life": 2},
    {"id": "pork_tongue", "name_vi": "Lưỡi heo", "name_en": "Pork Tongue", "shelf_life": 2},
    {"id": "pork_heart", "name_vi": "Tim heo", "name_en": "Pork Heart", "shelf_life": 2},
    {"id": "pork_liver", "name_vi": "Gan heo", "name_en": "Pork Liver", "shelf_life": 1},
    {"id": "pork_kidney", "name_vi": "Thận heo", "name_en": "Pork Kidney", "shelf_life": 1},
    {"id": "pork_intestine", "name_vi": "Ruột heo", "name_en": "Pork Intestine", "shelf_life": 1},
    {"id": "pork_stomach", "name_vi": "Dạ dày heo", "name_en": "Pork Stomach", "shelf_life": 1},
    {"id": "pork_feet", "name_vi": "Chân giò heo", "name_en": "Pork Feet", "shelf_life": 2},
    {"id": "pork_tail", "name_vi": "Đuôi heo", "name_en": "Pork Tail", "shelf_life": 2},
    {"id": "pork_skin", "name_vi": "Da heo", "name_en": "Pork Skin", "shelf_life": 2},
    {"id": "pork_blood", "name_vi": "Huyết heo", "name_en": "Pork Blood", "shelf_life": 1},
    {"id": "pork_cartilage", "name_vi": "Sụn heo", "name_en": "Pork Cartilage", "shelf_life": 2},

    # BEEF - Complete cuts
    {"id": "beef_tongue", "name_vi": "Lưỡi bò", "name_en": "Beef Tongue", "shelf_life": 2},
    {"id": "beef_heart", "name_vi": "Tim bò", "name_en": "Beef Heart", "shelf_life": 2},
    {"id": "beef_liver", "name_vi": "Gan bò", "name_en": "Beef Liver", "shelf_life": 1},
    {"id": "beef_kidney", "name_vi": "Thận bò", "name_en": "Beef Kidney", "shelf_life": 1},
    {"id": "beef_tripe", "name_vi": "Dạ dày bò", "name_en": "Beef Tripe", "shelf_life": 2},
    {"id": "beef_tail", "name_vi": "Đuôi bò", "name_en": "Oxtail", "shelf_life": 3},
    {"id": "beef_tendon", "name_vi": "Gân bò", "name_en": "Beef Tendon", "shelf_life": 2},
    {"id": "beef_bone_marrow", "name_vi": "Tủy bò", "name_en": "Beef Bone Marrow", "shelf_life": 2},
    {"id": "beef_chuck", "name_vi": "Thịt bò vai", "name_en": "Beef Chuck", "shelf_life": 3},
    {"id": "beef_sirloin", "name_vi": "Thịt bò thăn ngoại", "name_en": "Beef Sirloin", "shelf_life": 3},
    {"id": "beef_ribeye", "name_vi": "Thịt bò sườn", "name_en": "Beef Ribeye", "shelf_life": 3},

    # CHICKEN - Complete cuts
    {"id": "chicken_heart", "name_vi": "Tim gà", "name_en": "Chicken Heart", "shelf_life": 1},
    {"id": "chicken_liver", "name_vi": "Gan gà", "name_en": "Chicken Liver", "shelf_life": 1},
    {"id": "chicken_gizzard", "name_vi": "Mề gà", "name_en": "Chicken Gizzard", "shelf_life": 2},
    {"id": "chicken_feet", "name_vi": "Chân gà", "name_en": "Chicken Feet", "shelf_life": 2},
    {"id": "chicken_neck", "name_vi": "Cổ gà", "name_en": "Chicken Neck", "shelf_life": 2},
    {"id": "chicken_back", "name_vi": "Xương gà", "name_en": "Chicken Back", "shelf_life": 2},
    {"id": "chicken_whole", "name_vi": "Gà nguyên con", "name_en": "Whole Chicken", "shelf_life": 2},
    {"id": "chicken_breast_boneless", "name_vi": "Ức gà không xương", "name_en": "Boneless Chicken Breast", "shelf_life": 2},
    {"id": "chicken_drumstick", "name_vi": "Đùi tỏi gà", "name_en": "Chicken Drumstick", "shelf_life": 2},

    # DUCK - Complete cuts
    {"id": "duck_breast", "name_vi": "Ngực vịt", "name_en": "Duck Breast", "shelf_life": 2},
    {"id": "duck_leg", "name_vi": "Đùi vịt", "name_en": "Duck Leg", "shelf_life": 2},
    {"id": "duck_liver", "name_vi": "Gan vịt", "name_en": "Duck Liver", "shelf_life": 1},
    {"id": "duck_gizzard", "name_vi": "Mề vịt", "name_en": "Duck Gizzard", "shelf_life": 2},
    {"id": "duck_tongue", "name_vi": "Lưỡi vịt", "name_en": "Duck Tongue", "shelf_life": 2},
    {"id": "duck_whole", "name_vi": "Vịt nguyên con", "name_en": "Whole Duck", "shelf_life": 2},

    # OTHER POULTRY
    {"id": "quail_whole", "name_vi": "Chim cút nguyên con", "name_en": "Whole Quail", "shelf_life": 2},
    {"id": "pigeon", "name_vi": "Bồ câu", "name_en": "Pigeon", "shelf_life": 2},
    {"id": "turkey", "name_vi": "Gà tây", "name_en": "Turkey", "shelf_life": 2},

    # OTHER MEAT
    {"id": "goat", "name_vi": "Thịt dê", "name_en": "Goat Meat", "shelf_life": 3},
    {"id": "rabbit", "name_vi": "Thịt thỏ", "name_en": "Rabbit Meat", "shelf_life": 2},
    {"id": "frog", "name_vi": "Thịt ếch", "name_en": "Frog Meat", "shelf_life": 1},
    {"id": "snail", "name_vi": "Ốc", "name_en": "Snail", "shelf_life": 1},

    # PROCESSED MEAT
    {"id": "pork_sausage", "name_vi": "Xúc xích heo", "name_en": "Pork Sausage", "shelf_life": 5},
    {"id": "chinese_sausage", "name_vi": "Lạp xưởng", "name_en": "Chinese Sausage", "shelf_life": 30},
    {"id": "pork_patty", "name_vi": "Chả heo", "name_en": "Pork Patty", "shelf_life": 3},
    {"id": "pork_meatball", "name_vi": "Thịt viên heo", "name_en": "Pork Meatball", "shelf_life": 3},
    {"id": "beef_meatball", "name_vi": "Thịt viên bò", "name_en": "Beef Meatball", "shelf_life": 3},
    {"id": "chicken_meatball", "name_vi": "Thịt viên gà", "name_en": "Chicken Meatball", "shelf_life": 3},
    {"id": "vietnamese_ham", "name_vi": "Giò lụa", "name_en": "Vietnamese Ham", "shelf_life": 5},
    {"id": "bacon", "name_vi": "Thịt xông khói", "name_en": "Bacon", "shelf_life": 7},
]

def generate_product(base_data, category):
    """Generate full product entry with nutrition data"""

    # Base nutrition templates by category
    if category == "fruits":
        nutrition = {
            "serving_size": "100g",
            "calories": 50,
            "protein": 0.5,
            "carbohydrates": 13,
            "fat": 0.2,
            "fiber": 2,
            "sugar": 10,
            "vitamins": {"vitamin_c": 15, "vitamin_a": 200},
            "minerals": {"potassium": 150, "calcium": 20}
        }
        health_benefits = ["Giàu vitamin", "Tốt cho sức khỏe", "Tăng cường miễn dịch"]
        health_warnings = ["Rửa sạch trước khi ăn", "Bảo quản tốt để tránh hỏng"]
    else:  # meat
        nutrition = {
            "serving_size": "100g",
            "calories": 200,
            "protein": 20,
            "carbohydrates": 0,
            "fat": 12,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {"vitamin_b12": 2, "vitamin_b6": 0.4},
            "minerals": {"iron": 2, "zinc": 3}
        }
        health_benefits = ["Giàu protein", "Cung cấp sắt", "Tốt cho cơ bắp"]
        health_warnings = ["Nấu chín kỹ", "Bảo quản lạnh ngay"]

    shelf_life = base_data["shelf_life"]
    storage_tip = f"Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng {shelf_life} ngày."

    return {
        "id": base_data["id"],
        "name_vi": base_data["name_vi"],
        "name_en": base_data["name_en"],
        "aliases": [base_data["name_vi"].lower(), base_data["name_en"].lower()],
        "category": category,
        "shelf_life_refrigerated": shelf_life,
        "shelf_life_frozen": 180,
        "nutrition_data": nutrition,
        "health_benefits": health_benefits,
        "health_warnings": health_warnings,
        "storage_tips": storage_tip
    }

def massive_expand(input_file, output_file):
    """Massive expansion"""

    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    current_products = data['products']
    print(f"📊 Current: {len(current_products)} products")

    # Generate all new products
    new_fruits = [generate_product(f, "fruits") for f in MASSIVE_FRUITS]
    new_meats = [generate_product(m, "meat") for m in COMPLETE_MEAT]

    print(f"\n➕ Generating:")
    print(f"  - Fruits: {len(new_fruits)}")
    print(f"  - Meats: {len(new_meats)}")

    # Check duplicates
    existing_ids = {p['id'] for p in current_products}
    existing_names = {p['name_vi'] for p in current_products}

    to_add = []
    for product in new_fruits + new_meats:
        if product['id'] not in existing_ids and product['name_vi'] not in existing_names:
            to_add.append(product)
        else:
            print(f"  ⚠️  Skipping: {product['name_vi']}")

    all_products = current_products + to_add

    # Stats by category
    by_category = {}
    for p in all_products:
        cat = p.get('category', 'other')
        by_category[cat] = by_category.get(cat, 0) + 1

    print(f"\n📊 New totals:")
    for cat in sorted(by_category.keys()):
        print(f"  - {cat}: {by_category[cat]}")
    print(f"\n🎯 Fruits total: {by_category.get('fruits', 0)}")

    output_data = {
        'version': '3.0.0',
        'last_updated': '2025-11-11',
        'total_products': len(all_products),
        'products': all_products
    }

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2)

    print(f"\n✅ Done: {len(current_products)} → {len(all_products)}")
    print(f"📈 Added: {len(to_add)} products")

if __name__ == '__main__':
    input_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'
    output_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'

    print("🚀 MASSIVE EXPANSION...")
    massive_expand(input_file, output_file)
