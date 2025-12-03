import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constant.dart';
import '../models/pengeluaran/pengeluaran_list_model.dart';
import '../models/pengeluaran/pengeluaran_detail_model.dart';
import '../models/pengeluaran/pengeluaran_request_model.dart';
import 'api_exception.dart';

class PengeluaranService {
  /// GET list pengeluaran dengan filter (optional)
  Future<List<PengeluaranListModel>> getPengeluaranList(
    String token, {
    String? search,
    String? kategori,
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url = ApiConstants.pengeluaran;

      // Build Query Params
      List<String> params = [];
      if (search != null) params.add('search=$search');
      if (kategori != null) params.add('kategori=$kategori');
      if (startDate != null) params.add('start_date=$startDate');
      if (endDate != null) params.add('end_date=$endDate');

      if (params.isNotEmpty) url += '?${params.join("&")}';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => PengeluaranListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message']
            : 'Failed to get pengeluaran (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Network error: $e");
    }
  }

  /// GET detail pengeluaran berdasarkan ID
  Future<PengeluaranDetailModel> getPengeluaranById(
    String token,
    String id,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.pengeluaran}/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return PengeluaranDetailModel.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message']
            : 'Failed to get pengeluaran detail (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Network error: $e");
    }
  }

  /// CREATE pengeluaran
  Future<PengeluaranDetailModel> createPengeluaran(
    String token,
    PengeluaranRequestModel request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.pengeluaran),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PengeluaranDetailModel.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message']
            : 'Failed to create pengeluaran (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Network error: $e");
    }
  }

  /// GET detail pengeluaran berdasarkan ID (untuk provider)
  Future<PengeluaranDetailModel> getPengeluaranDetail(
    String token,
    String id,
  ) async {
    return getPengeluaranById(token, id);
  }
}
