enum IncomeType {
  bulanan('bulanan', 'Iuran Bulanan'),
  mingguan('mingguan', 'Iuran Mingguan'),
  tahunan('tahunan', 'Iuran Tahunan'),
  sekaliBayar('sekali_bayar', 'Sekali Bayar');

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
