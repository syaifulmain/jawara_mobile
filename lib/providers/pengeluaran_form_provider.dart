import 'package:flutter/material.dart';

class PengeluaranFormProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  
  // Form state
  String? _selectedKategoriPengeluaran;
  DateTime? _selectedDate;
  List<String> _selectedPhotos = [];
  
  // Getters
  String? get selectedKategoriPengeluaran => _selectedKategoriPengeluaran;
  DateTime? get selectedDate => _selectedDate;
  List<String> get selectedPhotos => List.from(_selectedPhotos);
  
  // Kategori Pengeluaran options
  final List<String> kategoriPengeluaranOptions = [
    'Operasional',
    'Pemeliharaan',
    'Keamanan',
    'Kebersihan',
    'Administrasi',
    'Kegiatan Warga',
    'Pengeluaran Lainnya',
  ];
  
  // Setters
  void setSelectedKategoriPengeluaran(String? kategoriPengeluaran) {
    _selectedKategoriPengeluaran = kategoriPengeluaran;
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
           _selectedKategoriPengeluaran != null &&
           _selectedDate != null &&
           nominalController.text.trim().isNotEmpty;
  }
  
  // Reset form
  void resetForm() {
    namaController.clear();
    nominalController.clear();
    tanggalController.clear();
    _selectedKategoriPengeluaran = null;
    _selectedDate = null;
    _selectedPhotos.clear();
    notifyListeners();
  }
  
  // Get form data as Map
  Map<String, dynamic> getFormData() {
    return {
      'namaPengeluaran': namaController.text.trim(),
      'kategoriPengeluaran': _selectedKategoriPengeluaran,
      'tanggal': _selectedDate,
      'nominal': nominalController.text.trim(),
      'photos': List.from(_selectedPhotos),
    };
  }
  
  @override
  void dispose() {
    namaController.dispose();
    nominalController.dispose();
    tanggalController.dispose();
    super.dispose();
  }
}