enum IncomeType {
  iuran('iuran', 'Iuran'),
  donasi('donasi', 'Donasi'),
  penjualan('penjualan', 'Penjualan'),
  bantuan('bantuan', 'Bantuan'),
  lainnya('lainnya', 'Lainnya');

  final String value;
  final String label;

  const IncomeType(this.value, this.label);

  static IncomeType fromString(String value) {
    return IncomeType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => IncomeType.lainnya,
    );
  }
}
