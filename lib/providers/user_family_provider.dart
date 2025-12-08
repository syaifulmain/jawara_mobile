import 'package:flutter/material.dart';
import '../models/family/family_detail_model.dart';
import '../services/family_service.dart';
import '../services/api_exception.dart';

class UserFamilyProvider with ChangeNotifier {
  FamilyDetailModel? _selectedFamily;
  bool _isLoading = false;
  String? _errorMessage;

  final FamilyService _familyService = FamilyService();

  FamilyDetailModel? get selectedFamily => _selectedFamily;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyFamily(String token) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedFamily = null;
    notifyListeners();

    try {
      _selectedFamily = await _familyService.getMyFamily(token);
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
