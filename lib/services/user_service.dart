import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/user/user_list_model.dart';
import '../models/user/user_detail_model.dart';
import '../models/auth/register_request_model.dart';
import 'api_exception.dart';

class UserService {
  Future<List<UserListModel>> getUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.users),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => UserListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get users (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<UserListModel>> searchUsers(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.users}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => UserListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search users (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<UserDetailModel> getUserDetail(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.users}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final data = body['data'];
        return UserDetailModel.fromJson(data);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get user detail (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<bool> register(RegisterRequest request) async {
    try {
      var multipartRequest = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/register'),
      );

      multipartRequest.headers.addAll({'Accept': 'application/json'});

      multipartRequest.fields.addAll(request.toFields());

      if (request.identityPhoto != null) {
        multipartRequest.files.add(
          await http.MultipartFile.fromPath(
            'identity_photo',
            request.identityPhoto!.path,
          ),
        );
      }

      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to register (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
