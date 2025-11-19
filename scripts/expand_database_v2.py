#!/usr/bin/env python3
"""
Script to expand database with MORE Vietnamese products
"""

import json
from pathlib import Path

# More vegetables
MORE_VEGETABLES = [
    {
        "id": "chayote",
        "name_vi": "Su su",
        "name_en": "Chayote",
        "aliases": ["su su", "chayote"],
        "category": "vegetables",
        "shelf_life_refrigerated": 14,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 19,
            "protein": 0.8,
            "carbohydrates": 4.5,
            "fat": 0.1,
            "fiber": 1.7,
            "sugar": 1.7,
            "vitamins": {"vitamin_c": 7.7, "folate": 93},
            "minerals": {"potassium": 125, "zinc": 0.7}
        },
        "health_benefits": ["Giàu chất xơ", "Ít calories", "Tốt cho tiêu hóa"],
        "health_warnings": ["Rửa sạch trước khi dùng"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 14 ngày."
    },
    {
        "id": "loofah",
        "name_vi": "Mướp",
        "name_en": "Loofah",
        "aliases": ["muop", "loofah", "luffa"],
        "category": "vegetables",
        "shelf_life_refrigerated": 5,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 20,
            "protein": 1.2,
            "carbohydrates": 4.4,
            "fat": 0.2,
            "fiber": 1.1,
            "sugar": 2,
            "vitamins": {"vitamin_c": 12, "vitamin_a": 390},
            "minerals": {"potassium": 139, "magnesium": 11}
        },
        "health_benefits": ["Giàu nước", "Ít calories", "Tốt cho da"],
        "health_warnings": ["Rửa sạch trước khi nấu"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 5 ngày."
    },
    {
        "id": "okra",
        "name_vi": "Đậu bắp",
        "name_en": "Okra",
        "aliases": ["dau bap", "okra"],
        "category": "vegetables",
        "shelf_life_refrigerated": 5,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 33,
            "protein": 1.9,
            "carbohydrates": 7.5,
            "fat": 0.2,
            "fiber": 3.2,
            "sugar": 1.5,
            "vitamins": {"vitamin_c": 23, "vitamin_k": 31.3},
            "minerals": {"calcium": 82, "magnesium": 57}
        },
        "health_benefits": ["Giàu chất xơ", "Tốt cho tim mạch", "Kiểm soát đường huyết"],
        "health_warnings": ["Người sỏi thận nên hạn chế"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 5 ngày."
    },
    {
        "id": "green_beans",
        "name_vi": "Đậu cô ve",
        "name_en": "Green Beans",
        "aliases": ["dau co ve", "green beans"],
        "category": "vegetables",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 31,
            "protein": 1.8,
            "carbohydrates": 7,
            "fat": 0.2,
            "fiber": 2.7,
            "sugar": 3.3,
            "vitamins": {"vitamin_c": 12.2, "vitamin_k": 43},
            "minerals": {"calcium": 37, "iron": 1}
        },
        "health_benefits": ["Giàu chất xơ", "Chứa vitamin K", "Ít calories"],
        "health_warnings": ["Rửa sạch trước khi nấu"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày."
    },
    {
        "id": "yard_long_bean",
        "name_vi": "Đậu đũa",
        "name_en": "Yard Long Bean",
        "aliases": ["dau dua", "long bean"],
        "category": "vegetables",
        "shelf_life_refrigerated": 5,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 47,
            "protein": 2.8,
            "carbohydrates": 8,
            "fat": 0.4,
            "fiber": 3.6,
            "sugar": 0,
            "vitamins": {"vitamin_c": 18.8, "vitamin_a": 865},
            "minerals": {"calcium": 50, "iron": 0.5}
        },
        "health_benefits": ["Giàu protein thực vật", "Chứa chất xơ", "Tốt cho tiêu hóa"],
        "health_warnings": ["Nên nấu chín"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 5 ngày."
    },
    {
        "id": "kohlrabi",
        "name_vi": "Su hào",
        "name_en": "Kohlrabi",
        "aliases": ["su hao", "kohlrabi"],
        "category": "vegetables",
        "shelf_life_refrigerated": 14,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 27,
            "protein": 1.7,
            "carbohydrates": 6.2,
            "fat": 0.1,
            "fiber": 3.6,
            "sugar": 2.6,
            "vitamins": {"vitamin_c": 62, "vitamin_b6": 0.15},
            "minerals": {"potassium": 350, "copper": 0.13}
        },
        "health_benefits": ["Rất giàu vitamin C", "Chứa chất xơ", "Tốt cho miễn dịch"],
        "health_warnings": ["Rửa sạch vỏ"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 14 ngày."
    },
    {
        "id": "radish",
        "name_vi": "Củ cải trắng",
        "name_en": "Radish",
        "aliases": ["cu cai trang", "daikon", "radish"],
        "category": "vegetables",
        "shelf_life_refrigerated": 14,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 18,
            "protein": 0.6,
            "carbohydrates": 4.1,
            "fat": 0.1,
            "fiber": 1.6,
            "sugar": 2.5,
            "vitamins": {"vitamin_c": 22, "folate": 28},
            "minerals": {"potassium": 227, "calcium": 27}
        },
        "health_benefits": ["Giàu vitamin C", "Tốt cho tiêu hóa", "Ít calories"],
        "health_warnings": ["Rửa sạch vỏ"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 14 ngày."
    },
    {
        "id": "taro",
        "name_vi": "Khoai môn",
        "name_en": "Taro",
        "aliases": ["khoai mon", "taro"],
        "category": "vegetables",
        "shelf_life_refrigerated": 21,
        "shelf_life_frozen": 365,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 112,
            "protein": 1.5,
            "carbohydrates": 26.5,
            "fat": 0.2,
            "fiber": 4.1,
            "sugar": 0.4,
            "vitamins": {"vitamin_e": 2.4, "vitamin_b6": 0.28},
            "minerals": {"potassium": 591, "magnesium": 33}
        },
        "health_benefits": ["Giàu chất xơ", "Cung cấp năng lượng", "Chứa kali cao"],
        "health_warnings": ["Phải nấu chín mới ăn", "Người tiểu đường nên hạn chế"],
        "storage_tips": "Bảo quản ở nơi khô ráo, thoáng mát. Có thể bảo quản 21 ngày."
    },
    {
        "id": "sweet_potato",
        "name_vi": "Khoai lang",
        "name_en": "Sweet Potato",
        "aliases": ["khoai lang", "sweet potato"],
        "category": "vegetables",
        "shelf_life_refrigerated": 30,
        "shelf_life_frozen": 365,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 86,
            "protein": 1.6,
            "carbohydrates": 20.1,
            "fat": 0.1,
            "fiber": 3,
            "sugar": 4.2,
            "vitamins": {"vitamin_a": 14187, "vitamin_c": 2.4},
            "minerals": {"potassium": 337, "manganese": 0.3}
        },
        "health_benefits": ["Rất giàu vitamin A", "Chứa chất chống oxi hóa", "Tốt cho mắt"],
        "health_warnings": ["Người tiểu đường nên ăn vừa phải"],
        "storage_tips": "Bảo quản ở nơi khô ráo, thoáng mát. Không nên bảo quản trong tủ lạnh. Có thể bảo quản 30 ngày."
    },
    {
        "id": "jicama",
        "name_vi": "Củ đậu",
        "name_en": "Jicama",
        "aliases": ["cu dau", "jicama"],
        "category": "vegetables",
        "shelf_life_refrigerated": 21,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 38,
            "protein": 0.7,
            "carbohydrates": 8.8,
            "fat": 0.1,
            "fiber": 4.9,
            "sugar": 1.8,
            "vitamins": {"vitamin_c": 20.2, "folate": 12},
            "minerals": {"potassium": 150, "magnesium": 12}
        },
        "health_benefits": ["Giàu chất xơ", "Ít calories", "Tốt cho tiêu hóa"],
        "health_warnings": ["Bỏ vỏ trước khi ăn"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 21 ngày."
    }
]

