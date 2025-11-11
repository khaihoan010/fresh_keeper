import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/models/nutrition_data.dart';
import '../data/models/product_template.dart';

/// Nutrition API Service
/// Fetches nutrition data from Open Food Facts API (free, no API key needed)
class NutritionApiService {
  static const String _baseUrl = 'https://world.openfoodfacts.net';
  static const String _userAgent = 'FreshKeeper/1.0.0 (fresh.keeper@example.com)';

  /// Search products by name
  /// Returns list of product suggestions with nutrition data
  Future<List<ProductTemplate>> searchProducts(String query) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/cgi/search.pl?search_terms=$query&page_size=10&json=1',
      );

      debugPrint('🔍 Searching products: $query');

      final response = await http.get(
        url,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final products = data['products'] as List<dynamic>? ?? [];

        debugPrint('✅ Found ${products.length} products');

        return products
            .map((p) => _parseOpenFoodFactsProduct(p))
            .where((p) => p != null)
            .cast<ProductTemplate>()
            .toList();
      } else {
        debugPrint('❌ API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error searching products: $e');
      return [];
    }
  }

  /// Get product by barcode
  Future<ProductTemplate?> getProductByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v2/product/$barcode.json');

      debugPrint('📷 Fetching product by barcode: $barcode');

      final response = await http.get(
        url,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'] as int?;

        if (status == 1) {
          final product = data['product'] as Map<String, dynamic>;
          debugPrint('✅ Product found');
          return _parseOpenFoodFactsProduct(product);
        } else {
          debugPrint('⚠️ Product not found');
          return null;
        }
      } else {
        debugPrint('❌ API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error fetching product: $e');
      return null;
    }
  }

  /// Parse Open Food Facts product to ProductTemplate
  ProductTemplate? _parseOpenFoodFactsProduct(Map<String, dynamic> product) {
    try {
      // Get product name
      final name = product['product_name'] as String? ??
          product['product_name_en'] as String? ??
          'Unknown';

      if (name == 'Unknown' || name.isEmpty) return null;

      // Get category - try to map to our categories
      final categories = product['categories'] as String? ?? '';
      final category = _mapCategory(categories);

      // Parse nutrition data
      final nutriments = product['nutriments'] as Map<String, dynamic>?;
      NutritionData? nutritionData;

      if (nutriments != null) {
        nutritionData = NutritionData(
          servingSize: '100g',
          calories: _getDouble(nutriments, 'energy-kcal_100g'),
          protein: _getDouble(nutriments, 'proteins_100g'),
          carbohydrates: _getDouble(nutriments, 'carbohydrates_100g'),
          fat: _getDouble(nutriments, 'fat_100g'),
          fiber: _getDouble(nutriments, 'fiber_100g'),
          sugar: _getDouble(nutriments, 'sugars_100g'),
          vitamins: {
            if (_getDouble(nutriments, 'vitamin-a_100g') != null)
              'vitamin_a': _getDouble(nutriments, 'vitamin-a_100g')!,
            if (_getDouble(nutriments, 'vitamin-c_100g') != null)
              'vitamin_c': _getDouble(nutriments, 'vitamin-c_100g')!,
            if (_getDouble(nutriments, 'vitamin-d_100g') != null)
              'vitamin_d': _getDouble(nutriments, 'vitamin-d_100g')!,
          },
          minerals: {
            if (_getDouble(nutriments, 'calcium_100g') != null)
              'calcium': _getDouble(nutriments, 'calcium_100g')!,
            if (_getDouble(nutriments, 'iron_100g') != null)
              'iron': _getDouble(nutriments, 'iron_100g')!,
            if (_getDouble(nutriments, 'potassium_100g') != null)
              'potassium': _getDouble(nutriments, 'potassium_100g')!,
            if (_getDouble(nutriments, 'sodium_100g') != null)
              'sodium': _getDouble(nutriments, 'sodium_100g')!,
          },
        );
      }

      // Create unique ID from barcode or name
      final barcode = product['code'] as String?;
      final id = barcode ?? name.toLowerCase().replaceAll(' ', '_');

      return ProductTemplate(
        id: 'api_$id',
        nameVi: name,
        nameEn: name,
        aliases: [name.toLowerCase()],
        category: category,
        shelfLifeRefrigerated: _getDefaultShelfLife(category),
        nutritionData: nutritionData,
        healthBenefits: _parseList(product, 'health_benefits'),
        healthWarnings: _parseList(product, 'allergens_tags'),
        storageTips: null,
        imageUrl: product['image_url'] as String?,
      );
    } catch (e) {
      debugPrint('⚠️ Error parsing product: $e');
      return null;
    }
  }

  /// Map Open Food Facts category to our category
  String _mapCategory(String categories) {
    final lower = categories.toLowerCase();

    if (lower.contains('vegetable') || lower.contains('rau')) {
      return 'vegetables';
    } else if (lower.contains('fruit') || lower.contains('trái cây')) {
      return 'fruits';
    } else if (lower.contains('meat') || lower.contains('thịt')) {
      return 'meat';
    } else if (lower.contains('dairy') || lower.contains('milk') || lower.contains('sữa')) {
      return 'dairy';
    } else if (lower.contains('egg') || lower.contains('trứng')) {
      return 'eggs';
    } else if (lower.contains('frozen') || lower.contains('đông lạnh')) {
      return 'frozen';
    } else if (lower.contains('condiment') || lower.contains('gia vị')) {
      return 'condiments';
    } else if (lower.contains('bread') || lower.contains('cereal') || lower.contains('bánh')) {
      return 'dry_food';
    }

    return 'other';
  }

  /// Get default shelf life based on category
  int _getDefaultShelfLife(String category) {
    switch (category) {
      case 'vegetables':
        return 7;
      case 'fruits':
        return 7;
      case 'meat':
        return 3;
      case 'eggs':
        return 21;
      case 'dairy':
        return 7;
      case 'frozen':
        return 90;
      case 'dry_food':
        return 30;
      case 'condiments':
        return 180;
      default:
        return 7;
    }
  }

  /// Get double value from nutriments
  double? _getDouble(Map<String, dynamic> nutriments, String key) {
    final value = nutriments[key];
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Parse list from product data
  List<String>? _parseList(Map<String, dynamic> product, String key) {
    final value = product[key];
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}
