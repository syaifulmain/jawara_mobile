import 'package:flutter/material.dart';

class KegiatanFormProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController namaKegiatanController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController penanggungJawabController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  
  // Form state
  String? _selectedKategori;
  DateTime? _selectedDate;
  List<String> _selectedPhotos = [];
  
  // Getters
  String? get selectedKategori => _selectedKategori;
  DateTime? get selectedDate => _selectedDate;
  List<String> get selectedPhotos => List.from(_selectedPhotos);
  
  // Kategori kegiatan options
  final List<String> kategoriOptions = [
    'Komunitas & Sosial',
    'Pendidikan',
    'Kesehatan',
    'Lingkungan',
    'Ekonomi',
    'Budaya',
    'Olahraga',
    'Keagamaan',
  ];
  
  // Setters
  void setSelectedKategori(String? kategori) {
    _selectedKategori = kategori;
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
    return namaKegiatanController.text.trim().isNotEmpty &&
           _selectedKategori != null &&
           _selectedDate != null &&
           lokasiController.text.trim().isNotEmpty &&
           penanggungJawabController.text.trim().isNotEmpty &&
           deskripsiController.text.trim().isNotEmpty;
  }
  
  // Reset form
  void resetForm() {
    namaKegiatanController.clear();
    lokasiController.clear();
    penanggungJawabController.clear();
    deskripsiController.clear();
    tanggalController.clear();
    _selectedKategori = null;
    _selectedDate = null;
    _selectedPhotos.clear();
    notifyListeners();
  }
  
  // Get form data as Map
  Map<String, dynamic> getFormData() {
    return {
      'namaKegiatan': namaKegiatanController.text.trim(),
      'kategori': _selectedKategori,
      'tanggal': _selectedDate,
      'lokasi': lokasiController.text.trim(),
      'penanggungJawab': penanggungJawabController.text.trim(),
      'deskripsi': deskripsiController.text.trim(),
      'photos': List.from(_selectedPhotos),
    };
  }
  
  @override
  void dispose() {
    namaKegiatanController.dispose();
    lokasiController.dispose();
    penanggungJawabController.dispose();
    deskripsiController.dispose();
    tanggalController.dispose();
    super.dispose();
  }
}