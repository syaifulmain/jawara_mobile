import 'package:flutter/material.dart';
import '../models/address/address_list_model.dart';
import '../models/address/address_detail_model.dart';
import '../models/address/address_request_model.dart';
import '../services/address_service.dart';
import '../services/api_exception.dart';

class AddressProvider with ChangeNotifier {
  List<AddressListModel> _addresses = [];
  AddressDetailModel? _selectedAddress;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final AddressService _addressService = AddressService();

  List<AddressListModel> get addresses => _addresses;
  AddressDetailModel? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchAddresses(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _addresses = await _addressService.getAddresses(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil data alamat';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchAddresses(String token, String query) async {
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = query;
    notifyListeners();

    try {
      _addresses = await _addressService.searchAddresses(token, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mencari alamat';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAddressDetail(String token, String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedAddress = null;
    notifyListeners();

    try {
      _selectedAddress = await _addressService.getAddressDetail(token, id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengambil detail alamat';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAddress(String token, AddressRequestModel request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _addressService.createAddress(token, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menambahkan alamat';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearSelectedAddress() {
    _selectedAddress = null;
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
