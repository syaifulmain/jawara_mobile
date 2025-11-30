import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/address/address_list_model.dart';
import '../models/address/address_detail_model.dart';
import '../models/address/address_request_model.dart';
import 'api_exception.dart';

class AddressService {
  Future<List<AddressListModel>> getAddresses(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.addresses),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => AddressListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get addresses (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<AddressListModel>> searchAddresses(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.addresses}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => AddressListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search addresses (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<AddressDetailModel> getAddressDetail(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.addresses}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return AddressDetailModel.fromJson(data);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get address detail (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> createAddress(String token, AddressRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.addresses),
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
            : 'Failed to create address (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
