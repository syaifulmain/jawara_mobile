import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';

class TransferChannelListModel {
  final int id;
  final String name;
  final TransferChannelType type;
  final String ownerName;

  TransferChannelListModel({
    required this.id,
    required this.name,
    required this.type,
    required this.ownerName,
  });

  factory TransferChannelListModel.fromJson(Map<String, dynamic> json) {
    return TransferChannelListModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      type: TransferChannelType.fromString(json['type'] ?? ''),
      ownerName: json['owner_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toStringValue(),
      'owner_name': ownerName,
    };
  }
}
