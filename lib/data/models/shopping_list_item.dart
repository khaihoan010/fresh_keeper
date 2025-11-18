import 'dart:convert';
import '../../config/constants.dart';
import 'nutrition_data.dart';
import 'product_template.dart';
import 'user_product.dart';

/// Shopping List Item Model
/// Represents an item in the shopping list
///
/// Now supports storing nutrition data invisibly for preservation
/// when items are moved between shopping list and fridge.
class ShoppingListItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String category;
  final bool isPurchased;
  final int sortOrder;
  final DateTime createdAt;

  // Nutrition data fields (stored but not displayed in shopping list)
  final String? productTemplateId;
  final String? nameEn;
  final NutritionData? nutritionData;
  final List<String>? healthBenefits;
  final List<String>? healthWarnings;
  final String? storageTips;

  ShoppingListItem({
    required this.id,
    required this.name,
    this.quantity = 1.0,
    this.unit = 'cái',
    this.category = 'other',
    this.isPurchased = false,
    required this.sortOrder,
    required this.createdAt,
    this.productTemplateId,
    this.nameEn,
    this.nutritionData,
    this.healthBenefits,
    this.healthWarnings,
    this.storageTips,
  });

  /// Create from product template (when adding from search)
  factory ShoppingListItem.fromTemplate(
    ProductTemplate template, {
    required String id,
    double quantity = 1.0,
    String? unit,
    required int sortOrder,
  }) {
    // Use provided unit or get default unit for category
    final defaultUnit = unit ?? AppConstants.getDefaultUnitForCategory(template.category);

    return ShoppingListItem(
      id: id,
      name: template.nameVi,
      nameEn: template.nameEn,
      quantity: quantity,
      unit: defaultUnit,
      category: template.category,
      isPurchased: false,
      sortOrder: sortOrder,
      createdAt: DateTime.now(),
      productTemplateId: template.id,
      nutritionData: template.nutritionData,
      healthBenefits: template.healthBenefits,
      healthWarnings: template.healthWarnings,
      storageTips: template.storageTips,
    );
  }

  /// Create from user product (when moving from fridge to shopping list)
  factory ShoppingListItem.fromUserProduct(
    UserProduct product,
    ProductTemplate? template, {
    required int sortOrder,
  }) {
    return ShoppingListItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: product.name,
      nameEn: product.nameEn,
      quantity: product.quantity,
      unit: product.unit,
      category: product.category,
      isPurchased: false,
      sortOrder: sortOrder,
      createdAt: DateTime.now(),
      productTemplateId: product.productTemplateId,
      nutritionData: template?.nutritionData,
      healthBenefits: template?.healthBenefits,
      healthWarnings: template?.healthWarnings,
      storageTips: template?.storageTips,
    );
  }

  /// Create from database map
  factory ShoppingListItem.fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: (map['unit'] as String?) ?? 'cái',
      category: (map['category'] as String?) ?? 'other',
      isPurchased: (map['is_purchased'] as int?) == 1,
      sortOrder: map['sort_order'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      productTemplateId: map['product_template_id'] as String?,
      nameEn: map['name_en'] as String?,
      nutritionData: map['nutrition_data'] != null
          ? NutritionData.fromJson(jsonDecode(map['nutrition_data'] as String))
          : null,
      healthBenefits: map['health_benefits'] != null
          ? List<String>.from(jsonDecode(map['health_benefits'] as String))
          : null,
      healthWarnings: map['health_warnings'] != null
          ? List<String>.from(jsonDecode(map['health_warnings'] as String))
          : null,
      storageTips: map['storage_tips'] as String?,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'is_purchased': isPurchased ? 1 : 0,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'product_template_id': productTemplateId,
      'name_en': nameEn,
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
    };
  }

  /// Create a copy with modified fields
  ShoppingListItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    String? category,
    bool? isPurchased,
    int? sortOrder,
    DateTime? createdAt,
    String? productTemplateId,
    String? nameEn,
    NutritionData? nutritionData,
    List<String>? healthBenefits,
    List<String>? healthWarnings,
    String? storageTips,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      productTemplateId: productTemplateId ?? this.productTemplateId,
      nameEn: nameEn ?? this.nameEn,
      nutritionData: nutritionData ?? this.nutritionData,
      healthBenefits: healthBenefits ?? this.healthBenefits,
      healthWarnings: healthWarnings ?? this.healthWarnings,
      storageTips: storageTips ?? this.storageTips,
    );
  }

  @override
  String toString() {
    return 'ShoppingListItem(id: $id, name: $name, quantity: $quantity, unit: $unit, category: $category, isPurchased: $isPurchased, sortOrder: $sortOrder, hasNutritionData: ${nutritionData != null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShoppingListItem &&
        other.id == id &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.category == category &&
        other.isPurchased == isPurchased &&
        other.sortOrder == sortOrder &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        quantity.hashCode ^
        unit.hashCode ^
        category.hashCode ^
        isPurchased.hashCode ^
        sortOrder.hashCode ^
        createdAt.hashCode;
  }
}
