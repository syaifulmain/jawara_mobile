import 'package:flutter/material.dart';
import '../models/income/income_list_model.dart';
import '../services/income_service.dart';
import '../services/api_exception.dart';

class IncomeProvider with ChangeNotifier {
  List<IncomeListModel> _incomes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final IncomeService _incomeService = IncomeService();

  List<IncomeListModel> get incomes => _incomes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchIncomes(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _incomes = await _incomeService.getIncomes(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data pemasukan';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchIncomes(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _incomes = await _incomeService.searchIncomes(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari data pemasukan';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createIncome(String token, dynamic request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _incomeService.createIncome(token, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambahkan pemasukan';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
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
