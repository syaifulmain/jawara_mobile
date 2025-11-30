import 'package:flutter/material.dart';

class KategoriIuranFormProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController namaIuranController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  // Form state
  String? _selectedJenisIuran;

  // Getters
  String? get selectedJenisIuran => _selectedJenisIuran;

  // Jenis Iuran options
  final List<String> jenisIuranOptions = ['Iuran Bulanan', 'Iuran Khusus'];

  // Setters
  void setSelectedJenisIuran(String? jenisIuran) {
    _selectedJenisIuran = jenisIuran;
    notifyListeners();
  }

  // Form validation
  bool get isFormValid {
    return namaIuranController.text.trim().isNotEmpty &&
        _selectedJenisIuran != null &&
        nominalController.text.trim().isNotEmpty;
  }

  // Reset form
  void resetForm() {
    namaIuranController.clear();
    nominalController.clear();
    _selectedJenisIuran = null;
    notifyListeners();
  }

  // Get form data as Map
  Map<String, dynamic> getFormData() {
    return {
      'namaIuran': namaIuranController.text.trim(),
      'jenisIuran': _selectedJenisIuran,
      'nominal': nominalController.text.trim(),
    };
  }

  @override
  void dispose() {
    namaIuranController.dispose();
    nominalController.dispose();
    super.dispose();
  }
}
