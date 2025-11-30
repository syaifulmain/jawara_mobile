import 'package:jawara_mobile/models/channel_transfer_model.dart';

class ChannelTransferDummy {
  static final List<ChannelTransferModel> data = [
    ChannelTransferModel(
      namaChannel: 'Bank Central Asia (BCA)',
      tipe: Tipe.bank,
      nomorRekening: '1234567890',
      namaPemilik: 'John Doe',
      QRPath: 'assets/qr/bca_qr.png',
      thumbnailPath: 'assets/logo/bca.png',
      catatan: 'Transfer manual via BCA Mobile / ATM.',
    ),

    ChannelTransferModel(
      namaChannel: 'Bank Mandiri',
      tipe: Tipe.bank,
      nomorRekening: '9876543210',
      namaPemilik: 'John Doe',
      QRPath: 'assets/qr/mandiri_qr.png',
      thumbnailPath: 'assets/logo/mandiri.png',
      catatan: null,
    ),

    ChannelTransferModel(
      namaChannel: 'OVO',
      tipe: Tipe.eWallet,
      nomorRekening: '081234567890',
      namaPemilik: 'John Doe',
      QRPath: 'assets/qr/ovo_qr.png',
      thumbnailPath: 'assets/logo/ovo.png',
      catatan: 'Pastikan nomor OVO benar.',
    ),

    ChannelTransferModel(
      namaChannel: 'Dana',
      tipe: Tipe.eWallet,
      nomorRekening: '081234567891',
      namaPemilik: 'John Doe',
      QRPath: 'assets/qr/dana_qr.png',
      thumbnailPath: 'assets/logo/dana.png',
    ),

    ChannelTransferModel(
      namaChannel: 'GoPay',
      tipe: Tipe.eWallet,
      nomorRekening: '081234567892',
      namaPemilik: 'John Doe',
      QRPath: 'assets/qr/gopay_qr.png',
      thumbnailPath: 'assets/logo/gopay.png',
    ),

    ChannelTransferModel(
      namaChannel: 'QRIS – Universal',
      tipe: Tipe.qris,
      nomorRekening: '-',
      namaPemilik: 'Toko ABC',
      QRPath: 'assets/qr/qris_universal.png',
      thumbnailPath: 'assets/logo/qris.png',
      catatan: 'Bisa dipakai dari semua bank/e-wallet.',
    ),
  ];
}
