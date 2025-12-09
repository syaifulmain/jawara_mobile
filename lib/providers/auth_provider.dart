import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user/update_user_request_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_exception.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  final AuthService _apiService = AuthService();

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null && _token != null;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  // Initialize and check for saved session
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');
      final savedUserData = prefs.getString('user_data');

      if (savedToken != null && savedUserData != null) {
        _token = savedToken;
        _currentUser = UserModel.fromJson(jsonDecode(savedUserData));

        // Session restored successfully
        _isInitialized = true;
        _isLoading = false;
        notifyListeners();

        // Optionally verify token in background (non-blocking)
        _verifyTokenInBackground();
      } else {
        // No saved session
        _isInitialized = true;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Initialization error: $e';
      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verify token validity in background without blocking UI
  Future<void> _verifyTokenInBackground() async {
    if (_token == null) return;

    try {
      final user = await _apiService.getUserProfile(_token!);
      _currentUser = user;
      await _saveSession();
      notifyListeners();
    } catch (e) {
      // Token invalid or expired, clear session
      if (e is ApiException && e.statusCode == 401) {
        await clearSession();
        notifyListeners();
      }
      // For other errors, keep existing session
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      _token = response['token'];
      _currentUser = UserModel.fromJson(response['user']);

      await _saveSession();


      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Login error: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_token != null) {
        await _apiService.logout(_token!);
      }
    } catch (e) {
      // ignore logout errors
    }

    await clearSession();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    if (_currentUser != null && _token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
    }
  }

  Future<void> clearSession() async {
    _currentUser = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  Future<bool> updateUser(String token, String id, UpdateUserRequestModel req) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _apiService.updateProfile(token, id, req);
      // persist or update list if needed
      _isLoading = false;
      notifyListeners();
      _verifyTokenInBackground();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Update error: $e';
      }
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
