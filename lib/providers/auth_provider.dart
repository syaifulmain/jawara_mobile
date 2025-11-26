import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;

  final AuthService _apiService = AuthService();

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null && _token != null;
  bool get isInitialized => _isInitialized;

  // Initialize and check for saved session
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');
      final savedUserData = prefs.getString('user_data');

      if (savedToken != null && savedUserData != null) {
        _token = savedToken;
        _currentUser = UserModel.fromJson(jsonDecode(savedUserData));

        // Verify token is still valid by fetching fresh user data
        try {
          final user = await _apiService.getUserProfile(_token!);
          _currentUser = user;
          await _saveSession();
        } catch (e) {
          // Token expired or invalid, clear session
          await clearSession();
        }
      }
    } catch (e) {
      await clearSession();
    }

    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
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
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await _apiService.logout(_token!);
      }
    } catch (e) {
      // Ignore logout errors
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
}
