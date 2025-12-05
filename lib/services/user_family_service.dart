import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/family/family_detail_model.dart';
import 'api_exception.dart';

class UserFamilyService {
  // Ambil data keluarga user (user yang login)
  Future<FamilyDetailModel> getMyFamily(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.userFamily), 
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
            : 'Failed to get user family (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  // Tambah anggota keluarga
  Future<FamilyMemberModel> addFamilyMember(
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.userFamily),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final memberData = body['data'];
        return FamilyMemberModel.fromJson(memberData);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to add family member (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
