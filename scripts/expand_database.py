#!/usr/bin/env python3
"""
Script to expand database with more Vietnamese products
Focus on vegetables, fruits, and meat
"""

import json
from pathlib import Path

# Additional vegetables (rau củ quả)
ADDITIONAL_VEGETABLES = [
    {
        "id": "cucumber",
        "name_vi": "Dưa chuột",
        "name_en": "Cucumber",
        "aliases": ["dua chuot", "cucumber"],
        "category": "vegetables",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 15,
            "protein": 0.7,
            "carbohydrates": 3.6,
            "fat": 0.1,
            "fiber": 0.5,
            "sugar": 1.7,
            "vitamins": {
                "vitamin_c": 2.8,
                "vitamin_k": 16.4
            },
            "minerals": {
                "potassium": 147,
                "magnesium": 13
            }
        },
        "health_benefits": [
            "Giàu nước, giúp cung cấp độ ẩm cho cơ thể",
            "Chứa chất chống oxi hóa tốt cho da",
            "Ít calories, phù hợp ăn kiêng"
        ],
        "health_warnings": [
            "Rửa sạch vỏ trước khi ăn",
            "Người có vấn đề về thận nên hạn chế"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày để giữ được độ giòn và tươi ngon. Thời gian bảo quản có thể thay đổi tùy thuộc vào độ chín."
    },
    {
        "id": "eggplant",
        "name_vi": "Cà tím",
        "name_en": "Eggplant",
        "aliases": ["ca tim", "eggplant"],
        "category": "vegetables",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 25,
            "protein": 1,
            "carbohydrates": 6,
            "fat": 0.2,
            "fiber": 3,
            "sugar": 3.5,
            "vitamins": {
                "vitamin_c": 2.2,
                "vitamin_k": 3.5
            },
            "minerals": {
                "potassium": 229,
                "manganese": 0.2
            }
        },
        "health_benefits": [
            "Giàu chất xơ, tốt cho tiêu hóa",
            "Chứa anthocyanin tốt cho tim mạch",
            "Ít calories, giàu chất chống oxi hóa"
        ],
        "health_warnings": [
            "Người bị sỏi thận nên hạn chế",
            "Rửa sạch trước khi chế biến"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày để giữ được độ tươi. Thời gian bảo quản có thể thay đổi tùy điều kiện."
    },
    {
        "id": "pumpkin",
        "name_vi": "Bí đỏ",
        "name_en": "Pumpkin",
        "aliases": ["bi do", "pumpkin"],
        "category": "vegetables",
        "shelf_life_refrigerated": 30,
        "shelf_life_frozen": 365,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 26,
            "protein": 1,
            "carbohydrates": 6.5,
            "fat": 0.1,
            "fiber": 0.5,
            "sugar": 2.8,
            "vitamins": {
                "vitamin_a": 8513,
                "vitamin_c": 9
            },
            "minerals": {
                "potassium": 340,
                "calcium": 21
            }
        },
        "health_benefits": [
            "Rất giàu vitamin A, tốt cho mắt",
            "Chứa chất chống oxi hóa mạnh",
            "Tốt cho sức khỏe tim mạch"
        ],
        "health_warnings": [
            "Rửa sạch vỏ trước khi chế biến",
            "Người tiểu đường nên ăn vừa phải"
        ],
        "storage_tips": "Bảo quản nguyên quả ở nơi khô ráo tối đa 30 ngày. Sau khi cắt, bảo quản trong tủ lạnh và sử dụng trong 5 ngày."
    },
    {
        "id": "bitter_melon",
        "name_vi": "Khổ qua",
        "name_en": "Bitter Melon",
        "aliases": ["kho qua", "bitter gourd", "bitter melon"],
        "category": "vegetables",
        "shelf_life_refrigerated": 5,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 17,
            "protein": 1,
            "carbohydrates": 3.7,
            "fat": 0.2,
            "fiber": 2.8,
            "sugar": 1.9,
            "vitamins": {
                "vitamin_c": 84,
                "vitamin_a": 471
            },
            "minerals": {
                "potassium": 296,
                "iron": 0.4
            }
        },
        "health_benefits": [
            "Giúp kiểm soát đường huyết",
            "Giàu vitamin C, tăng cường miễn dịch",
            "Tốt cho người tiểu đường"
        ],
        "health_warnings": [
            "Phụ nữ mang thai nên tránh",
            "Không nên ăn quá nhiều"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 5 ngày. Khổ qua dễ hỏng, nên dùng sớm."
    },
    {
        "id": "water_spinach",
        "name_vi": "Rau muống",
        "name_en": "Water Spinach",
        "aliases": ["rau muong", "water spinach", "morning glory"],
        "category": "vegetables",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 19,
            "protein": 2.6,
            "carbohydrates": 3.1,
            "fat": 0.2,
            "fiber": 2.1,
            "sugar": 0.5,
            "vitamins": {
                "vitamin_a": 6300,
                "vitamin_c": 55
            },
            "minerals": {
                "calcium": 77,
                "iron": 2.3
            }
        },
        "health_benefits": [
            "Giàu chất xơ, tốt cho tiêu hóa",
            "Nhiều vitamin A, tốt cho mắt",
            "Giàu sắt, phòng ngừa thiếu máu"
        ],
        "health_warnings": [
            "Rửa sạch nhiều lần trước khi nấu",
            "Nên luộc chín kỹ"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 3 ngày. Rau lá dễ héo, nên dùng ngay."
    },
    {
        "id": "chinese_cabbage",
        "name_vi": "Cải thảo",
        "name_en": "Chinese Cabbage",
        "aliases": ["cai thao", "napa cabbage"],
        "category": "vegetables",
        "shelf_life_refrigerated": 10,
        "shelf_life_frozen": 240,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 16,
            "protein": 1.2,
            "carbohydrates": 3.2,
            "fat": 0.2,
            "fiber": 1.2,
            "sugar": 1.4,
            "vitamins": {
                "vitamin_c": 27,
                "vitamin_k": 42.9
            },
            "minerals": {
                "calcium": 77,
                "potassium": 238
            }
        },
        "health_benefits": [
            "Giàu vitamin C và K",
            "Chứa chất chống oxi hóa",
            "Tốt cho xương và hệ tiêu hóa"
        ],
        "health_warnings": [
            "Rửa sạch từng lá trước khi dùng",
            "Người có vấn đề tuyến giáp nên hạn chế"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 10 ngày để giữ độ giòn."
    },
    {
        "id": "winter_melon",
        "name_vi": "Bí đao",
        "name_en": "Winter Melon",
        "aliases": ["bi dao", "winter gourd", "wax gourd"],
        "category": "vegetables",
        "shelf_life_refrigerated": 60,
        "shelf_life_frozen": 365,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 13,
            "protein": 0.4,
            "carbohydrates": 3,
            "fat": 0.2,
            "fiber": 2.9,
            "sugar": 2,
            "vitamins": {
                "vitamin_c": 13,
                "vitamin_b6": 0.04
            },
            "minerals": {
                "potassium": 111,
                "calcium": 19
            }
        },
        "health_benefits": [
            "Giàu nước, giúp giải nhiệt",
            "Ít calories, tốt cho giảm cân",
            "Lợi tiểu, giải độc"
        ],
        "health_warnings": [
            "Rửa sạch vỏ trước khi chế biến",
            "Người huyết áp thấp nên hạn chế"
        ],
        "storage_tips": "Bảo quản nguyên quả ở nơi khô ráo tối đa 60 ngày. Sau khi cắt, bảo quản trong tủ lạnh và dùng trong 7 ngày."
    },
    {
        "id": "sweet_potato_leaves",
        "name_vi": "Rau khoai lang",
        "name_en": "Sweet Potato Leaves",
        "aliases": ["rau khoai", "sweet potato greens"],
        "category": "vegetables",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 42,
            "protein": 4.5,
            "carbohydrates": 7.2,
            "fat": 0.6,
            "fiber": 3.5,
            "sugar": 0.4,
            "vitamins": {
                "vitamin_a": 5440,
                "vitamin_c": 11
            },
            "minerals": {
                "calcium": 93,
                "iron": 3.9
            }
        },
        "health_benefits": [
            "Giàu vitamin A, tốt cho mắt",
            "Nhiều protein so với rau lá khác",
            "Giàu sắt, phòng ngừa thiếu máu"
        ],
        "health_warnings": [
            "Rửa sạch nhiều lần",
            "Nên luộc chín kỹ"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 3 ngày. Rau lá dễ héo."
    }
]

