enum IncomeType {
  bulanan('bulanan', 'Iuran Bulanan'),
  khusus('khusus', 'Iuran Khusus');

  final String value;
  final String label;

  const IncomeType(this.value, this.label);

  static IncomeType fromString(String value) {
    return IncomeType.values.firstWhere(
          (category) => category.value == value,
      orElse: () => IncomeType.bulanan,
    );
  }
}
