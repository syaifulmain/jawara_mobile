enum TransferChannelType {
  bank('BANK', 'Bank'),
  eWallet('E_WALLET', 'E-Wallet'),
  qris('QRIS', 'QRIS');

  final String value;
  final String label;

  const TransferChannelType(this.value, this.label);

  factory TransferChannelType.fromString(String value) {
    return TransferChannelType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransferChannelType.bank,
    );
  }

  String toStringValue() => value;
}