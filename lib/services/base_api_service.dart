import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class BaseApiService {
  Map<String, String> headers(String? token) {
    final h = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    // jangan set Content-Type di sini karena bisa berbeda per request (json vs multipart)
    return h;
  }

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

      if (queryParameters != null && queryParameters.isNotEmpty) {
        // convert all query values to string
        final qp = <String, String>{};
        queryParameters.forEach((k, v) {
          if (v != null) qp[k] = v.toString();
        });
        uri = uri.replace(queryParameters: qp);
      }

      late http.Response response;

      final requestHeaders = headers(token);
      // set Content-Type when sending JSON body
      if (body != null) {
        requestHeaders['Content-Type'] = 'application/json';
      }

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: requestHeaders);
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      final respBody = response.body;
      dynamic decoded;
      if (respBody.isNotEmpty) {
        try {
          decoded = jsonDecode(respBody);
        } catch (e) {
          // jika bukan JSON, bungkus sebagai message
          decoded = {'message': respBody};
        }
      } else {
        decoded = null;
      }

      if (!allowedStatusCodes.contains(response.statusCode)) {
        final message = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'Request failed (${response.statusCode})';
        throw ApiException(message, response.statusCode);
      }

      return decoded is Map<String, dynamic> ? decoded : (decoded == null ? null : {'data': decoded});
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>?> multipartRequest({
    required String url,
    required String method,
    String? token,
    required Map<String, String> fields,
    required Map<String, File?> files,
    List<int> allowedStatusCodes = const [200, 201],
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.MultipartRequest(method.toUpperCase(), uri);

      // headers (don't set Content-Type)
      request.headers.addAll(headers(token));

      // fields
      request.fields.addAll(fields);

      // files
      for (final entry in files.entries) {
        final fieldName = entry.key;
        final file = entry.value;

        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
        }
      }

      final streamed = await request.send();
      final responseText = await streamed.stream.bytesToString();
      final status = streamed.statusCode;

      if (!allowedStatusCodes.contains(status)) {
        throw ApiException(responseText, status);
      }

      if (responseText.isEmpty) return null;

      try {
        return jsonDecode(responseText) as Map<String, dynamic>;
      } catch (e) {
        // jika bukan JSON, bungkus sebagai message
        return {'message': responseText};
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
