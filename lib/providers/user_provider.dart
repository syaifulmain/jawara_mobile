import 'package:flutter/material.dart';
import '../models/user/user_list_model.dart';
import '../models/user/user_detail_model.dart';
import '../services/user_service.dart';
import '../services/api_exception.dart';

class UserProvider with ChangeNotifier {
  List<UserListModel> _users = [];
  UserDetailModel? _selectedUser;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final UserService _userService = UserService();

  List<UserListModel> get users => _users;
  UserDetailModel? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchUsers(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userService.getUsers(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data pengguna';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUsers(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _users = await _userService.searchUsers(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari data pengguna';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedUser = null;
    notifyListeners();

    try {
      _selectedUser = await _userService.getUserDetail(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail pengguna';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedUser() {
    _selectedUser = null;
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
