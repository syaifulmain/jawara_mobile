import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/pengeluaran/pengeluaran_request_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/pengeluaran_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/file_picker_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/api_constant.dart';

class AddExpenditureScreen extends StatefulWidget {
  const AddExpenditureScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenditureScreen> createState() => _AddExpenditureScreenState();
}

class _AddExpenditureScreenState extends State<AddExpenditureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedKategori;
  File? _buktiFile;
  String? _buktiFileName;

  final List<String> _kategoriList = [
    'Operasional RT/RW',
    'Kegiatan Sosial',
    'Pemeliharaan Fasilitas',
    'Pembangunan',
    'Kegiatan Warga',
    'Keamanan & Kebersihan',
    'Lain-lain',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal pengeluaran harus dipilih')),
      );
      return;
    }

    if (_selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori pengeluaran harus dipilih')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final pengeluaranProvider = Provider.of<PengeluaranProvider>(
      context,
      listen: false,
    );

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Anda belum login')));
      return;
    }

    try {
      pengeluaranProvider.setLoading(true);

      final uri = Uri.parse(ApiConstants.pengeluaran);

      // Multipart request
      var request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] =
          'application/json'; // ⬅ Fix error <!DOCTYPE html>
      request.headers['Authorization'] = 'Bearer $token';

      // Format tanggal harus YYYY-MM-DD (untuk Laravel)
      final tanggalFormatted =
          "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      // Kirim field biasa
      request.fields['nama_pengeluaran'] = _namaController.text;
      request.fields['tanggal'] = tanggalFormatted;
      request.fields['kategori'] = _selectedKategori!;
      request.fields['nominal'] = _nominalController.text.trim();
      request.fields['verifikator'] = 'Admin';

      // Kirim file bila ada
      if (_buktiFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pengeluaran',
            _buktiFile!.path,
          ),
        );
      }

      // Kirim request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Cek apakah response bukan HTML
      if (response.body.startsWith('<!DOCTYPE html>')) {
        throw Exception(
          "Server mengembalikan HTML, kemungkinan salah endpoint atau middleware.",
        );
      }

      Map<String, dynamic>? body;

      try {
        body = jsonDecode(response.body);
      } catch (_) {
        body = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengeluaran berhasil ditambahkan')),
          );
          context.pop();
        }
        return;
      }

      // Jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body?['message'] ??
                  "Gagal menambahkan pengeluaran (${response.statusCode})",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      pengeluaranProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Buat Pengeluaran Baru',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<PengeluaranProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: _namaController,
                    labelText: "Nama Pengeluaran",
                    hintText: "Masukkan nama pengeluaran",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pengeluaran harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        labelText: "Tanggal Pengeluaran",
                        hintText: _selectedDate == null
                            ? 'Pilih tanggal'
                            : '${_selectedDate!.day.toString().padLeft(2, '0')} '
                                  '${_monthName(_selectedDate!.month)} '
                                  '${_selectedDate!.year}',
                        validator: (_) {
                          if (_selectedDate == null) {
                            return 'Tanggal pengeluaran harus dipilih';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: Rem.rem1),
                  DropdownButtonFormField<String>(
                    value: _selectedKategori,
                    decoration: InputDecoration(
                      labelText: "Kategori Pengeluaran",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                    ),
                    items: _kategoriList
                        .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedKategori = value),
                    validator: (value) {
                      if (value == null) {
                        return 'Kategori pengeluaran harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _nominalController,
                    labelText: "Nominal",
                    hintText: "Masukkan nominal",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nominal harus diisi';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Nominal harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  FilePickerButton(
                    file: _buktiFile,
                    fileName: _buktiFileName,
                    fileType: FileType.custom,
                    allowedExtensions: [
                      'jpg',
                      'jpeg',
                      'png',
                    ], // ✅ FIX: PDF DIHAPUS
                    onFilePicked: (file, fileName) {
                      setState(() {
                        _buktiFile = file;
                        _buktiFileName = fileName;
                      });
                    },
                    onFileRemoved: () {
                      setState(() {
                        _buktiFile = null;
                        _buktiFileName = null;
                      });
                    },
                    icon: Icons.attach_file,
                    iconColor: Colors.blue,
                    buttonText: 'Tambahkan Bukti Pengeluaran (Opsional)',
                  ),
                  const SizedBox(height: Rem.rem1_5),
                  CustomButton(
                    onPressed: provider.isLoading ? null : _submitForm,
                    child: provider.isLoading
                        ? const SizedBox(
                            height: Rem.rem1_25,
                            width: Rem.rem1_25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Buat Pengeluaran',
                            style: GoogleFonts.poppins(fontSize: Rem.rem1),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[month - 1];
  }
}
