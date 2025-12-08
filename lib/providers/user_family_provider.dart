import 'package:flutter/material.dart';
import '../models/family/family_detail_model.dart';
import '../services/user_family_service.dart';
import '../services/api_exception.dart';

class UserFamilyProvider with ChangeNotifier {
  FamilyDetailModel? _myFamily;
  FamilyDetailModel? _selectedFamily; // <-- untuk detail keluarga
  bool _isLoading = false;
  String? _errorMessage;

  final UserFamilyService _service = UserFamilyService();

  FamilyDetailModel? get myFamily => _myFamily;
  FamilyDetailModel? get selectedFamily => _selectedFamily; // <-- getter baru
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Ambil data keluarga user (my family)
  Future<void> fetchMyFamily(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myFamily = await _service.getMyFamily(token);
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

  // Ambil detail keluarga berdasarkan ID
  Future<void> fetchFamilyDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedFamily = await _service.getFamilyDetail(token, id);
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

  // Tambah anggota keluarga
  Future<void> addFamilyMember(
    String token,
    Map<String, dynamic> memberData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newMember = await _service.addFamilyMember(token, memberData);
      _myFamily?.familyMembers.add(newMember);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambah anggota keluarga';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
