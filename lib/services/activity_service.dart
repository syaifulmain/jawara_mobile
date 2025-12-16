import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../enums/activity_category.dart';
import '../models/activity_model.dart';
import '../models/activity/create_activity_request_model.dart';
import 'api_exception.dart';

class ActivityService {
  Future<List<Activity>> getActivities(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.activities),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get activities (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Activity> getActivityById(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.activities}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return Activity.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get activity (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Activity> createActivity(
    String token,
    CreateActivityRequest request,
  ) async {
    try {
      // Jika ada bukti pengeluaran, gunakan multipart request
      if (request.isPengeluaran && request.buktiPengeluaran != null) {
        var multipartRequest = http.MultipartRequest(
          'POST',
          Uri.parse(ApiConstants.activities),
        );

        multipartRequest.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        multipartRequest.fields.addAll(request.toFields());

        multipartRequest.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pengeluaran',
            request.buktiPengeluaran!.path,
          ),
        );

        final streamedResponse = await multipartRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        final body = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;

        if (response.statusCode == 201 || response.statusCode == 200) {
          return Activity.fromJson(body['data']);
        } else {
          final msg = body != null && body['message'] != null
              ? body['message'].toString()
              : 'Failed to create activity (${response.statusCode})';
          throw ApiException(msg, response.statusCode);
        }
      } else {
        // Jika tidak ada file, gunakan JSON request biasa
        final response = await http.post(
          Uri.parse(ApiConstants.activities),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(request.toJson()),
        );

        final body = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;

        if (response.statusCode == 201 || response.statusCode == 200) {
          return Activity.fromJson(body['data']);
        } else {
          final msg = body != null && body['message'] != null
              ? body['message'].toString()
              : 'Failed to create activity (${response.statusCode})';
          throw ApiException(msg, response.statusCode);
        }
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Activity> updateActivity(
    String token,
    String id,
    CreateActivityRequest request,
  ) async {
    try {
      // Jika ada bukti pengeluaran, gunakan multipart request dengan POST dan _method=PUT
      if (request.isPengeluaran && request.buktiPengeluaran != null) {
        var multipartRequest = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConstants.activities}/$id'),
        );

        multipartRequest.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        var fields = request.toFields();
        fields['_method'] = 'PUT'; // Laravel method spoofing
        multipartRequest.fields.addAll(fields);

        multipartRequest.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pengeluaran',
            request.buktiPengeluaran!.path,
          ),
        );

        final streamedResponse = await multipartRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        final body = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;

        if (response.statusCode == 200) {
          return Activity.fromJson(body['data']);
        } else {
          final msg = body != null && body['message'] != null
              ? body['message'].toString()
              : 'Failed to update activity (${response.statusCode})';
          throw ApiException(msg, response.statusCode);
        }
      } else {
        // Jika tidak ada file, gunakan JSON request biasa
        final response = await http.put(
          Uri.parse('${ApiConstants.activities}/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(request.toJson()),
        );

        final body = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;

        if (response.statusCode == 200) {
          return Activity.fromJson(body['data']);
        } else {
          final msg = body != null && body['message'] != null
              ? body['message'].toString()
              : 'Failed to update activity (${response.statusCode})';
          throw ApiException(msg, response.statusCode);
        }
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> deleteActivity(String token, String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.activities}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode != 200 && response.statusCode != 204) {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to delete activity (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<Activity>> getActivitiesByCategory(
    String token,
    ActivityCategory category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.activities}?category=${category.name}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get activities by category (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<Activity>> searchActivities(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.activities}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search activities (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<Activity>> getActivitiesByCategoryOrDate(
    String token, {
    ActivityCategory? category,
    DateTime? date,
  }) async {
    try {
      String url = ApiConstants.activities;
      List<String> queryParams = [];

      if (category != null) {
        queryParams.add('category=${category.name}');
      }
      if (date != null) {
        queryParams.add('date=${date.toIso8601String()}');
      }
      if (queryParams.isNotEmpty) {
        url += '?' + queryParams.join('&');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get filtered activities (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<Activity>> getActivitiesThisMonth(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.activityThisMonth),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get activities this month (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
