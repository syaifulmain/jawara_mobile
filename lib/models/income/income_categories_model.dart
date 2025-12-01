import '../../enums/income_type.dart';
class IncomeCategories {
  final int? id;
  final String name;
  final IncomeType type;
  final String nominal;
  final String description;
  final int createdBy; // Foreign key to user table
  final String? createdByName; // User's name for display
  final DateTime createdAt;
  final DateTime updatedAt;

  IncomeCategories({
    this.id,
    required this.name,
    required this.type,
    required this.nominal,
    required this.description,
    required this.createdBy,
    this.createdByName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IncomeCategories.fromJson(Map<String, dynamic> json) {
    // Handle nested user object if present, otherwise use direct ID
    int createdByUserId;
    String? createdByUserName;
    
    if (json['created_by'] is Map<String, dynamic>) {
      // If created_by is a user object with relationship
      final userObj = json['created_by'] as Map<String, dynamic>;
      createdByUserId = userObj['id'] as int;
      createdByUserName = userObj['name'] as String?;
    } else {
      // If created_by is just the user ID
      createdByUserId = json['created_by'] as int;
      createdByUserName = json['created_by_name'] as String?; // Fallback field
    }
    
    return IncomeCategories(
      id: json['id'] as int?,
      name: json['name'] as String,
      type: IncomeType.fromString(json['type'] as String),
      nominal: json['nominal'] as String,
      description: json['description'] as String,
      createdBy: createdByUserId,
      createdByName: createdByUserName,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.value,
      'nominal': nominal,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  IncomeCategories copyWith({
    int? id,
    String? name,
    IncomeType? type,
    String? nominal,
    String? description,
    int? createdBy,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IncomeCategories(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      nominal: nominal ?? this.nominal,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper method to get display name for created by field
  String get createdByDisplayName {
    return createdByName ?? 'User ID: $createdBy';
  }
}

