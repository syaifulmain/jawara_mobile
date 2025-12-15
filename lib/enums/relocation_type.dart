enum RelocationType {
  moveHouse("MOVE_HOUSE", "Pindah Rumah"),
  emigrate("EMIGRATE", "Keluar Area");

  final String value;
  final String label;

  const RelocationType(this.value, this.label);

  factory RelocationType.fromString(String value) {
    return RelocationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RelocationType.moveHouse,
    );
  }
}
