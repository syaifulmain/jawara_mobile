import 'dart:io';

import 'package:flutter/material.dart';
import '../models/broadcast_model.dart';
import '../services/broadcast_service.dart';
import '../services/api_exception.dart';

class BroadcastProvider with ChangeNotifier {
  List<Broadcast> _broadcasts = [];
  Broadcast? _selectedBroadcast;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final BroadcastService _broadcastService = BroadcastService();

  List<Broadcast> get broadcasts => _broadcasts;
  Broadcast? get selectedBroadcast => _selectedBroadcast;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchBroadcasts(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _broadcasts = await _broadcastService.getBroadcasts(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data broadcast';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBroadcastById(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedBroadcast = await _broadcastService.getBroadcastById(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail broadcast';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBroadcast(
      String token,
      Broadcast broadcast, {
        File? photoFile,
        File? documentFile,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBroadcast = await _broadcastService.createBroadcast(
        token,
        broadcast,
        photoFile: photoFile,
        documentFile: documentFile,
      );
      _broadcasts.insert(0, newBroadcast);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal membuat broadcast';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  Future<bool> updateBroadcast(String token, String id, Broadcast broadcast) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedBroadcast = await _broadcastService.updateBroadcast(token, id, broadcast);
      final index = _broadcasts.indexWhere((b) => b.id.toString() == id);
      if (index != -1) {
        _broadcasts[index] = updatedBroadcast;
      }
      if (_selectedBroadcast?.id.toString() == id) {
        _selectedBroadcast = updatedBroadcast;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memperbarui broadcast';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBroadcast(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _broadcastService.deleteBroadcast(token, id);
      _broadcasts.removeWhere((broadcast) => broadcast.id.toString() == id);
      if (_selectedBroadcast?.id.toString() == id) {
        _selectedBroadcast = null;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menghapus broadcast';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> searchBroadcasts(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _broadcasts = await _broadcastService.searchBroadcasts(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari broadcast';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBroadcastsThisWeek(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _broadcasts = await _broadcastService.getBroadcastsThisWeek(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil broadcast minggu ini';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedBroadcast() {
    _selectedBroadcast = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