# More fruits
MORE_FRUITS = [
    {
        "id": "coconut",
        "name_vi": "Dừa",
        "name_en": "Coconut",
        "aliases": ["dua", "coconut"],
        "category": "fruits",
        "shelf_life_refrigerated": 30,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 354,
            "protein": 3.3,
            "carbohydrates": 15.2,
            "fat": 33.5,
            "fiber": 9,
            "sugar": 6.2,
            "vitamins": {"vitamin_c": 3.3},
            "minerals": {"potassium": 356, "manganese": 1.5}
        },
        "health_benefits": ["Giàu mangan", "Cung cấp năng lượng cao", "Tốt cho tim mạch"],
        "health_warnings": ["Calo cao, nên ăn vừa phải"],
        "storage_tips": "Bảo quản nguyên quả ở nhiệt độ phòng tối đa 30 ngày. Sau khi bổ, bảo quản trong tủ lạnh và dùng trong 3 ngày."
    },
    {
        "id": "soursop",
        "name_vi": "Mãng cầu xiêm",
        "name_en": "Soursop",
        "aliases": ["mang cau xiem", "soursop"],
        "category": "fruits",
        "shelf_life_refrigerated": 5,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 66,
            "protein": 1,
            "carbohydrates": 16.8,
            "fat": 0.3,
            "fiber": 3.3,
            "sugar": 13.5,
            "vitamins": {"vitamin_c": 20.6, "vitamin_b6": 0.06},
            "minerals": {"potassium": 278, "magnesium": 21}
        },
        "health_benefits": ["Giàu vitamin C", "Chứa chất chống oxi hóa", "Tốt cho miễn dịch"],
        "health_warnings": ["Hạt độc, không ăn", "Ăn khi chín mềm"],
        "storage_tips": "Bảo quản ở nhiệt độ phòng cho đến khi chín. Sau khi chín, dùng ngay hoặc bảo quản trong tủ lạnh 5 ngày."
    },
    {
        "id": "langsat",
        "name_vi": "Bòn bon",
        "name_en": "Langsat",
        "aliases": ["bon bon", "langsat"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 57,
            "protein": 1,
            "carbohydrates": 14,
            "fat": 0.2,
            "fiber": 2.3,
            "sugar": 9.5,
            "vitamins": {"vitamin_c": 9, "vitamin_b2": 0.12},
            "minerals": {"calcium": 19, "phosphorus": 30}
        },
        "health_benefits": ["Giàu chất xơ", "Cung cấp vitamin C", "Tốt cho tiêu hóa"],
        "health_warnings": ["Rửa sạch trước khi ăn"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày."
    },
    {
        "id": "rose_apple",
        "name_vi": "Mận",
        "name_en": "Rose Apple",
        "aliases": ["man", "rose apple"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 25,
            "protein": 0.6,
            "carbohydrates": 5.7,
            "fat": 0.3,
            "fiber": 0.9,
            "sugar": 5,
            "vitamins": {"vitamin_c": 22.3, "vitamin_a": 17},
            "minerals": {"calcium": 29, "potassium": 123}
        },
        "health_benefits": ["Giàu nước", "Ít calories", "Tốt cho da"],
        "health_warnings": ["Rửa sạch trước khi ăn"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày."
    },
    {
        "id": "sapodilla",
        "name_vi": "Hồng xiêm",
        "name_en": "Sapodilla",
        "aliases": ["hong xiem", "sapodilla"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 83,
            "protein": 0.4,
            "carbohydrates": 19.9,
            "fat": 1.1,
            "fiber": 5.3,
            "sugar": 0,
            "vitamins": {"vitamin_c": 14.7, "vitamin_a": 60},
            "minerals": {"potassium": 193, "iron": 0.8}
        },
        "health_benefits": ["Giàu chất xơ", "Cung cấp năng lượng", "Tốt cho tiêu hóa"],
        "health_warnings": ["Ăn khi chín mềm"],
        "storage_tips": "Bảo quản ở nhiệt độ phòng cho đến khi chín mềm. Sau đó bảo quản trong tủ lạnh 7 ngày."
    },
    {
        "id": "pomegranate",
        "name_vi": "Lựu",
        "name_en": "Pomegranate",
        "aliases": ["luu", "pomegranate"],
        "category": "fruits",
        "shelf_life_refrigerated": 21,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 83,
            "protein": 1.7,
            "carbohydrates": 18.7,
            "fat": 1.2,
            "fiber": 4,
            "sugar": 13.7,
            "vitamins": {"vitamin_c": 10.2, "vitamin_k": 16.4},
            "minerals": {"potassium": 236, "phosphorus": 36}
        },
        "health_benefits": ["Giàu chất chống oxi hóa", "Tốt cho tim mạch", "Chống viêm"],
        "health_warnings": ["Người tiểu đường nên hạn chế"],
        "storage_tips": "Bảo quản ở nhiệt độ phòng hoặc tủ lạnh. Đề xuất sử dụng trong vòng 21 ngày."
    },
    {
        "id": "plum",
        "name_vi": "Mận tím",
        "name_en": "Plum",
        "aliases": ["man tim", "plum"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 46,
            "protein": 0.7,
            "carbohydrates": 11.4,
            "fat": 0.3,
            "fiber": 1.4,
            "sugar": 9.9,
            "vitamins": {"vitamin_c": 9.5, "vitamin_a": 345},
            "minerals": {"potassium": 157, "copper": 0.06}
        },
        "health_benefits": ["Giàu chất chống oxi hóa", "Tốt cho tiêu hóa", "Ít calories"],
        "health_warnings": ["Hạt không ăn được"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày."
    },
    {
        "id": "kiwi",
        "name_vi": "Kiwi",
        "name_en": "Kiwi",
        "aliases": ["kiwi"],
        "category": "fruits",
        "shelf_life_refrigerated": 14,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 61,
            "protein": 1.1,
            "carbohydrates": 14.7,
            "fat": 0.5,
            "fiber": 3,
            "sugar": 9,
            "vitamins": {"vitamin_c": 92.7, "vitamin_k": 40.3},
            "minerals": {"potassium": 312, "copper": 0.13}
        },
        "health_benefits": ["Rất giàu vitamin C", "Tốt cho tiêu hóa", "Chứa chất xơ"],
        "health_warnings": ["Người dị ứng kiwi nên tránh"],
        "storage_tips": "Bảo quản ở nhiệt độ phòng cho đến khi chín. Sau đó bảo quản trong tủ lạnh 14 ngày."
    }
]

