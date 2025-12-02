import 'package:flutter/material.dart';
import '../models/pengeluaran/pengeluaran_list_model.dart';
import '../models/pengeluaran/pengeluaran_request_model.dart';
import '../models/pengeluaran/pengeluaran_detail_model.dart';
import '../services/pengeluaran_service.dart';
import '../services/api_exception.dart';

class PengeluaranProvider with ChangeNotifier {
  List<PengeluaranListModel> _pengeluaran = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final PengeluaranService _pengeluaranService = PengeluaranService();

  // Getters
  List<PengeluaranListModel> get pengeluaran => _pengeluaran;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// FETCH LIST PENGELUARAN
  Future<void> fetchPengeluaran(
    String token, {
    String? search,
    String? kategori,
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pengeluaran = await _pengeluaranService.getPengeluaranList(
        token,
        search: search,
        kategori: kategori,
        startDate: startDate,
        endDate: endDate,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data pengeluaran';
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  /// SEARCH PENGELUARAN
  Future<void> searchPengeluaran(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _pengeluaran = await _pengeluaranService.getPengeluaranList(
        token,
        search: query,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari data pengeluaran';
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  /// CREATE PENGELUARAN
  Future<bool> createPengeluaran(
    String token,
    PengeluaranRequestModel request,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _pengeluaranService.createPengeluaran(token, request);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambahkan pengeluaran';
      }

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // property untuk detail
  PengeluaranDetailModel? _selectedPengeluaran;
  PengeluaranDetailModel? get selectedPengeluaran => _selectedPengeluaran;

  // fetch detail
  Future<void> fetchPengeluaranDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedPengeluaran = null;
    notifyListeners();

    try {
      _selectedPengeluaran = await _pengeluaranService.getPengeluaranDetail(
        token,
        id,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail pengeluaran';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  /// UTILS
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// ------------------ TAMBAHAN UNTUK FILTER ------------------

  /// Clear filter / reset pengeluaran
  void clearFilter() {
    _pengeluaran = [];
    _searchQuery = '';
    _errorMessage = null;
    notifyListeners();
  }

  /// Fetch pengeluaran by category and/or date
  Future<void> fetchPengeluaranByCategoryOrDate(
    String token, {
    String? category,
    DateTime? date,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? formattedDate = date != null
          ? date.toIso8601String().split('T').first
          : null;

      _pengeluaran = await _pengeluaranService.getPengeluaranList(
        token,
        kategori: category,
        startDate: formattedDate,
        endDate: formattedDate,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memfilter data pengeluaran';
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
