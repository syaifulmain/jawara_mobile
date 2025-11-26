class ChannelTransferModel {
  final String namaChannel;
  final Tipe tipe;
  final String nomorRekening;
  final String namaPemilik;

  final String QRPath;
  final String thumbnailPath;

  final String? catatan;

  ChannelTransferModel({
    required this.namaChannel,
    required this.tipe,
    required this.nomorRekening,
    required this.namaPemilik,
    required this.QRPath,
    required this.thumbnailPath,
    this.catatan,
  });
}

enum Tipe {
  bank('bank', 'Bank'),
  eWallet('ewallet', 'E-Wallet'),
  qris('qris', 'QRIS');

  final String value;
  final String label;

  const Tipe(this.value, this.label);
}
