import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_detail_model.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_list_model.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_request_model.dart';
import 'package:jawara_mobile_v2/services/api_exception.dart';
import '../constants/api_constant.dart';
import 'base_api_service.dart';

class TransferChannelService extends BaseApiService {
  Future<List<TransferChannelListModel>> getTransferChannels(
    String token,
  ) async {
    final body = await request(
      url: ApiConstants.transferChannels,
      method: 'GET',
      token: token,
    );

    final List<dynamic> data = body?['data'] ?? [];
    return data.map((e) => TransferChannelListModel.fromJson(e)).toList();
  }

  Future<List<TransferChannelListModel>> searchTransferChannels(
    String token,
    String query,
  ) async {
    final body = await request(
      url: ApiConstants.transferChannels,
      method: 'GET',
      token: token,
      queryParameters: {'search': query},
    );

    final List<dynamic> data = body?['data'] ?? [];
    return data.map((e) => TransferChannelListModel.fromJson(e)).toList();
  }

  Future<TransferChannelDetailModel> getDetail(String token, String id) async {
    final body = await request(
      url: '${ApiConstants.transferChannels}/$id',
      method: 'GET',
      token: token,
    );

    // print('Response body: $body'); // Debug

    if (body == null || body['data'] == null) {
      throw ApiException('Data tidak ditemukan');
    }

    return TransferChannelDetailModel.fromJson(body['data']);
  }

  Future<void> create(String token, TransferChannelRequestModel req) async {
    // await request(
    //   url: ApiConstants.transferChannels,
    //   method: 'POST',
    //   token: token,
    //   body: req.toJson(),
    //   allowedStatusCodes: [200, 201],
    // );
    // try{
    // Memakai multipart request
    try {
      await multipartRequest(
        url: ApiConstants.transferChannels,
        method: 'POST',
        token: token,
        fields: req.toFields(),
        files: {
          'qr_code_image': req.qrCodeImage,
          'thumbnail_image': req.thumbnailImage,
        },
        allowedStatusCodes: [200, 201],
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(
    String token,
    String id,
    TransferChannelDetailModel req,
  ) async {
    await request(
      url: '${ApiConstants.transferChannels}/$id',
      method: 'PUT',
      token: token,
      body: req.toJson(),
    );
  }
}
