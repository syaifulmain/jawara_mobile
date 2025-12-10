import 'package:flutter/material.dart';
import '../models/dashboard/keuangan.dart';
import '../models/dashboard/kegiatan.dart';
import '../services/api_exception.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard/kependudukan.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service = DashboardService();

  bool _isLoading = false;
  String? _errorMessage;
  DashboardKeuanganData? _dashboardData;
  DashboardKegiatanData? _dashboardKegiatanData;
  DashboardKependudukanData? _dashboardKependudukanData;
  int _currentYear = DateTime.now().year;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardKeuanganData? get dashboardData => _dashboardData;
  DashboardKegiatanData? get dashboardKegiatanData => _dashboardKegiatanData;
  DashboardKependudukanData? get dashboardKependudukanData => _dashboardKependudukanData;
  int get currentYear => _currentYear;

  Future<void> fetchDashboardKependudukan(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getDashboardKependudukan(token);
      _dashboardKependudukanData = response.data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data dashboard kependudukan';
      }
      _dashboardKependudukanData = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDashboard(String token, {int? year}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getDashboardKeuangan(token, year: year);
      _dashboardData = response.data;
      if (year != null) {
        _currentYear = year;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data dashboard keuangan';
      }
      _dashboardData = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDashboardKegiatan(String token, {int? year}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getDashboardKegiatan(token, year: year);
      _dashboardKegiatanData = response.data;
      if (year != null) {
        _currentYear = year;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data dashboard kegiatan';
      }
      _dashboardKegiatanData = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeYear(String token, int year) {
    _currentYear = year;
    fetchDashboard(token, year: year);
  }

  void changeYearKegiatan(String token, int year) {
    _currentYear = year;
    fetchDashboardKegiatan(token, year: year);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
