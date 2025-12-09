import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/pengeluaran_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/file_picker_button.dart';
import '../../../widgets/custom_dropdown.dart';
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

      var request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      final tanggalFormatted =
          "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      request.fields['nama_pengeluaran'] = _namaController.text;
      request.fields['tanggal'] = tanggalFormatted;
      request.fields['kategori'] = _selectedKategori!;
      request.fields['nominal'] = _nominalController.text.trim();
      request.fields['verifikator'] = 'Admin';

      if (_buktiFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pengeluaran',
            _buktiFile!.path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
                  _buildSectionTitle('Informasi Pengeluaran'),
                  // Nama Pengeluaran
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

                  // Tanggal Pengeluaran
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal Pengeluaran",
                        style: GoogleFonts.poppins(
                          fontSize: Rem.rem1,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: Rem.rem0_5),
                      InkWell(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Rem.rem1,
                            vertical: Rem.rem0_875,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Pilih tanggal'
                                    : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                                style: GoogleFonts.poppins(
                                  color: _selectedDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: Rem.rem1_25,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem1),

                  // Dropdown Kategori
                  CustomDropdown<String>(
                    labelText: "Kategori Pengeluaran",
                    hintText: "-- PILIH KATEGORI --",
                    items: _kategoriList.map((k) {
                      return DropdownMenuEntry(value: k, label: k);
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        _selectedKategori = value;
                      });
                    },
                  ),
                  const SizedBox(height: Rem.rem1),

                  // Nominal
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

                  // Bukti File
                  FilePickerButton(
                    file: _buktiFile,
                    fileName: _buktiFileName,
                    fileType: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png'],
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
                  const SizedBox(height: Rem.rem2),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
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
                              'Simpan',
                              style: GoogleFonts.poppins(fontSize: Rem.rem1),
                            ),
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: Rem.rem1),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: Rem.rem1_25,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
