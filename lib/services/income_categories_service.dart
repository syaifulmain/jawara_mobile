import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../enums/income_type.dart';
import '../models/income/income_categories_model.dart';
import 'api_exception.dart';

class IncomeCategoriesService {
  // Get all categories
  Future<List<IncomeCategories>> getCategories(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.categories),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson
            .map((json) => IncomeCategories.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get categories',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Get category by ID
  Future<IncomeCategories> getCategoryById(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.categories}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return IncomeCategories.fromJson(data['data']);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message']
            ?? 'Failed to get category (${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Create category
  Future<IncomeCategories> createCategory(String token, IncomeCategories category) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.categories),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return IncomeCategories.fromJson(data['data']);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to create category',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Update category
  Future<IncomeCategories> updateCategories(String token, String id, IncomeCategories category) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.categories}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return IncomeCategories.fromJson(data['data']);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to update category',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Delete category
  Future<void> deleteCategories(String token, String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.categories}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to delete category',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Get categories by type
  Future<List<IncomeCategories>> getIncomeByType(String token, IncomeType type) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.categories}?type=${type.value}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson
            .map((json) => IncomeCategories.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message']
            ?? 'Failed to get categories by type (${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Search categories
  Future<List<IncomeCategories>> searchCategories(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.categories}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson
            .map((json) => IncomeCategories.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message']
            ?? 'Failed to search categories (${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Get categories by type or date
  Future<List<IncomeCategories>> getCategoriesByTypeOrDate(String token, {IncomeType? type, DateTime? date}) async {
    try {
      String queryParams = '';
      if (type != null) {
        queryParams += 'type=${type.value}';
      }
      if (date != null) {
        if (queryParams.isNotEmpty) queryParams += '&';
        queryParams += 'date=${date.toIso8601String().split('T')[0]}';
      }

      final uri = queryParams.isEmpty
          ? Uri.parse(ApiConstants.categories)
          : Uri.parse('${ApiConstants.categories}?$queryParams');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson
            .map((json) => IncomeCategories.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message']
            ?? 'Failed to get categories by type or date (${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
