import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_detail_model.dart';
import '../constants/api_constant.dart';
import '../models/transfer_channel/transfer_channel_list_model.dart';
import 'api_exception.dart';

class TransferChannelService {
  Future<List<TransferChannelListModel>> getTransferChannels(
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.transferChannels),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data
            .map((json) => TransferChannelListModel.fromJson(json))
            .toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get transfer channels (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<TransferChannelListModel>> searchTransferChannels(
    String token,
    String query,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.transferChannels}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data
            .map((json) => TransferChannelListModel.fromJson(json))
            .toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search transfer channels (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<TransferChannelDetailModel> getTransferChannelDetail(
    String token,
    String id,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.transferChannels}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return TransferChannelDetailModel.fromJson(data);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get transfer channel detail (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> createTransferChannel(
    String token,
    TransferChannelDetailModel request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.transferChannels),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode != 201 && response.statusCode != 200) {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to create transfer channel (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> updateTransferChannel(
    String token,
    String id,
    TransferChannelDetailModel request,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.transferChannels}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode != 200) {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to update transfer channel (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
