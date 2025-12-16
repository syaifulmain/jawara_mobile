import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constants/api_constant.dart';
import '../models/fruit/fruit_classification_model.dart';
import '../models/fruit/fruit_image_model.dart';
import 'api_exception.dart';

class FruitImageService {
  /// Classify fruit image using external API
  Future<FruitClassification> classifyFruit(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.klasifikasiBuah),
      );

      // Get file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      final contentType = _getContentType(extension);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: contentType,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return FruitClassification.fromJson(body);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to classify fruit (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Save fruit image to server
  Future<FruitImage> saveFruitImage(
    String token, {
    required String name,
    required int familyId,
    required File imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.fruitImgages),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['name'] = name;
      request.fields['family_id'] = familyId.toString();

      // Get file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      final contentType = _getContentType(extension);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: contentType,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return FruitImage.fromJson(body['data']);
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to save fruit image (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Get all fruit images for a family
  Future<List<FruitImage>> getFruitImages(String token, {int? familyId}) async {
    try {
      final uri = familyId != null
          ? Uri.parse(
              ApiConstants.fruitImgages,
            ).replace(queryParameters: {'family_id': familyId.toString()})
          : Uri.parse(ApiConstants.fruitImgages);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'];
        return data.map((json) => FruitImage.fromJson(json)).toList();
      } else {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to get fruit images (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Delete fruit image
  Future<void> deleteFruitImage(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.fruitImgages}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode != 200 && response.statusCode != 204) {
        final msg = body != null && body['message'] != null
            ? body['message'].toString()
            : 'Failed to delete fruit image (${response.statusCode})';
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Helper method to get content type based on file extension
  MediaType _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('image', 'jpeg'); // Default to jpeg
    }
  }
}
