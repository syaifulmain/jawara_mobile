import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara_mobile/riverpod_providers/pengeluaran/notifiers/pengeluaran_notifiers.dart';


class TambahPengeluaranScreen extends ConsumerStatefulWidget {
  static const routeName = '/tambah-pengeluaran';

  const TambahPengeluaranScreen({super.key});

  @override
  ConsumerState<TambahPengeluaranScreen> createState() =>
      _TambahPengeluaranScreenState();
}

class _TambahPengeluaranScreenState
    extends ConsumerState<TambahPengeluaranScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _kategoriCtrl = TextEditingController();
  final _nominalCtrl = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  XFile? _pickedBukti;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaCtrl.dispose();
    _kategoriCtrl.dispose();
    _nominalCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickBukti() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedBukti = picked);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaCtrl.clear();
    _kategoriCtrl.clear();
    _nominalCtrl.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _pickedBukti = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaCtrl.text.trim();
    final kategori = _kategoriCtrl.text.trim();
    final nominalStr = _nominalCtrl.text.trim();

    final nominal = int.tryParse(nominalStr.replaceAll(RegExp(r'[^0-9]'), ''));

    if (nominal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal harus berupa angka valid')),
      );
      return;
    }

    // Tambah ke provider
    ref.read(pengeluaranProvider.notifier).tambah(
      nama: nama,
      kategori: kategori,
      tanggal: _selectedDate,
      nominal: nominal,
      buktiPath: _pickedBukti?.path,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengeluaran ditambahkan')),
    );

    // Reset form setelah submit
    _resetForm();

    // Opsional: kembali ke daftar
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // bisa membaca list jika mau menampilkan preview jumlah
    final list = ref.watch(pengeluaranProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Pengeluaran Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nama Pengeluaran',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _namaCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Masukkan nama pengeluaran',
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Tanggal Pengeluaran',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _pickTanggal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(
                            _selectedDate.toLocal().toIso8601String().split('T')[0]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Kategori Pengeluaran',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _kategoriCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Masukkan kategori pengeluaran',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Kategori wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Nominal Pengeluaran',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nominalCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Masukkan nominal pengeluaran',
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nominal wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Bukti Pengeluaran (opsional)',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickBukti,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _pickedBukti == null
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.upload_file, size: 36),
                            SizedBox(height: 8),
                            Text('Klik untuk mengunggah bukti pengeluaran'),
                          ],
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_pickedBukti!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  // preview kecil: total item (opsional)
                  const SizedBox(height: 12),
                  Text('Total pengeluaran tersimpan: ${list.length}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
