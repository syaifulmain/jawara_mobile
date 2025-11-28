import 'package:flutter/material.dart';
import '../enums/activity_category.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';
import '../services/api_exception.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [];
  Activity? _selectedActivity;
  bool _isLoading = false;
  String? _errorMessage;
  ActivityCategory? _selectedCategory;
  String _searchQuery = '';


  final ActivityService _activityService = ActivityService();

  List<Activity> get activities => _activities;
  Activity? get selectedActivity => _selectedActivity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ActivityCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Activity> get filteredActivities {
    if (_selectedCategory != null) {
      return _activities
          .where((activity) => activity.category == _selectedCategory)
          .toList();
    }
    return _activities;
  }

  Future<void> fetchActivities(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _activityService.getActivities(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data aktivitas';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActivityById(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedActivity = await _activityService.getActivityById(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail aktivitas';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createActivity(String token, Activity activity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newActivity = await _activityService.createActivity(token, activity);
      _activities.insert(0, newActivity);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal membuat aktivitas';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateActivity(String token, String id, Activity activity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedActivity = await _activityService.updateActivity(token, id, activity);
      final index = _activities.indexWhere((a) => a.id == id);
      if (index != -1) {
        _activities[index] = updatedActivity;
      }
      if (_selectedActivity?.id == id) {
        _selectedActivity = updatedActivity;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memperbarui aktivitas';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteActivity(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _activityService.deleteActivity(token, id);
      _activities.removeWhere((activity) => activity.id == id);
      if (_selectedActivity?.id == id) {
        _selectedActivity = null;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menghapus aktivitas';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchActivitiesByCategory(String token, ActivityCategory category) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedCategory = category;
    notifyListeners();

    try {
      _activities = await _activityService.getActivitiesByCategory(token, category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil aktivitas berdasarkan kategori';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchActivities(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _activities = await _activityService.searchActivities(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari aktivitas';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActivitiesByCategoryOrDate(String token, {ActivityCategory? category, DateTime? date}) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedCategory = category;
    notifyListeners();

    try {
      _activities = await _activityService.getActivitiesByCategoryOrDate(token, category: category, date: date);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil aktivitas berdasarkan kategori atau tanggal';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedActivity() {
    _selectedActivity = null;
    notifyListeners();
  }

  void clearFilter() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}