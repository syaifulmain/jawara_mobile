import 'dart:io';
import 'package:flutter/material.dart';
import '../models/fruit/fruit_classification_model.dart';
import '../models/fruit/fruit_image_model.dart';
import '../services/fruit_image_service.dart';
import '../services/api_exception.dart';

class FruitImageProvider with ChangeNotifier {
  final FruitImageService _fruitImageService = FruitImageService();

  List<FruitImage> _fruitImages = [];
  FruitClassification? _lastClassification;
  bool _isLoading = false;
  bool _isClassifying = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<FruitImage> get fruitImages => _fruitImages;
  FruitClassification? get lastClassification => _lastClassification;
  bool get isLoading => _isLoading;
  bool get isClassifying => _isClassifying;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  /// Classify fruit image
  Future<bool> classifyFruit(File imageFile) async {
    _isClassifying = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastClassification = await _fruitImageService.classifyFruit(imageFile);
      _isClassifying = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal mengklasifikasi gambar: $e';
      }
      _isClassifying = false;
      notifyListeners();
      return false;
    }
  }

  /// Save fruit image to server
  Future<FruitImage?> saveFruitImage(
    String token, {
    required String name,
    required int familyId,
    required File imageFile,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fruitImage = await _fruitImageService.saveFruitImage(
        token,
        name: name,
        familyId: familyId,
        imageFile: imageFile,
      );
      _fruitImages.insert(0, fruitImage);
      _isSaving = false;
      notifyListeners();
      return fruitImage;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menyimpan gambar: $e';
      }
      _isSaving = false;
      notifyListeners();
      return null;
    }
  }

  /// Fetch all fruit images
  Future<void> fetchFruitImages(String token, {int? familyId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _fruitImages = await _fruitImageService.getFruitImages(
        token,
        familyId: familyId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal memuat daftar gambar: $e';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete fruit image
  Future<bool> deleteFruitImage(String token, int id) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _fruitImageService.deleteFruitImage(token, id);
      _fruitImages.removeWhere((image) => image.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Gagal menghapus gambar: $e';
      }
      notifyListeners();
      return false;
    }
  }

  /// Clear last classification result
  void clearClassification() {
    _lastClassification = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
