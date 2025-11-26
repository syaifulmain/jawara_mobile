class Activity {
  final int? id;
  final String name;
  final ActivityCategory category;
  final DateTime date;
  final String location;
  final String personInCharge;
  final String description;

  Activity({
    this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.personInCharge,
    required this.description,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      name: json['name'] as String,
      category: ActivityCategory.fromString(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      personInCharge: json['person_in_charge'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.value,
      'date': date.toIso8601String(),
      'location': location,
      'person_in_charge': personInCharge,
      'description': description,
    };
  }

  Activity copyWith({
    int? id,
    String? name,
    ActivityCategory? category,
    DateTime? date,
    String? location,
    String? personInCharge,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      date: date ?? this.date,
      location: location ?? this.location,
      personInCharge: personInCharge ?? this.personInCharge,
      description: description ?? this.description,
    );
  }
}

enum ActivityCategory {
  religious('keagamaan', 'Keagamaan'),
  education('pendidikan', 'Pendidikan'),
  other('lainnya', 'Lainnya');

  final String value;
  final String label;

  const ActivityCategory(this.value, this.label);

  static ActivityCategory fromString(String value) {
    return ActivityCategory.values.firstWhere(
          (category) => category.value == value,
      orElse: () => ActivityCategory.other,
    );
  }
}
