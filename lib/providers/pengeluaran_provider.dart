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

  // SET LOADING
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// FETCH LIST PENGELUARAN
  Future<void> fetchPengeluaran(
    String token, {
    String? search,
    String? kategori,
    String? startDate,
    String? endDate,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      _pengeluaran = await _pengeluaranService.getPengeluaranList(
        token,
        search: search,
        kategori: kategori,
        startDate: startDate,
        endDate: endDate,
      );

      setLoading(false);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'Gagal mengambil data pengeluaran';

      setLoading(false);
    }
  }

  /// SEARCH PENGELUARAN
  Future<void> searchPengeluaran(String token, String query) async {
    setLoading(true);
    _errorMessage = null;
    _searchQuery = query;

    try {
      _pengeluaran = await _pengeluaranService.getPengeluaranList(
        token,
        search: query,
      );
      setLoading(false);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'Gagal mencari data pengeluaran';
      setLoading(false);
    }
  }

  /// CREATE PENGELUARAN
  Future<bool> createPengeluaran(
    String token,
    PengeluaranRequestModel request,
  ) async {
    setLoading(true);
    _errorMessage = null;

    try {
      await _pengeluaranService.createPengeluaran(token, request);
      setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'Gagal menambahkan pengeluaran';

      setLoading(false);
      return false;
    }
  }

  // Detail
  PengeluaranDetailModel? _selectedPengeluaran;
  PengeluaranDetailModel? get selectedPengeluaran => _selectedPengeluaran;

  Future<void> fetchPengeluaranDetail(String token, String id) async {
    setLoading(true);
    _errorMessage = null;
    _selectedPengeluaran = null;

    try {
      _selectedPengeluaran = await _pengeluaranService.getPengeluaranDetail(
        token,
        id,
      );
      setLoading(false);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'Gagal mengambil detail pengeluaran';
      setLoading(false);
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

  /// FILTER
  void clearFilter() {
    _pengeluaran = [];
    _searchQuery = '';
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchPengeluaranByCategoryOrDate(
    String token, {
    String? category,
    DateTime? date,
  }) async {
    setLoading(true);
    _errorMessage = null;

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

      setLoading(false);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'Gagal memfilter data pengeluaran';
      setLoading(false);
    }
  }
}
