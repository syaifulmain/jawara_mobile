import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/family/family_list_model.dart';
import '../models/family/family_detail_model.dart';
import 'api_exception.dart';

class FamilyService {
  Future<List<FamilyListModel>> getFamilies(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.families),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => FamilyListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get families (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<FamilyListModel>> searchFamilies(
    String token,
    String query,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.families}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => FamilyListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search families (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<FamilyDetailModel> getFamilyDetail(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.families}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return FamilyDetailModel.fromJson(data);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get family detail (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<FamilyDetailModel> getMyFamily(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/user/family'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return FamilyDetailModel.fromJson(data);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get my family (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
