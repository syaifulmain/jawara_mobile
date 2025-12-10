import 'package:flutter/material.dart';
import '../models/financial_report_model.dart';
import '../services/financial_report_service.dart';
import '../services/api_exception.dart';

class FinancialReportProvider with ChangeNotifier {
  FinancialReport? _report;
  bool _isLoading = false;
  String? _errorMessage;

  final FinancialReportService _service = FinancialReportService();

  FinancialReport? get report => _report;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReport(
      String token, {
        required DateTime startDate,
        required DateTime endDate,
        required String type,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _report = await _service.getFinancialReport(
        token,
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil laporan keuangan';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearReport() {
    _report = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
