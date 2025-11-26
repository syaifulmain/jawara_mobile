import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/activity_model.dart';

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

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Activity.fromJson(data);
      } else {
        throw Exception('Gagal mengambil detail kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Activity> createActivity(String token, Activity activity) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.activities),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(activity.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        return Activity.fromJson(data);
      } else {
        throw Exception('Gagal menambah kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Activity> updateActivity(String token, String id, Activity activity) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.activities}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(activity.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Activity.fromJson(data);
      } else {
        throw Exception('Gagal memperbarui kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Activity>> getActivitiesByCategory(String token, ActivityCategory category) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.activities}?category=${category.value}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mencari kegiatan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
