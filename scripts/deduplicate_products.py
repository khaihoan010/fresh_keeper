#!/usr/bin/env python3
"""
Script to deduplicate products and ensure data consistency
- Keep only 1 unique entry per product name
- Standardize shelf life values
- Add appropriate disclaimers for fresh produce
"""

import json
import sys
from pathlib import Path
from collections import defaultdict

def deduplicate_products(input_file, output_file):
    """Deduplicate products and clean up data"""

    # Read input file
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    products = data['products']
    print(f"📊 Total products: {len(products)}")

    # Group products by name_vi
    grouped = defaultdict(list)
    for product in products:
        grouped[product['name_vi']].append(product)

    print(f"📊 Unique product names: {len(grouped)}")

    # Keep only the first occurrence of each product
    unique_products = []
    stats = []

    for name_vi, product_list in sorted(grouped.items()):
        if len(product_list) > 1:
            # Get all shelf life values for this product
            shelf_lives = [p.get('shelf_life_refrigerated', 0) for p in product_list]
            unique_shelf_lives = set(shelf_lives)

            stats.append({
                'name': name_vi,
                'count': len(product_list),
                'shelf_lives': list(unique_shelf_lives)
            })

        # Keep the first product (usually has the cleanest ID)
        product = product_list[0]

        # Standardize shelf life based on category
        category = product.get('category', '')
        shelf_life = product.get('shelf_life_refrigerated', 7)

        # Apply reasonable defaults based on category
        if category == 'vegetables':
            # Most vegetables: 5-7 days
            if shelf_life > 10:
                shelf_life = 7
        elif category == 'fruits':
            # Most fruits: 7-14 days depending on type
            if name_vi in ['Táo', 'Cam', 'Chanh', 'Bưởi']:
                shelf_life = 14  # Citrus and apples last longer
            elif name_vi in ['Chuối', 'Xoài', 'Dưa hấu', 'Dưa lưới']:
                shelf_life = 7   # Tropical fruits
            else:
                shelf_life = 10  # Default for other fruits
        elif category == 'meat':
            shelf_life = 3  # Fresh meat
        elif category == 'seafood':
            shelf_life = 2  # Fresh seafood
        elif category == 'dairy':
            shelf_life = 7  # Dairy products

        product['shelf_life_refrigerated'] = shelf_life

        # Update storage tips with proper disclaimer
        if category in ['vegetables', 'fruits']:
            storage_tips = (
                f"Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. "
                f"Đề xuất sử dụng trong vòng {shelf_life} ngày để giữ được giá trị dinh dưỡng và độ tươi ngon tốt nhất. "
                f"Thời gian bảo quản có thể thay đổi tùy thuộc vào độ chín và điều kiện bảo quản."
            )
        elif category == 'meat':
            storage_tips = (
                f"Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. "
                f"Nên sử dụng trong vòng {shelf_life} ngày. "
                f"Đối với thịt tươi, nên sử dụng càng sớm càng tốt."
            )
        elif category == 'seafood':
            storage_tips = (
                f"Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. "
                f"Hải sản tươi nên sử dụng trong vòng {shelf_life} ngày. "
                f"Đảm bảo bảo quản ở nhiệt độ thấp để giữ độ tươi."
            )
        elif category == 'dairy':
            storage_tips = (
                f"Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. "
                f"Nên sử dụng trong vòng {shelf_life} ngày sau khi mở nắp. "
                f"Kiểm tra hạn sử dụng trên bao bì."
            )
        else:
            storage_tips = (
                f"Bảo quản trong tủ lạnh ở nhiệt độ 2-8°C. "
                f"Đề xuất sử dụng trong vòng {shelf_life} ngày."
            )

        product['storage_tips'] = storage_tips

        unique_products.append(product)

    # Print statistics
    print(f"\n📊 Deduplication Statistics:")
    print(f"Before: {len(products)} products")
    print(f"After: {len(unique_products)} products")
    print(f"Removed: {len(products) - len(unique_products)} duplicates")

    if stats:
        print(f"\n⚠️  Products with inconsistent shelf life:")
        for stat in stats[:10]:  # Show first 10
            if len(stat['shelf_lives']) > 1:
                print(f"  - {stat['name']}: had {stat['count']} entries with shelf lives {stat['shelf_lives']}")

    # Create output data
    output_data = {
        'version': '2.1.0',
        'last_updated': '2025-11-11',
        'total_products': len(unique_products),
        'products': unique_products
    }

    # Write output file
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2)

    print(f"\n✅ Deduplicated data saved to: {output_file}")
    print(f"📊 Total unique products: {len(unique_products)}")

if __name__ == '__main__':
    input_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'
    output_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_clean.json'

    print("🔧 Deduplicating products...")
    deduplicate_products(input_file, output_file)
