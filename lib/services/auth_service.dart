// language: dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/user/update_user_request_model.dart';
import '../models/user_model.dart';
import 'api_exception.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      print(body);

      if (response.statusCode == 200) {
        return body['data'];
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Login failed with status ${response.statusCode}';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return UserModel.fromJson(data['user']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get profile (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> logout(String token) async {
    try {
      await http.post(
        Uri.parse(ApiConstants.logout),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {
      // ignore logout errors
    }
  }

  Future<void> updateProfile(
    String token,
    String id,
    UpdateUserRequestModel req,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.profile}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(req.toJson()),
      );
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        // Accept both `data.user` or `data` structures
        // final data = body != null && body['data'] != null ? body['data'] : body;
        // final userJson = data != null && data['user'] != null ? data['user'] : data;
        // return UserModel.fromJson(data['user']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to update profile (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
