import 'dart:io';

import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';

class TransferChannelRequestModel {
  final String name;
  final TransferChannelType type;
  final String ownerName;
  final String accountNumber;
  // final String? qrCodeImagePath;
  // final String? thumbnailImagePath;

  final File? qrCodeImage;
  final File? thumbnailImage;

  final String notes;

  TransferChannelRequestModel({
    required this.name,
    required this.type,
    required this.ownerName,
    required this.accountNumber,
    this.qrCodeImage,
    this.thumbnailImage,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toStringValue(),
      'owner_name': ownerName,
      'account_number': accountNumber,
      'notes': notes,
    };
  }

  Map<String, String> toFields() {
    return {
      'name': name,
      'type': type.toStringValue(),
      'owner_name': ownerName,
      'account_number': accountNumber,
      'notes': notes,
    };
  }
}
