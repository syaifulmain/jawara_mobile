import 'package:flutter/material.dart';

class PengeluaranFormProvider extends ChangeNotifier {
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _buktiController = TextEditingController();

  String? _selectedKategori;
  DateTime? _selectedDate;

  // Getters
  TextEditingController get kategoriController => _kategoriController;
  TextEditingController get nominalController => _nominalController;
  TextEditingController get tanggalController => _tanggalController;
  TextEditingController get keteranganController => _keteranganController;
  TextEditingController get buktiController => _buktiController;

  String? get selectedKategori => _selectedKategori;
  DateTime? get selectedDate => _selectedDate;

  // Form validation
  bool get isFormValid {
    return _kategoriController.text.isNotEmpty &&
           _nominalController.text.isNotEmpty &&
           _tanggalController.text.isNotEmpty &&
           _keteranganController.text.isNotEmpty;
  }

  // Setters
  void setKategori(String? kategori) {
    _selectedKategori = kategori;
    _kategoriController.text = kategori ?? '';
    notifyListeners();
  }

  void setNominal(String nominal) {
    _nominalController.text = nominal;
    notifyListeners();
  }

  void setTanggal(DateTime? date) {
    _selectedDate = date;
    if (date != null) {
      _tanggalController.text = "${date.day}/${date.month}/${date.year}";
    }
    notifyListeners();
  }

  void setKeterangan(String keterangan) {
    _keteranganController.text = keterangan;
    notifyListeners();
  }

  void setBukti(String bukti) {
    _buktiController.text = bukti;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    _kategoriController.clear();
    _nominalController.clear();
    _tanggalController.clear();
    _keteranganController.clear();
    _buktiController.clear();
    _selectedKategori = null;
    _selectedDate = null;
    notifyListeners();
  }

  // Get form data
  Map<String, dynamic> getFormData() {
    return {
      'kategori': _kategoriController.text,
      'nominal': _nominalController.text,
      'tanggal': _tanggalController.text,
      'keterangan': _keteranganController.text,
      'bukti': _buktiController.text,
      'selectedDate': _selectedDate,
    };
  }

  @override
  void dispose() {
    _kategoriController.dispose();
    _nominalController.dispose();
    _tanggalController.dispose();
    _keteranganController.dispose();
    _buktiController.dispose();
    super.dispose();
  }
}