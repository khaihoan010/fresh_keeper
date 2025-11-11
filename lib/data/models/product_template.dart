import 'dart:convert';
import 'nutrition_data.dart';

/// Product Template Model
/// Represents a product template with nutrition data and shelf life information
class ProductTemplate {
  final String id;
  final String nameVi;
  final String nameEn;
  final List<String> aliases;
  final String category;
  final int? shelfLifeRefrigerated; // days
  final int? shelfLifeFrozen; // days
  final int? shelfLifeOpened; // days
  final NutritionData? nutritionData;
  final List<String>? healthBenefits;
  final List<String>? healthWarnings;
  final String? storageTips;
  final String? imageUrl;

  const ProductTemplate({
    required this.id,
    required this.nameVi,
    required this.nameEn,
    required this.aliases,
    required this.category,
    this.shelfLifeRefrigerated,
    this.shelfLifeFrozen,
    this.shelfLifeOpened,
    this.nutritionData,
    this.healthBenefits,
    this.healthWarnings,
    this.storageTips,
    this.imageUrl,
  });

  /// Calculate expiry date based on purchase date
  DateTime calculateExpiryDate(
    DateTime purchaseDate, {
    bool frozen = false,
  }) {
    final days = frozen
        ? (shelfLifeFrozen ?? 30)
        : (shelfLifeRefrigerated ?? 7);
    return purchaseDate.add(Duration(days: days));
  }

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_vi': nameVi,
      'name_en': nameEn,
      'aliases': jsonEncode(aliases),
      'category': category,
      'shelf_life_refrigerated': shelfLifeRefrigerated,
      'shelf_life_frozen': shelfLifeFrozen,
      'shelf_life_opened': shelfLifeOpened,
      'nutrition_data': nutritionData != null
          ? jsonEncode(nutritionData!.toJson())
          : null,
      'health_benefits': healthBenefits != null
          ? jsonEncode(healthBenefits)
          : null,
      'health_warnings': healthWarnings != null
          ? jsonEncode(healthWarnings)
          : null,
      'storage_tips': storageTips,
      'image_url': imageUrl,
    };
  }

  /// Create from JSON
  factory ProductTemplate.fromJson(Map<String, dynamic> json) {
    return ProductTemplate(
      id: json['id'] as String,
      nameVi: json['name_vi'] as String,
      nameEn: json['name_en'] as String,
      aliases: json['aliases'] is String
          ? List<String>.from(jsonDecode(json['aliases'] as String))
          : List<String>.from(json['aliases'] ?? []),
      category: json['category'] as String,
      shelfLifeRefrigerated: json['shelf_life_refrigerated'] as int?,
      shelfLifeFrozen: json['shelf_life_frozen'] as int?,
      shelfLifeOpened: json['shelf_life_opened'] as int?,
      nutritionData: json['nutrition_data'] != null
          ? NutritionData.fromJson(
              json['nutrition_data'] is String
                  ? jsonDecode(json['nutrition_data'] as String)
                  : json['nutrition_data'],
            )
          : null,
      healthBenefits: json['health_benefits'] != null
          ? List<String>.from(
              json['health_benefits'] is String
                  ? jsonDecode(json['health_benefits'] as String)
                  : json['health_benefits'],
            )
          : null,
      healthWarnings: json['health_warnings'] != null
          ? List<String>.from(
              json['health_warnings'] is String
                  ? jsonDecode(json['health_warnings'] as String)
                  : json['health_warnings'],
            )
          : null,
      storageTips: json['storage_tips'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  /// Check if has nutrition data
  bool get hasNutrition => nutritionData != null && nutritionData!.hasData;

  /// Check if has health information
  bool get hasHealthInfo =>
      (healthBenefits != null && healthBenefits!.isNotEmpty) ||
      (healthWarnings != null && healthWarnings!.isNotEmpty);

  @override
  String toString() {
    return 'ProductTemplate(id: $id, nameVi: $nameVi, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductTemplate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