# More meat
MORE_MEAT = [
    {
        "id": "pork_loin",
        "name_vi": "Thịt lưng heo",
        "name_en": "Pork Loin",
        "aliases": ["thit lung heo", "pork loin"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 143,
            "protein": 21.5,
            "carbohydrates": 0,
            "fat": 5.6,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {"vitamin_b12": 0.6, "thiamin": 0.8},
            "minerals": {"selenium": 45, "phosphorus": 222}
        },
        "health_benefits": ["Giàu protein", "Ít mỡ", "Chứa selenium"],
        "health_warnings": ["Nấu chín kỹ"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày."
    },
    {
        "id": "beef_brisket",
        "name_vi": "Thịt bò nạm",
        "name_en": "Beef Brisket",
        "aliases": ["thit bo nam", "beef brisket"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 270,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 215,
            "protein": 25,
            "carbohydrates": 0,
            "fat": 12,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {"vitamin_b12": 2.2, "niacin": 6.4},
            "minerals": {"iron": 2.4, "zinc": 5.8}
        },
        "health_benefits": ["Giàu protein", "Nhiều sắt", "Chứa vitamin B12"],
        "health_warnings": ["Nấu chín kỹ", "Hàm lượng mỡ vừa phải"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày."
    },
    {
        "id": "lamb",
        "name_vi": "Thịt cừu",
        "name_en": "Lamb",
        "aliases": ["thit cuu", "lamb", "mutton"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 270,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 294,
            "protein": 25,
            "carbohydrates": 0,
            "fat": 21,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {"vitamin_b12": 2.6, "niacin": 6.7},
            "minerals": {"iron": 1.9, "zinc": 4.5}
        },
        "health_benefits": ["Giàu protein", "Chứa vitamin B12", "Nhiều sắt và kẽm"],
        "health_warnings": ["Hàm lượng mỡ cao", "Nấu chín kỹ"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày."
    },
    {
        "id": "quail",
        "name_vi": "Thịt chim cút",
        "name_en": "Quail",
        "aliases": ["thit chim cut", "quail"],
        "category": "meat",
        "shelf_life_refrigerated": 2,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 134,
            "protein": 21.8,
            "carbohydrates": 0,
            "fat": 4.5,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {"vitamin_b6": 0.5, "niacin": 7.2},
            "minerals": {"iron": 4, "selenium": 21}
        },
        "health_benefits": ["Rất giàu protein", "Nhiều sắt", "Ít mỡ"],
        "health_warnings": ["Nấu chín kỹ"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 2 ngày."
    },
    {
        "id": "goose",
        "name_vi": "Thịt ngỗng",
        "name_en": "Goose",
        "aliases": ["thit ngang", "goose"],
        "category": "meat",
        "shelf_life_refrigerated": 2,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 161,
            "protein": 22.8,
            "carbohydrates": 0,
            "fat": 7.1,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {"vitamin_b6": 0.4, "niacin": 4.1},
            "minerals": {"iron": 2.8, "selenium": 21}
        },
        "health_benefits": ["Giàu protein", "Chứa sắt", "Cung cấp vitamin B"],
        "health_warnings": ["Nấu chín kỹ", "Bỏ da để giảm mỡ"],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 2 ngày."
    }
]

def expand_database_v2(input_file, output_file):
    """Expand database with more products"""

    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    current_products = data['products']
    print(f"📊 Current products: {len(current_products)}")

    # Add new products
    new_products = MORE_VEGETABLES + MORE_FRUITS + MORE_MEAT

    print(f"\n➕ Adding {len(new_products)} new products:")
    print(f"  - Vegetables: {len(MORE_VEGETABLES)}")
    print(f"  - Fruits: {len(MORE_FRUITS)}")
    print(f"  - Meat: {len(MORE_MEAT)}")

    # Check for duplicates
    existing_ids = {p['id'] for p in current_products}
    existing_names = {p['name_vi'] for p in current_products}

    products_to_add = []
    for product in new_products:
        if product['id'] in existing_ids:
            print(f"  ⚠️  Skipping duplicate ID: {product['id']}")
            continue
        if product['name_vi'] in existing_names:
            print(f"  ⚠️  Skipping duplicate name: {product['name_vi']}")
            continue
        products_to_add.append(product)

    all_products = current_products + products_to_add

    # Create output
    output_data = {
        'version': '2.3.0',
        'last_updated': '2025-11-11',
        'total_products': len(all_products),
        'products': all_products
    }

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2)

    print(f"\n✅ Expanded database saved")
    print(f"📊 Total: {len(current_products)} → {len(all_products)}")
    print(f"📈 Added: {len(products_to_add)} new products")

if __name__ == '__main__':
    input_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'
    output_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'

    print("🚀 Expanding database (Round 2)...")
    expand_database_v2(input_file, output_file)
