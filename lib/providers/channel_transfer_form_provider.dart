// dart
import 'package:flutter/material.dart';
import 'package:jawara_mobile/models/channel_transfer_model.dart';

class ChannelTransferFormProvider extends ChangeNotifier {
  // Controllers for text fields
  final TextEditingController namaChannelController = TextEditingController();
  final TextEditingController nomorRekeningController = TextEditingController();
  final TextEditingController namaPemilikController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  // Selected tipe label (UI uses labels)
  String? _selectedTipeLabel;

  // Single-file paths (nullable)
  String? _qrPath;
  String? _thumbnailPath;

  // Expose tipe options (labels)
  final List<String> tipeOptions = Tipe.getValuesAsStringList();

  // Getters
  String? get selectedTipeLabel => _selectedTipeLabel;

  Tipe? get selectedTipeEnum {
    if (_selectedTipeLabel == null) return null;
    return Tipe.values.firstWhere(
          (t) => t.label == _selectedTipeLabel,
      orElse: () => Tipe.bank,
    );
  }

  String? get qrPath => _qrPath;
  String? get thumbnailPath => _thumbnailPath;

  // Setters with notify
  void setSelectedTipeLabel(String? label) {
    _selectedTipeLabel = label;
    notifyListeners();
  }

  void setQrPath(String? path) {
    _qrPath = path;
    notifyListeners();
  }

  void setThumbnailPath(String? path) {
    _thumbnailPath = path;
    notifyListeners();
  }

  // Validation: required fields must be non-empty
  bool get isFormValid {
    return namaChannelController.text.trim().isNotEmpty &&
        _selectedTipeLabel != null &&
        nomorRekeningController.text.trim().isNotEmpty &&
        namaPemilikController.text.trim().isNotEmpty;
  }

  // Build ChannelTransferModel from current form state
  ChannelTransferModel getFormData() {
    final tipeEnum = selectedTipeEnum ?? Tipe.bank;
    return ChannelTransferModel(
      namaChannel: namaChannelController.text.trim(),
      tipe: tipeEnum,
      nomorRekening: nomorRekeningController.text.trim(),
      namaPemilik: namaPemilikController.text.trim(),
      QRPath: _qrPath ?? '',
      thumbnailPath: _thumbnailPath ?? '',
      catatan: catatanController.text.trim().isEmpty
          ? null
          : catatanController.text.trim(),
    );
  }

  // Reset form to initial state
  void resetForm() {
    namaChannelController.clear();
    nomorRekeningController.clear();
    namaPemilikController.clear();
    catatanController.clear();
    _selectedTipeLabel = null;
    _qrPath = null;
    _thumbnailPath = null;
    notifyListeners();
  }

  @override
  void dispose() {
    namaChannelController.dispose();
    nomorRekeningController.dispose();
    namaPemilikController.dispose();
    catatanController.dispose();
    super.dispose();
  }
}
