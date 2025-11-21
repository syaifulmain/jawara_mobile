import 'package:flutter/material.dart';

class PemasukanFormProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jenisPemasukanController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  
  // Form state
  String? _selectedJenisPemasukan;
  DateTime? _selectedDate;
  List<String> _selectedPhotos = [];
  
  // Getters
  String? get selectedJenisPemasukan => _selectedJenisPemasukan;
  DateTime? get selectedDate => _selectedDate;
  List<String> get selectedPhotos => List.from(_selectedPhotos);
  
  // JenisPemasukan Pemasukan options
  final List<String> jenisPemasukanOptions = [
    'Donasi',
    'Dana Bantuan Pemerintah',
    'Sumbangan Swadaya',
    'Hasil Usaha Kampung',
    'Pendapatan Lainnya',
  ];
  
  // Setters
  void setSelectedJenisPemasukan(String? jenisPemasukan) {
    _selectedJenisPemasukan = jenisPemasukan;
    notifyListeners();
  }
  
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    if (date != null) {
      tanggalController.text = "${date.day}/${date.month}/${date.year}";
    } else {
      tanggalController.clear();
    }
    notifyListeners();
  }
  
  void addPhoto(String photoPath) {
    _selectedPhotos.add(photoPath);
    notifyListeners();
  }
  
  void addPhotos(List<String> photoPaths) {
    _selectedPhotos.addAll(photoPaths);
    notifyListeners();
  }
  
  void removePhoto(int index) {
    if (index >= 0 && index < _selectedPhotos.length) {
      _selectedPhotos.removeAt(index);
      notifyListeners();
    }
  }
  
  void clearSelectedPhotos() {
    _selectedPhotos.clear();
    notifyListeners();
  }
  
  // Form validation
  bool get isFormValid {
    return namaController.text.trim().isNotEmpty &&
           _selectedJenisPemasukan != null &&
           _selectedDate != null &&
           nominalController.text.trim().isNotEmpty;
  }
  
  // Reset form
  void resetForm() {
    namaController.clear();
    jenisPemasukanController.clear();
    nominalController.clear();
    tanggalController.clear();
    _selectedJenisPemasukan = null;
    _selectedDate = null;
    _selectedPhotos.clear();
    notifyListeners();
  }
  
  // Get form data as Map
  Map<String, dynamic> getFormData() {
    return {
      'namaPemasukan': namaController.text.trim(),
      'jenisPemasukan': _selectedJenisPemasukan,
      'tanggal': _selectedDate,
      'nominal': nominalController.text.trim(),
      'photos': List.from(_selectedPhotos),
    };
  }
  
  @override
  void dispose() {
    namaController.dispose();
    jenisPemasukanController.dispose();
    nominalController.dispose();
    tanggalController.dispose();
    super.dispose();
  }
}