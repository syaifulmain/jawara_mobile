import 'package:flutter/material.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_detail_model.dart';
import '../models/transfer_channel/transfer_channel_list_model.dart';
import '../services/transfer_channel_service.dart';
import '../services/api_exception.dart';

class TransferChannelProvider with ChangeNotifier {
  List<TransferChannelListModel> _transferChannels = [];
  TransferChannelDetailModel? _selectedTransferChannel;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final TransferChannelService _transferChannelService =
      TransferChannelService();

  List<TransferChannelListModel> get transferChannels => _transferChannels;
  TransferChannelDetailModel? get selectedTransferChannel =>
      _selectedTransferChannel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchTransferChannels(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transferChannels = await _transferChannelService.getTransferChannels(
        token,
      );
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
      _transferChannels = await _transferChannelService.searchTransferChannels(
        token,
        query,
      );
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

  Future<void> fetchTransferChannelDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedTransferChannel = null;
    notifyListeners();

    try {
      _selectedTransferChannel = await _transferChannelService
          .getTransferChannelDetail(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail saluran transfer';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createResident(
    String token,
    TransferChannelDetailModel request,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _transferChannelService.createTransferChannel(token, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambahkan penduduk';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTransferChannel(
    String token,
    String id,
    TransferChannelDetailModel request,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _transferChannelService.updateTransferChannel(token, id, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memperbarui saluran transfer';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearSelectedTransferChannel() {
    _selectedTransferChannel = null;
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
