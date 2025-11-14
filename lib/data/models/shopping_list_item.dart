/// Shopping List Item Model
/// Represents an item in the shopping list
class ShoppingListItem {
  final String id;
  final String name;
  final int sortOrder;
  final DateTime createdAt;

  ShoppingListItem({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
  });

  /// Create from database map
  factory ShoppingListItem.fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      id: map['id'] as String,
      name: map['name'] as String,
      sortOrder: map['sort_order'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  ShoppingListItem copyWith({
    String? id,
    String? name,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ShoppingListItem(id: $id, name: $name, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShoppingListItem &&
        other.id == id &&
        other.name == name &&
        other.sortOrder == sortOrder &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        sortOrder.hashCode ^
        createdAt.hashCode;
  }
}
