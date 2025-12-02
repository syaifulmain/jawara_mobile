import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/income/income_list_model.dart';
import 'api_exception.dart';

class IncomeService {
  Future<List<IncomeListModel>> getIncomes(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.incomes),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => IncomeListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get incomes (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<void> createIncome(String token, dynamic request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.incomes),
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
            : 'Failed to create income (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<List<IncomeListModel>> searchIncomes(
    String token,
    String query,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.incomes}?search=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => IncomeListModel.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to search incomes (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
