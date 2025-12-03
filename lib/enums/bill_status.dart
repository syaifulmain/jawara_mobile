enum BillStatus {
  unpaid('unpaid', 'Belum Dibayar'),
  pending('pending', 'Menunggu Verifikasi'),
  paid('paid', 'Lunas'),
  overdue('overdue', 'Terlambat'),
  rejected('rejected', 'Ditolak');

  const BillStatus(this.value, this.label);

  final String value;
  final String label;

  static BillStatus fromString(String value) {
    return BillStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BillStatus.unpaid,
    );
  }
}