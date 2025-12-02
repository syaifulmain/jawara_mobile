import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class BaseApiService {
  Map<String, String> headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>?> request({
    required String url,
    required String method,
    String? token,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    List<int> allowedStatusCodes = const [200],
  }) async {
    try {
      Uri uri = Uri.parse(url);

      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers(token ?? ''));
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers(token ?? ''),
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers(token ?? ''),
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers(token ?? ''));
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      if (!allowedStatusCodes.contains(response.statusCode)) {
        final message = decoded?['message'] ??
            'Request failed (${response.statusCode})';
        throw ApiException(message.toString(), response.statusCode);
      }

      return decoded;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
