import 'package:flutter/material.dart';
import '../models/resident/resident_list_model.dart';
import '../models/resident/resident_detail_model.dart';
import '../models/resident/resident_request_model.dart';
import '../services/resident_service.dart';
import '../services/api_exception.dart';

class ResidentProvider with ChangeNotifier {
  List<ResidentListModel> _residents = [];
  ResidentDetailModel? _selectedResident;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final ResidentService _residentService = ResidentService();

  List<ResidentListModel> get residents => _residents;
  ResidentDetailModel? get selectedResident => _selectedResident;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchResidents(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _residents = await _residentService.getResidents(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data penduduk';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchResidents(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _residents = await _residentService.searchResidents(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari data penduduk';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchResidentDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedResident = null;
    notifyListeners();

    try {
      _selectedResident = await _residentService.getResidentDetail(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail penduduk';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createResident(String token, ResidentRequestModel request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _residentService.createResident(token, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambahkan penduduk';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateResident(String token, String id, ResidentRequestModel request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _residentService.updateResident(token, id, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memperbarui penduduk';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearSelectedResident() {
    _selectedResident = null;
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
