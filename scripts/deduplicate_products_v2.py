#!/usr/bin/env python3
"""
Script to deduplicate products while preserving scientifically accurate shelf life
- Keep only 1 unique entry per product name
- Preserve shelf life from original data (use most common value if inconsistent)
- Add appropriate disclaimers for fresh produce
"""

import json
import sys
from pathlib import Path
from collections import defaultdict, Counter

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

            # Choose the most common shelf life value
            shelf_life_counter = Counter(shelf_lives)
            most_common_shelf_life, count = shelf_life_counter.most_common(1)[0]

            # If there's a tie, choose the larger value (more conservative)
            if len([v for v, c in shelf_life_counter.items() if c == count]) > 1:
                most_common_shelf_life = max([v for v, c in shelf_life_counter.items() if c == count])

            stats.append({
                'name': name_vi,
                'count': len(product_list),
                'shelf_lives': list(unique_shelf_lives),
                'chosen': most_common_shelf_life,
                'reason': f'Most common ({count}/{len(product_list)})'
            })
        else:
            # Only one entry, use its shelf life
            most_common_shelf_life = product_list[0].get('shelf_life_refrigerated', 7)

        # Find the product with the simplest ID (no suffix) or first one
        product = None
        for p in product_list:
            if p['id'] == p['id'].split('_')[0] + '_' + p['id'].split('_')[1] if '_' in p['id'] and len(p['id'].split('_')) == 2 else False:
                product = p
                break
        if product is None:
            # If no simple ID found, use the one with the chosen shelf life
            for p in product_list:
                if p.get('shelf_life_refrigerated') == most_common_shelf_life:
                    product = p
                    break
        if product is None:
            product = product_list[0]

        # Use the most common shelf life value
        shelf_life = most_common_shelf_life
        product['shelf_life_refrigerated'] = shelf_life

        # Update storage tips with proper disclaimer based on category
        category = product.get('category', '')

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
                f"Thời gian có thể thay đổi tùy độ tươi khi mua."
            )
        elif category == 'seafood':
            storage_tips = (
                f"Bảo quản trong tủ lạnh ở nhiệt độ 0-4°C. "
                f"Hải sản tươi nên sử dụng trong vòng {shelf_life} ngày. "
                f"Đảm bảo bảo quản ở nhiệt độ thấp."
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
        print(f"\n📋 Products with multiple entries (showing chosen shelf life):")
        for stat in stats[:15]:  # Show first 15
            if len(stat['shelf_lives']) > 1:
                print(f"  - {stat['name']}: had {stat['shelf_lives']} days → chose {stat['chosen']} days ({stat['reason']})")
            else:
                print(f"  - {stat['name']}: {stat['chosen']} days (all entries agree)")

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
    input_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample_backup.json'
    output_file = Path(__file__).parent.parent / 'assets' / 'data' / 'products_sample.json'

    print("🔧 Deduplicating products with scientific shelf life preservation...")
    deduplicate_products(input_file, output_file)
