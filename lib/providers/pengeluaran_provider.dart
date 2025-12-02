import 'package:flutter/material.dart';
import '../models/pengeluaran/pengeluaran_list_model.dart';
import '../models/pengeluaran/pengeluaran_request_model.dart';
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

  /// UTILS
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
