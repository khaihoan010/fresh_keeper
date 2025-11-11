import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/models/nutrition_data.dart';
import '../data/models/product_template.dart';

/// Nutrition API Service
/// Fetches nutrition data from multiple sources:
/// - Open Food Facts API (free, no API key)
/// - USDA FoodData Central API (with API key)
class NutritionApiService {
  static const String _openFoodFactsUrl = 'https://world.openfoodfacts.net';
  static const String _usdaApiUrl = 'https://api.nal.usda.gov/fdc/v1';
  static const String _usdaApiKey = 'dI4H0IMZ4pZr5KJm31hgC3pF0Z0l86jRwPDHwCvN';
  static const String _userAgent = 'FreshKeeper/1.0.0 (fresh.keeper@example.com)';

  /// Search products from multiple sources
  /// Returns combined results from OpenFoodFacts and USDA
  Future<List<ProductTemplate>> searchProducts(String query) async {
    // Search both APIs in parallel for better performance
    final results = await Future.wait([
      _searchOpenFoodFacts(query),
      _searchUSDA(query),
    ]);

    final openFoodFactsResults = results[0];
    final usdaResults = results[1];

    // Combine and deduplicate
    final allResults = <ProductTemplate>[...openFoodFactsResults];
    for (final usdaResult in usdaResults) {
      final exists = allResults.any((existing) =>
        existing.nameEn.toLowerCase() == usdaResult.nameEn.toLowerCase() ||
        existing.nameVi.toLowerCase() == usdaResult.nameVi.toLowerCase()
      );
      if (!exists) {
        allResults.add(usdaResult);
      }
    }

    debugPrint('🔍 Total results: ${allResults.length} (OFF: ${openFoodFactsResults.length}, USDA: ${usdaResults.length})');
    return allResults;
  }

