import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../utils/date_utils.dart';

/// Product Status Enum
enum ProductStatus {
  active,
  used,
  expired;

  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Đang dùng';
      case ProductStatus.used:
        return 'Đã dùng';
      case ProductStatus.expired:
        return 'Hết hạn';
    }
  }
}

/// User Product Model
/// Represents a product that user added to their fridge
class UserProduct {
  final String id;
  final String? productTemplateId;
  final String name;
  final String? nameEn;
  final String category;
  final double quantity;
  final String unit;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String? notes;
  final String? location;
  final String? imagePath;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProduct({
    String? id,
    String? productTemplateId,
    String? templateId, // Alias for productTemplateId
    required this.name,
    this.nameEn,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    required this.expiryDate,
    this.notes,
    this.location,
    this.imagePath,
    this.status = ProductStatus.active,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : productTemplateId = productTemplateId ?? templateId,
        id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Days until expiry (normalized to start of day)
  ///
  /// IMPORTANT: Uses normalized dates to ensure consistency with database queries.
  /// Compares dates at midnight (00:00:00) to avoid time-component issues.
  int get daysUntilExpiry {
    final today = getToday();
    final expiry = normalizeDate(expiryDate);
    return expiry.difference(today).inDays;
  }

  /// Is expired (normalized comparison)
  ///
  /// Returns true if expiry date is before today (both normalized to midnight).
  bool get isExpired {
    final today = getToday();
    final expiry = normalizeDate(expiryDate);
    return expiry.isBefore(today);
  }

  /// Is expiring soon (within 7 days, normalized)
  ///
  /// Includes products expiring from today through 7 days from now.
  bool get isExpiringSoon {
    return daysUntilExpiry <= 7 && daysUntilExpiry >= 0;
  }

  /// Is urgent (within 2 days, normalized)
  ///
  /// Includes products expiring today, tomorrow, or day after tomorrow.
  bool get isUrgent {
    return daysUntilExpiry <= 2 && daysUntilExpiry >= 0;
  }

  /// Status color based on days until expiry
  Color getStatusColor() {
    return AppTheme.getExpiryStatusColor(daysUntilExpiry);
  }

  /// Status text
  String getStatusText() {
    return AppTheme.getExpiryStatusText(daysUntilExpiry);
  }

  /// Days remaining text
  String get daysRemainingText {
    if (isExpired) {
      final daysExpired = -daysUntilExpiry;
      return daysExpired == 0
          ? 'Hết hạn hôm nay'
          : 'Quá hạn $daysExpired ngày';
    } else if (daysUntilExpiry == 0) {
      return 'Hết hạn hôm nay';
    } else if (daysUntilExpiry == 1) {
      return 'Còn 1 ngày';
    } else {
      return 'Còn $daysUntilExpiry ngày';
    }
  }

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_template_id': productTemplateId,
      'name': name,
      'name_en': nameEn,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'purchase_date': purchaseDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'notes': notes,
      'location': location,
      'image_path': imagePath,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory UserProduct.fromJson(Map<String, dynamic> json) {
    return UserProduct(
      id: json['id'] as String,
      productTemplateId: json['product_template_id'] as String?,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      category: json['category'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      imagePath: json['image_path'] as String?,
      status: ProductStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProductStatus.active,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Copy with
  UserProduct copyWith({
    String? id,
    String? productTemplateId,
    String? name,
    String? nameEn,
    String? category,
    double? quantity,
    String? unit,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? notes,
    String? location,
    String? imagePath,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProduct(
      id: id ?? this.id,
      productTemplateId: productTemplateId ?? this.productTemplateId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserProduct(id: $id, name: $name, daysUntilExpiry: $daysUntilExpiry)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
