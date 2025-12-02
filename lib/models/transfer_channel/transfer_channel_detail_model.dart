import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';

class TransferChannelDetailModel {
  final int id;
  final String name;
  final TransferChannelType type;
  final String ownerName;
  final String accountNumber;
  final String? qrCodeImagePath;
  final String? thumbnailImagePath;
  final String notes;

  TransferChannelDetailModel({
    required this.id,
    required this.name,
    required this.type,
    required this.ownerName,
    required this.accountNumber,
     this.qrCodeImagePath,
     this.thumbnailImagePath,
    required this.notes,
  });

  factory TransferChannelDetailModel.fromJson(Map<String, dynamic> json) {
    return TransferChannelDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: TransferChannelType.fromString(json['type'] ?? 'BANK'),
      ownerName: json['owner_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      qrCodeImagePath: json['qr_code_image_path'] ?? '',
      thumbnailImagePath: json['thumbnail_image_path'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
