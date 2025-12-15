import 'package:flutter/material.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_detail_model.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_list_model.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_request_model.dart';
import 'package:jawara_mobile_v2/services/api_exception.dart';
import 'package:jawara_mobile_v2/services/family_relocation_service.dart';

class FamilyRelocationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _searchQuery = '';
  String? get searchQuery => _searchQuery;

  FamilyRelocationDetailModel? _selectedFamilyRelocation;
  FamilyRelocationDetailModel? get selectedFamilyRelocation =>
      _selectedFamilyRelocation;

  List<FamilyRelocationListModel> _familyRelocations = [];
  List<FamilyRelocationListModel> get familyRelocations => _familyRelocations;

  final FamilyRelocationService _familyRelocationService =
      FamilyRelocationService();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  Future<void> fetchFamilyRelocations(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _familyRelocations = await _familyRelocationService.getFamilyRelocations(
        token,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        // _errorMessage = 'Failed to fetch family relocations';
        _errorMessage = e.toString();
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchFamilyRelocations(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _familyRelocations = await _familyRelocationService
          .searchFamilyRelocations(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Failed to search family relocations';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFamilyRelocationDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedFamilyRelocation = null;
    notifyListeners();

    try {
      _selectedFamilyRelocation = await _familyRelocationService.getDetail(
        token,
        id,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail mutasi keluarga';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createFamilyRelocation(
    String token,
    FamilyRelocationRequestModel request,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _familyRelocationService.create(token, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambahkan mutasi keluarga';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
