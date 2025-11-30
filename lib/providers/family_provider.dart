import 'package:flutter/material.dart';
import '../models/family/family_list_model.dart';
import '../models/family/family_detail_model.dart';
import '../services/family_service.dart';
import '../services/api_exception.dart';

class FamilyProvider with ChangeNotifier {
  List<FamilyListModel> _families = [];
  FamilyDetailModel? _selectedFamily;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final FamilyService _familyService = FamilyService();

  List<FamilyListModel> get families => _families;
  FamilyDetailModel? get selectedFamily => _selectedFamily;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchFamilies(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _families = await _familyService.getFamilies(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data keluarga';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchFamilies(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _families = await _familyService.searchFamilies(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari data keluarga';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFamilyDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedFamily = null;
    notifyListeners();

    try {
      _selectedFamily = await _familyService.getFamilyDetail(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail keluarga';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedFamily() {
    _selectedFamily = null;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
