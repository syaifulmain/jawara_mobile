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