# Additional fruits (trái cây)
ADDITIONAL_FRUITS = [
    {
        "id": "dragon_fruit",
        "name_vi": "Thanh long",
        "name_en": "Dragon Fruit",
        "aliases": ["thanh long", "dragon fruit", "pitaya"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 60,
            "protein": 1.2,
            "carbohydrates": 13,
            "fat": 0.4,
            "fiber": 3,
            "sugar": 8,
            "vitamins": {
                "vitamin_c": 20.5,
                "vitamin_b6": 0.04
            },
            "minerals": {
                "calcium": 8,
                "iron": 1.9
            }
        },
        "health_benefits": [
            "Giàu chất chống oxi hóa",
            "Chứa probiotic tốt cho tiêu hóa",
            "Giàu vitamin C, tăng cường miễn dịch"
        ],
        "health_warnings": [
            "Rửa sạch vỏ trước khi cắt",
            "Ăn vừa phải, tránh tiêu chảy"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày để giữ độ tươi ngon."
    },
    {
        "id": "longan",
        "name_vi": "Nhãn",
        "name_en": "Longan",
        "aliases": ["nhan", "longan"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 60,
            "protein": 1.3,
            "carbohydrates": 15.1,
            "fat": 0.1,
            "fiber": 1.1,
            "sugar": 14,
            "vitamins": {
                "vitamin_c": 84,
                "vitamin_b6": 0.02
            },
            "minerals": {
                "potassium": 266,
                "copper": 0.2
            }
        },
        "health_benefits": [
            "Giàu vitamin C",
            "Tốt cho thần kinh, giảm stress",
            "Cung cấp năng lượng nhanh"
        ],
        "health_warnings": [
            "Người tiểu đường nên hạn chế",
            "Không ăn quá nhiều gây nóng trong"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày. Nhãn dễ lên men sau khi bóc vỏ."
    },
    {
        "id": "rambutan",
        "name_vi": "Chôm chôm",
        "name_en": "Rambutan",
        "aliases": ["chom chom", "rambutan"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 82,
            "protein": 0.7,
            "carbohydrates": 20.9,
            "fat": 0.2,
            "fiber": 0.9,
            "sugar": 16,
            "vitamins": {
                "vitamin_c": 4.9,
                "vitamin_b6": 0.02
            },
            "minerals": {
                "iron": 0.35,
                "calcium": 22
            }
        },
        "health_benefits": [
            "Chứa sắt, phòng ngừa thiếu máu",
            "Giàu chất xơ, tốt cho tiêu hóa",
            "Cung cấp năng lượng"
        ],
        "health_warnings": [
            "Rửa sạch vỏ trước khi bóc",
            "Người tiểu đường nên hạn chế"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày. Chôm chôm dễ hỏng sau khi hái."
    },
    {
        "id": "custard_apple",
        "name_vi": "Mãng cầu",
        "name_en": "Custard Apple",
        "aliases": ["mang cau", "sugar apple", "custard apple"],
        "category": "fruits",
        "shelf_life_refrigerated": 5,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 94,
            "protein": 2.1,
            "carbohydrates": 23.6,
            "fat": 0.3,
            "fiber": 4.4,
            "sugar": 19,
            "vitamins": {
                "vitamin_c": 36.3,
                "vitamin_b6": 0.2
            },
            "minerals": {
                "potassium": 382,
                "magnesium": 18
            }
        },
        "health_benefits": [
            "Giàu chất xơ, tốt cho tiêu hóa",
            "Chứa nhiều vitamin C",
            "Tốt cho tim mạch"
        ],
        "health_warnings": [
            "Hạt độc, không được ăn",
            "Người tiểu đường nên hạn chế"
        ],
        "storage_tips": "Bảo quản ở nhiệt độ phòng cho đến khi chín. Sau khi chín, bảo quản trong tủ lạnh và dùng trong 5 ngày."
    },
    {
        "id": "star_fruit",
        "name_vi": "Khế",
        "name_en": "Star Fruit",
        "aliases": ["khe", "star fruit", "carambola"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 31,
            "protein": 1,
            "carbohydrates": 6.7,
            "fat": 0.3,
            "fiber": 2.8,
            "sugar": 4,
            "vitamins": {
                "vitamin_c": 34.4,
                "vitamin_b6": 0.02
            },
            "minerals": {
                "potassium": 133,
                "copper": 0.1
            }
        },
        "health_benefits": [
            "Giàu vitamin C",
            "Ít calories, tốt cho giảm cân",
            "Chứa chất chống oxi hóa"
        ],
        "health_warnings": [
            "Người bệnh thận không nên ăn",
            "Chứa oxalate cao"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày để giữ độ giòn."
    },
    {
        "id": "persimmon",
        "name_vi": "Hồng",
        "name_en": "Persimmon",
        "aliases": ["hong", "persimmon"],
        "category": "fruits",
        "shelf_life_refrigerated": 14,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 70,
            "protein": 0.6,
            "carbohydrates": 18.6,
            "fat": 0.2,
            "fiber": 3.6,
            "sugar": 12.5,
            "vitamins": {
                "vitamin_a": 1627,
                "vitamin_c": 7.5
            },
            "minerals": {
                "potassium": 161,
                "manganese": 0.4
            }
        },
        "health_benefits": [
            "Giàu vitamin A, tốt cho mắt",
            "Chứa chất chống oxi hóa cao",
            "Tốt cho tim mạch"
        ],
        "health_warnings": [
            "Không ăn lúc đói",
            "Người tiểu đường nên hạn chế"
        ],
        "storage_tips": "Bảo quản ở nhiệt độ phòng cho đến khi chín mềm. Sau đó bảo quản trong tủ lạnh và dùng trong 14 ngày."
    },
    {
        "id": "lychee",
        "name_vi": "Vải",
        "name_en": "Lychee",
        "aliases": ["vai", "litchi", "lychee"],
        "category": "fruits",
        "shelf_life_refrigerated": 7,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 66,
            "protein": 0.8,
            "carbohydrates": 16.5,
            "fat": 0.4,
            "fiber": 1.3,
            "sugar": 15.2,
            "vitamins": {
                "vitamin_c": 71.5,
                "vitamin_b6": 0.1
            },
            "minerals": {
                "potassium": 171,
                "copper": 0.1
            }
        },
        "health_benefits": [
            "Rất giàu vitamin C",
            "Chứa chất chống oxi hóa",
            "Tốt cho da và hệ miễn dịch"
        ],
        "health_warnings": [
            "Không ăn lúc đói",
            "Trẻ em không nên ăn nhiều"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. Đề xuất sử dụng trong vòng 7 ngày. Vải dễ lên men sau khi hái."
    },
    {
        "id": "pomelo",
        "name_vi": "Bưởi năm roi",
        "name_en": "Pomelo",
        "aliases": ["buoi", "pomelo"],
        "category": "fruits",
        "shelf_life_refrigerated": 21,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 38,
            "protein": 0.8,
            "carbohydrates": 9.6,
            "fat": 0,
            "fiber": 1,
            "sugar": 8.5,
            "vitamins": {
                "vitamin_c": 61,
                "vitamin_b6": 0.04
            },
            "minerals": {
                "potassium": 216,
                "calcium": 4
            }
        },
        "health_benefits": [
            "Giàu vitamin C",
            "Chứa lycopene tốt cho tim mạch",
            "Ít calories, tốt cho giảm cân"
        ],
        "health_warnings": [
            "Có thể tương tác với một số thuốc",
            "Người dùng thuốc hạ huyết áp nên hỏi bác sĩ"
        ],
        "storage_tips": "Bảo quản ở nhiệt độ phòng hoặc tủ lạnh. Đề xuất sử dụng trong vòng 21 ngày. Bưởi bảo quản lâu hơn nhiều trái cây khác."
    }
]

# Additional meat products (thịt)
ADDITIONAL_MEAT = [
    {
        "id": "pork_belly",
        "name_vi": "Thịt ba chỉ",
        "name_en": "Pork Belly",
        "aliases": ["thit ba chi", "pork belly"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 518,
            "protein": 9.3,
            "carbohydrates": 0,
            "fat": 53,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b12": 0.7,
                "vitamin_b6": 0.2
            },
            "minerals": {
                "iron": 1.1,
                "zinc": 2.4
            }
        },
        "health_benefits": [
            "Giàu protein và năng lượng",
            "Chứa vitamin B12",
            "Cung cấp kẽm và sắt"
        ],
        "health_warnings": [
            "Hàm lượng mỡ cao",
            "Nên ăn vừa phải",
            "Nấu chín kỹ trước khi ăn"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày. Thịt tươi nên dùng càng sớm càng tốt."
    },
    {
        "id": "pork_shoulder",
        "name_vi": "Thịt nạc vai",
        "name_en": "Pork Shoulder",
        "aliases": ["thit vai", "pork shoulder"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 180,
            "protein": 20,
            "carbohydrates": 0,
            "fat": 11,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b12": 0.5,
                "vitamin_b6": 0.5
            },
            "minerals": {
                "iron": 1.3,
                "zinc": 3.5
            }
        },
        "health_benefits": [
            "Giàu protein chất lượng cao",
            "Chứa vitamin B12 và B6",
            "Giàu kẽm, tốt cho hệ miễn dịch"
        ],
        "health_warnings": [
            "Nấu chín kỹ",
            "Người mỡ máu cao nên hạn chế"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày. Đảm bảo nhiệt độ bảo quản đúng."
    },
    {
        "id": "pork_ribs",
        "name_vi": "Sườn heo",
        "name_en": "Pork Ribs",
        "aliases": ["suon heo", "pork ribs"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 277,
            "protein": 16,
            "carbohydrates": 0,
            "fat": 23,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b12": 0.8,
                "vitamin_d": 1.2
            },
            "minerals": {
                "calcium": 22,
                "phosphorus": 180
            }
        },
        "health_benefits": [
            "Giàu protein",
            "Chứa phosphorus tốt cho xương",
            "Cung cấp vitamin B12"
        ],
        "health_warnings": [
            "Hàm lượng mỡ cao",
            "Nấu chín kỹ",
            "Nên ăn vừa phải"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày. Thịt có xương dễ hỏng hơn."
    },
    {
        "id": "chicken_wings",
        "name_vi": "Cánh gà",
        "name_en": "Chicken Wings",
        "aliases": ["canh ga", "chicken wings"],
        "category": "meat",
        "shelf_life_refrigerated": 2,
        "shelf_life_frozen": 270,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 203,
            "protein": 30.5,
            "carbohydrates": 0,
            "fat": 8.1,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b6": 0.5,
                "vitamin_b12": 0.4
            },
            "minerals": {
                "selenium": 31,
                "phosphorus": 194
            }
        },
        "health_benefits": [
            "Giàu protein",
            "Chứa selenium tốt cho miễn dịch",
            "Cung cấp vitamin B"
        ],
        "health_warnings": [
            "Nấu chín kỹ để tránh vi khuẩn",
            "Da có nhiều mỡ"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 2 ngày. Gà tươi rất dễ hỏng."
    },
    {
        "id": "chicken_thigh",
        "name_vi": "Đùi gà",
        "name_en": "Chicken Thigh",
        "aliases": ["dui ga", "chicken thigh"],
        "category": "meat",
        "shelf_life_refrigerated": 2,
        "shelf_life_frozen": 270,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 209,
            "protein": 26,
            "carbohydrates": 0,
            "fat": 10.9,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b6": 0.5,
                "niacin": 6.2
            },
            "minerals": {
                "iron": 1.3,
                "zinc": 2.1
            }
        },
        "health_benefits": [
            "Giàu protein",
            "Chứa sắt và kẽm",
            "Cung cấp vitamin B"
        ],
        "health_warnings": [
            "Nấu chín kỹ",
            "Bỏ da nếu muốn giảm mỡ"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 2 ngày. Thịt gà tươi dễ hỏng."
    },
    {
        "id": "beef_shank",
        "name_vi": "Thịt bắp bò",
        "name_en": "Beef Shank",
        "aliases": ["thit bap bo", "beef shank"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 270,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 174,
            "protein": 31,
            "carbohydrates": 0,
            "fat": 5,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b12": 2.6,
                "niacin": 5
            },
            "minerals": {
                "iron": 2.9,
                "zinc": 6.3
            }
        },
        "health_benefits": [
            "Rất giàu protein",
            "Nhiều sắt, phòng ngừa thiếu máu",
            "Giàu kẽm và vitamin B12"
        ],
        "health_warnings": [
            "Nấu chín kỹ",
            "Người cholesterol cao nên hạn chế"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày. Thịt bò thịt đỏ bảo quản tốt hơn gà."
    },
    {
        "id": "beef_steak",
        "name_vi": "Bít tết bò",
        "name_en": "Beef Steak",
        "aliases": ["bit tet", "beef steak", "steak"],
        "category": "meat",
        "shelf_life_refrigerated": 3,
        "shelf_life_frozen": 270,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 250,
            "protein": 26,
            "carbohydrates": 0,
            "fat": 16,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b12": 2.4,
                "vitamin_b6": 0.5
            },
            "minerals": {
                "iron": 2.6,
                "zinc": 4.5
            }
        },
        "health_benefits": [
            "Giàu protein chất lượng cao",
            "Nhiều sắt và kẽm",
            "Cung cấp vitamin B12"
        ],
        "health_warnings": [
            "Nấu chín vừa phải theo sở thích",
            "Người mỡ máu cao nên hạn chế"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 3 ngày. Bít tết nên để ở nhiệt độ phòng 30 phút trước khi nấu."
    },
    {
        "id": "duck_meat",
        "name_vi": "Thịt vịt",
        "name_en": "Duck Meat",
        "aliases": ["thit vit", "duck"],
        "category": "meat",
        "shelf_life_refrigerated": 2,
        "shelf_life_frozen": 180,
        "nutrition_data": {
            "serving_size": "100g",
            "calories": 337,
            "protein": 19,
            "carbohydrates": 0,
            "fat": 28.4,
            "fiber": 0,
            "sugar": 0,
            "vitamins": {
                "vitamin_b6": 0.3,
                "niacin": 5.1
            },
            "minerals": {
                "iron": 2.7,
                "selenium": 22
            }
        },
        "health_benefits": [
            "Giàu protein",
            "Chứa sắt và selenium",
            "Cung cấp vitamin B"
        ],
        "health_warnings": [
            "Hàm lượng mỡ cao",
            "Nấu chín kỹ",
            "Bỏ da để giảm mỡ"
        ],
        "storage_tips": "Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. Nên sử dụng trong vòng 2 ngày. Thịt vịt tươi dễ hỏng."
    }
]

