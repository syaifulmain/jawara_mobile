import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/dashboard/kegiatan.dart';
import '../models/dashboard/kependudukan.dart';
import '../models/dashboard/keuangan.dart';
import 'api_exception.dart';

class DashboardService {
  Future<DashboardKeuanganResponse> getDashboardKeuangan(
      String token, {
        int? year,
      }) async {
    try {
      final queryParameters = year != null ? {'year': year.toString()} : <String, String>{};
      final uri = Uri.parse(ApiConstants.dashboardKeuangan).replace(
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return DashboardKeuanganResponse.fromJson(body);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get dashboard keuangan (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<DashboardKegiatanResponse> getDashboardKegiatan(
      String token, {
        int? year,
      }) async {
    try {
      final queryParameters = year != null ? {'year': year.toString()} : <String, String>{};
      final uri = Uri.parse(ApiConstants.dashboardKegiatan).replace(
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return DashboardKegiatanResponse.fromJson(body);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get dashboard kegiatan (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<DashboardKependudukanResponse> getDashboardKependudukan(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.dashboardKependudukan),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return DashboardKependudukanResponse.fromJson(body);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get dashboard kependudukan (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
