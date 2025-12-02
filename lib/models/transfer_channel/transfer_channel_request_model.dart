import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';

class TransferChannelRequestModel {
  final String name;
  final TransferChannelType type;
  final String ownerName;
  final String accountNumber;
  final String? qrCodeImagePath;
  final String? thumbnailImagePath;
  final String notes;

  TransferChannelRequestModel({
    required this.name,
    required this.type,
    required this.ownerName,
    required this.accountNumber,
     this.qrCodeImagePath,
     this.thumbnailImagePath,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toStringValue(),
      'owner_name': ownerName,
      'account_number': accountNumber,
      'qr_code_image_path': qrCodeImagePath,
      'thumbnail_image_path': thumbnailImagePath,
      'notes': notes,
    };
  }
}
