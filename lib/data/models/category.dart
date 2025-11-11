import 'package:flutter/material.dart';

/// Category Model
class Category {
  final String id;
  final String nameVi;
  final String nameEn;
  final String icon;
  final Color color;
  final int sortOrder;

  const Category({
    required this.id,
    required this.nameVi,
    required this.nameEn,
    required this.icon,
    required this.color,
    required this.sortOrder,
  });

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_vi': nameVi,
      'name_en': nameEn,
      'icon': icon,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'sort_order': sortOrder,
    };
  }

  /// Create from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      nameVi: json['name_vi'] as String,
      nameEn: json['name_en'] as String,
      icon: json['icon'] as String,
      color: _parseColor(json['color'] as String),
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  /// Parse color from hex string
  static Color _parseColor(String hexString) {
    final hex = hexString.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
    return Colors.grey;
  }

  /// Copy with
  Category copyWith({
    String? id,
    String? nameVi,
    String? nameEn,
    String? icon,
    Color? color,
    int? sortOrder,
  }) {
    return Category(
      id: id ?? this.id,
      nameVi: nameVi ?? this.nameVi,
      nameEn: nameEn ?? this.nameEn,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, nameVi: $nameVi, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