  /// Search Open Food Facts API
  Future<List<ProductTemplate>> _searchOpenFoodFacts(String query) async {
    try {
      final url = Uri.parse(
        '$_openFoodFactsUrl/cgi/search.pl?search_terms=$query&page_size=5&json=1',
      );

      debugPrint('🔍 [OpenFoodFacts] Searching: $query');

      final response = await http.get(
        url,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final products = data['products'] as List<dynamic>? ?? [];

        debugPrint('✅ [OpenFoodFacts] Found ${products.length} products');

        return products
            .map((p) => _parseOpenFoodFactsProduct(p))
            .where((p) => p != null)
            .cast<ProductTemplate>()
            .toList();
      } else {
        debugPrint('❌ [OpenFoodFacts] API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [OpenFoodFacts] Error: $e');
      return [];
    }
  }

  /// Search USDA FoodData Central API
  Future<List<ProductTemplate>> _searchUSDA(String query) async {
    try {
      final url = Uri.parse(
        '$_usdaApiUrl/foods/search?api_key=$_usdaApiKey&query=$query&pageSize=5&dataType=Foundation,SR%20Legacy',
      );

      debugPrint('🔍 [USDA] Searching: $query');

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final foods = data['foods'] as List<dynamic>? ?? [];

        debugPrint('✅ [USDA] Found ${foods.length} foods');

        return foods
            .map((f) => _parseUSDAFood(f))
            .where((p) => p != null)
            .cast<ProductTemplate>()
            .toList();
      } else {
        debugPrint('❌ [USDA] API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [USDA] Error: $e');
      return [];
    }
  }

  /// Get product by barcode
  Future<ProductTemplate?> getProductByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_openFoodFactsUrl/api/v2/product/$barcode.json');

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

  /// Parse USDA FoodData Central food item to ProductTemplate
  ProductTemplate? _parseUSDAFood(Map<String, dynamic> food) {
    try {
      final description = food['description'] as String?;
      if (description == null || description.isEmpty) return null;

      // Get food category
      final foodCategory = food['foodCategory'] as String? ?? '';
      final category = _mapUSDACategory(description, foodCategory);

      // Parse nutrition data from foodNutrients
      final foodNutrients = food['foodNutrients'] as List<dynamic>? ?? [];
      NutritionData? nutritionData;

      if (foodNutrients.isNotEmpty) {
        final nutrients = <String, double>{};
        for (final nutrient in foodNutrients) {
          final nutrientName = nutrient['nutrientName'] as String?;
          final value = nutrient['value'];
          if (nutrientName != null && value != null) {
            nutrients[nutrientName.toLowerCase()] = _parseNutrientValue(value);
          }
        }

        nutritionData = NutritionData(
          servingSize: '100g',
          calories: nutrients['energy'] ?? _findNutrient(nutrients, ['energy', 'calories']),
          protein: _findNutrient(nutrients, ['protein']),
          carbohydrates: _findNutrient(nutrients, ['carbohydrate', 'carbohydrates']),
          fat: _findNutrient(nutrients, ['total lipid (fat)', 'fat', 'total fat']),
          fiber: _findNutrient(nutrients, ['fiber', 'dietary fiber']),
          sugar: _findNutrient(nutrients, ['sugars', 'sugar']),
          vitamins: {
            if (_findNutrient(nutrients, ['vitamin c']) != null)
              'vitamin_c': _findNutrient(nutrients, ['vitamin c'])!,
            if (_findNutrient(nutrients, ['vitamin a']) != null)
              'vitamin_a': _findNutrient(nutrients, ['vitamin a'])!,
            if (_findNutrient(nutrients, ['vitamin d']) != null)
              'vitamin_d': _findNutrient(nutrients, ['vitamin d'])!,
            if (_findNutrient(nutrients, ['vitamin e']) != null)
              'vitamin_e': _findNutrient(nutrients, ['vitamin e'])!,
            if (_findNutrient(nutrients, ['vitamin k']) != null)
              'vitamin_k': _findNutrient(nutrients, ['vitamin k'])!,
          },
          minerals: {
            if (_findNutrient(nutrients, ['calcium']) != null)
              'calcium': _findNutrient(nutrients, ['calcium'])!,
            if (_findNutrient(nutrients, ['iron']) != null)
              'iron': _findNutrient(nutrients, ['iron'])!,
            if (_findNutrient(nutrients, ['potassium']) != null)
              'potassium': _findNutrient(nutrients, ['potassium'])!,
            if (_findNutrient(nutrients, ['sodium']) != null)
              'sodium': _findNutrient(nutrients, ['sodium'])!,
            if (_findNutrient(nutrients, ['magnesium']) != null)
              'magnesium': _findNutrient(nutrients, ['magnesium'])!,
            if (_findNutrient(nutrients, ['zinc']) != null)
              'zinc': _findNutrient(nutrients, ['zinc'])!,
          },
        );
      }

      final fdcId = food['fdcId'];
      final id = 'usda_${fdcId ?? description.toLowerCase().replaceAll(' ', '_')}';

      return ProductTemplate(
        id: id,
        nameVi: description,
        nameEn: description,
        aliases: [description.toLowerCase()],
        category: category,
        shelfLifeRefrigerated: _getDefaultShelfLife(category),
        nutritionData: nutritionData,
        healthBenefits: null,
        healthWarnings: null,
        storageTips: null,
        imageUrl: null,
      );
    } catch (e) {
      debugPrint('⚠️ Error parsing USDA food: $e');
      return null;
    }
  }

  /// Map USDA category to our category
  String _mapUSDACategory(String description, String foodCategory) {
    final lower = description.toLowerCase();
    final categoryLower = foodCategory.toLowerCase();

    if (lower.contains('vegetable') || categoryLower.contains('vegetable')) {
      return 'vegetables';
    } else if (lower.contains('fruit') || categoryLower.contains('fruit')) {
      return 'fruits';
    } else if (lower.contains('meat') || lower.contains('beef') ||
        lower.contains('pork') || lower.contains('chicken') ||
        lower.contains('fish') || categoryLower.contains('protein')) {
      return 'meat';
    } else if (lower.contains('dairy') || lower.contains('milk') ||
        lower.contains('cheese') || lower.contains('yogurt')) {
      return 'dairy';
    } else if (lower.contains('egg')) {
      return 'eggs';
    } else if (lower.contains('bread') || lower.contains('cereal') ||
        lower.contains('grain') || lower.contains('rice')) {
      return 'dry_food';
    }

    return 'other';
  }

  /// Find nutrient from map by multiple possible names
  double? _findNutrient(Map<String, double> nutrients, List<String> possibleNames) {
    for (final name in possibleNames) {
      final value = nutrients[name.toLowerCase()];
      if (value != null) return value;

      // Try partial match
      for (final key in nutrients.keys) {
        if (key.contains(name.toLowerCase())) {
          return nutrients[key];
        }
      }
    }
    return null;
  }

  /// Parse nutrient value to double
  double _parseNutrientValue(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
