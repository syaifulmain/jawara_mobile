import 'package:flutter/material.dart';
import '../models/transfer_channel/transfer_channel_list_model.dart';
import '../services/transfer_channel_service.dart';
import '../services/api_exception.dart';

class TransferChannelProvider with ChangeNotifier {
  List<TransferChannelListModel> _transferChannels = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final TransferChannelService _transferChannelService = TransferChannelService();

  List<TransferChannelListModel> get transferChannels => _transferChannels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchTransferChannels(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transferChannels = await _transferChannelService.getTransferChannels(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Failed to fetch transfer channels';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchTransferChannels(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _transferChannels = await _transferChannelService.searchTransferChannels(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Failed to search transfer channels';
      }
      _isLoading = false;
      notifyListeners();
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
