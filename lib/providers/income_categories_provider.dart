import 'package:flutter/material.dart';
import '../enums/income_type.dart';
import '../models/income/income_categories_model.dart';
import '../services/income_categories_service.dart';
import '../services/api_exception.dart';

class IncomeCategoriesProvider with ChangeNotifier {
  List<IncomeCategories> _categories = [];
  IncomeCategories? _selectedCategories;
  bool _isLoading = false;
  String? _errorMessage;
  IncomeType? _selectedType;
  String _searchQuery = '';


  final IncomeCategoriesService _categoriesService = IncomeCategoriesService();

  List<IncomeCategories> get categories => _categories;
  IncomeCategories? get selectedCategories => _selectedCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  IncomeType? get selectedType => _selectedType;
  String get searchQuery => _searchQuery;

  List<IncomeCategories> get filteredCategories {
    if (_selectedCategories != null) {
      return _categories
          .where((category) => category == _selectedCategories)
          .toList();
    }
    return _categories;
  }

  Future<void> fetchCategories(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _categoriesService.getCategories(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data kategori iuran';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategoryById(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedCategories = await _categoriesService.getCategoryById(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail kategori iuran';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCategory(String token, IncomeCategories category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCategory = await _categoriesService.createCategory(token, category);
      _categories.insert(0, newCategory);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal membuat kategori iuran';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategories(String token, String id, IncomeCategories category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCategories = await _categoriesService.updateCategories(token, id, category);
      final index = _categories.indexWhere((a) => a.id == id);
      if (index != -1) {
        _categories[index] = updatedCategories;
      }
      if (_selectedCategories?.id == id) {
        _selectedCategories = updatedCategories;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memperbarui kategori iuran';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategories(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _categoriesService.deleteCategories(token, id);
      _categories.removeWhere((categories) => categories.id == id);
      if (_selectedCategories?.id == id) {
        _selectedCategories = null;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menghapus kategori iuran';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchCategoriesByType(String token, IncomeType type) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedType = type;
    notifyListeners();

    try {
      _categories = await _categoriesService.getIncomeByType(token, type);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil iuran berdasarkan kategori';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCategories(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _categories = await _categoriesService.searchCategories(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari iuran';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategoriesByTypeOrDate(String token, {IncomeType? type, DateTime? date}) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedType = type;
    notifyListeners();

    try {
      _categories = await _categoriesService.getCategoriesByTypeOrDate(token, type: type, date: date);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil iuran berdasarkan kategori atau tanggal';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedCategories() {
    _selectedCategories = null;
    notifyListeners();
  }

  void clearFilter() {
    _selectedType = null;
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}