import 'package:jawara_mobile_v2/constants/api_constant.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_list_model.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_request_model.dart';
import 'package:jawara_mobile_v2/services/api_exception.dart';
import 'package:jawara_mobile_v2/services/base_api_service.dart';

class FamilyRelocationService extends BaseApiService {
  Future<List<FamilyRelocationListModel>> getFamilyRelocations(
    String token,
  ) async {
    final body = await request(
      url: ApiConstants.familyRelocations,
      method: 'GET',
      token: token,
    );

    final List<dynamic> data = body?['data'] ?? [];
    return data.map((e) => FamilyRelocationListModel.fromJson(e)).toList();
  }

  Future<List<FamilyRelocationListModel>> searchFamilyRelocations(
    String token,
    String query,
  ) async {
    final body = await request(
      url: ApiConstants.familyRelocations,
      method: 'GET',
      token: token,
      queryParameters: {'search': query},
    );

    final List<dynamic> data = body?['data'] ?? [];
    return data.map((e) => FamilyRelocationListModel.fromJson(e)).toList();
  }

  Future<FamilyRelocationListModel> getDetail(String token, String id) async {
    final body = await request(
      url: '${ApiConstants.familyRelocations}/$id',
      method: 'GET',
      token: token,
    );

    // print('Response body: $body'); // Debug

    if (body == null || body['data'] == null) {
      throw ApiException('Data tidak ditemukan');
    }

    return FamilyRelocationListModel.fromJson(body['data']);
  }

  Future<void> create(String token, FamilyRelocationRequestModel req) async {
    await request(
      url: ApiConstants.familyRelocations,
      method: 'POST',
      token: token,
      body: req.toJson(),
      allowedStatusCodes: [200, 201],
    );
  }
}
