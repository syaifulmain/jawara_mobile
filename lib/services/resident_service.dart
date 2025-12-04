import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/resident/resident_list_model.dart';
import '../models/resident/resident_detail_model.dart';
import '../models/resident/resident_request_model.dart';
import 'api_exception.dart';

class ResidentService {
  Future<List<ResidentListModel>> getResidents(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.residents),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => ResidentListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get residents (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<ResidentListModel>> searchResidents(
    String token,
    String query,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.residents}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => ResidentListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search residents (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<ResidentDetailModel> getResidentDetail(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.residents}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return ResidentDetailModel.fromJson(data);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get resident detail (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> createResident(
    String token,
    ResidentRequestModel request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.residents),
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
            : 'Failed to create resident (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> updateResident(
    String token,
    String id,
    ResidentRequestModel request,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.residents}/$id'),
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
            : 'Failed to update resident (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  // Get resident by user ID (to get family_id for logged-in user)
  Future<ResidentDetailModel?> getResidentByUserId(
    String token,
    String userId,
  ) async {
    try {
      // Fallback: Get all residents and filter by user_id on client side
      // since backend might not have /residents/user/{userId} endpoint

      final response = await http.get(
        Uri.parse(ApiConstants.residents),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];

        // Find resident with matching user_id
        final residentJson = data.firstWhere((r) {
          final residentUserId = r['user_id']?.toString();
          return residentUserId == userId;
        }, orElse: () => null);

        if (residentJson != null) {
          return ResidentDetailModel.fromJson(residentJson);
        }

        // User has no resident record
        return null;
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get resident by user ID (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