def expand_database(input_file, output_file):
    """Expand database with additional products"""

    # Read current database
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    current_products = data['products']
    print(f"📊 Current products: {len(current_products)}")

    # Count by category
    current_by_category = {}
    for product in current_products:
        cat = product.get('category', 'other')
        current_by_category[cat] = current_by_category.get(cat, 0) + 1

    print(f"\n📊 Current distribution:")
    for cat, count in sorted(current_by_category.items()):
        print(f"  - {cat}: {count}")

    # Add new products
    new_products = (
        ADDITIONAL_VEGETABLES +
        ADDITIONAL_FRUITS +
        ADDITIONAL_MEAT
    )

    print(f"\n➕ Adding {len(new_products)} new products:")
    print(f"  - Vegetables: {len(ADDITIONAL_VEGETABLES)}")
    print(f"  - Fruits: {len(ADDITIONAL_FRUITS)}")
    print(f"  - Meat: {len(ADDITIONAL_MEAT)}")

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

    # Merge products
    all_products = current_products + products_to_add

    # Create output data
    output_data = {
        'version': '2.2.0',
        'last_updated': '2025-11-11',
        'total_products': len(all_products),
        'products': all_products
    }

    # Count new distribution
    new_by_category = {}
    for product in all_products:
        cat = product.get('category', 'other')
        new_by_category[cat] = new_by_category.get(cat, 0) + 1

    print(f"\n📊 New distribution:")
    for cat, count in sorted(new_by_category.items()):
        added = count - current_by_category.get(cat, 0)
        print(f"  - {cat}: {count} (+{added})")

    # Write output file
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2)

    print(f"\n✅ Expanded database saved to: {output_file}")
    print(f"📊 Total products: {len(current_products)} → {len(all_products)}")
    print(f"📈 Added: {len(products_to_add)} new products")

if __name__ == '__main__':
    input_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'
    output_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'

    print("🚀 Expanding database with Vietnamese products...")
    expand_database(input_file, output_file)
