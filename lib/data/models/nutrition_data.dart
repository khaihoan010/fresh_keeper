/// Nutrition Data Model
class NutritionData {
  final String servingSize;
  final double? calories;
  final double? protein;
  final double? carbohydrates;
  final double? fat;
  final double? fiber;
  final double? sugar;
  final Map<String, double>? vitamins;
  final Map<String, double>? minerals;

  const NutritionData({
    required this.servingSize,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.fiber,
    this.sugar,
    this.vitamins,
    this.minerals,
  });

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'serving_size': servingSize,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'vitamins': vitamins,
      'minerals': minerals,
    };
  }

  /// Create from JSON
  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      servingSize: json['serving_size'] as String? ?? '100g',
      calories: (json['calories'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      sugar: (json['sugar'] as num?)?.toDouble(),
      vitamins: json['vitamins'] != null
          ? Map<String, double>.from(
              (json['vitamins'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  (value as num).toDouble(),
                ),
              ),
            )
          : null,
      minerals: json['minerals'] != null
          ? Map<String, double>.from(
              (json['minerals'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  (value as num).toDouble(),
                ),
              ),
            )
          : null,
    );
  }

  /// Create empty nutrition data
  factory NutritionData.empty() {
    return const NutritionData(servingSize: '100g');
  }

  /// Check if has any data
  bool get hasData {
    return calories != null ||
        protein != null ||
        carbohydrates != null ||
        fat != null ||
        fiber != null ||
        sugar != null ||
        (vitamins != null && vitamins!.isNotEmpty) ||
        (minerals != null && minerals!.isNotEmpty);
  }

  @override
  String toString() {
    return 'NutritionData(servingSize: $servingSize, calories: $calories, '
        'protein: $protein, carbs: $carbohydrates, fat: $fat)';
  }
}
