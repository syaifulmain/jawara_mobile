import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/broadcast_model.dart';
import 'api_exception.dart';

class BroadcastService {
  Future<List<Broadcast>> getBroadcasts(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.broadcasts),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Broadcast.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get broadcasts (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Broadcast> getBroadcastById(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.broadcasts}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return Broadcast.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get broadcast (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Broadcast> createBroadcast(
      String token,
      Broadcast broadcast, {
        File? photoFile,
        File? documentFile,
      }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.broadcasts),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['title'] = broadcast.title;
      request.fields['message'] = broadcast.message;
      if (broadcast.publishedAt != null) {
        request.fields['published_at'] = broadcast.publishedAt!.toIso8601String();
      }

      if (photoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photoFile.path),
        );
      }

      if (documentFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('document', documentFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Broadcast.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to create broadcast (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Broadcast> updateBroadcast(String token, String id, Broadcast broadcast) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.broadcasts}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(broadcast.toJson()),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return Broadcast.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to update broadcast (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      print(broadcast.toJson());
      throw ApiException('Network error: $e');
    }
  }

  Future<void> deleteBroadcast(String token, String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.broadcasts}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode != 200 && response.statusCode != 204) {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to delete broadcast (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<Broadcast>> searchBroadcasts(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.broadcasts}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Broadcast.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search broadcasts (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
