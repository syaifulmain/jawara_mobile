import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../enums/activity_category.dart';
import '../../../models/activity/create_activity_request_model.dart';
import '../../../providers/activity_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/file_picker_button.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _personInChargeController = TextEditingController();
  ActivityCategory? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Toggle dan fields untuk pengeluaran
  bool _isPengeluaran = false;
  final _namaPengeluaranController = TextEditingController();
  String? _selectedKategoriPengeluaran;
  final _nominalController = TextEditingController();
  final _verifikatorController = TextEditingController();
  File? _buktiFile;
  String? _buktiFileName;

  final List<String> _kategoriPengeluaranList = [
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
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _personInChargeController.dispose();
    _namaPengeluaranController.dispose();
    _nominalController.dispose();
    _verifikatorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih kategori kegiatan')));
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih tanggal kegiatan')));
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih waktu kegiatan')));
      return;
    }

    // Validasi pengeluaran jika toggle aktif
    if (_isPengeluaran) {
      if (_namaPengeluaranController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama pengeluaran harus diisi')),
        );
        return;
      }
      if (_nominalController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nominal pengeluaran harus diisi')),
        );
        return;
      }
    }

    final activityDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final request = CreateActivityRequest(
      name: _nameController.text,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      category: _selectedCategory!,
      date: activityDateTime,
      location: _locationController.text,
      personInCharge: _personInChargeController.text,
      isPengeluaran: _isPengeluaran,
      namaPengeluaran: _isPengeluaran ? _namaPengeluaranController.text : null,
      kategori: _isPengeluaran ? _selectedKategoriPengeluaran : null,
      nominal: _isPengeluaran && _nominalController.text.isNotEmpty
          ? double.tryParse(_nominalController.text)
          : null,
      verifikator: _isPengeluaran && _verifikatorController.text.isNotEmpty
          ? _verifikatorController.text
          : null,
      buktiPengeluaran: _isPengeluaran ? _buktiFile : null,
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(
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

    final success = await activityProvider.createActivity(token, request);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kegiatan berhasil ditambahkan')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              activityProvider.errorMessage ?? 'Gagal menambahkan kegiatan',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Tambah Kegiatan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: "Nama Kegiatan",
                        hintText: "Masukkan nama kegiatan",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama kegiatan harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _descriptionController,
                        labelText: "Deskripsi",
                        hintText: "Masukkan deskripsi kegiatan",
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomDropdown<ActivityCategory>(
                        labelText: "Kategori Kegiatan",
                        hintText: "-- PILIH KATEGORI --",
                        items: ActivityCategory.values.map((category) {
                          return DropdownMenuEntry(
                            value: category,
                            label: category.label,
                          );
                        }).toList(),
                        onSelected: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal Kegiatan",
                            style: GoogleFonts.poppins(
                              fontSize: Rem.rem1,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: Rem.rem0_5),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Rem.rem1,
                                vertical: Rem.rem0_875,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(Rem.rem0_5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate == null
                                        ? 'Pilih tanggal'
                                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                    style: GoogleFonts.poppins(
                                      color: _selectedDate == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.calendar_today,
                                    size: Rem.rem1_25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Rem.rem1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Waktu Kegiatan",
                            style: GoogleFonts.poppins(
                              fontSize: Rem.rem1,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: Rem.rem0_5),
                          InkWell(
                            onTap: () => _selectTime(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Rem.rem1,
                                vertical: Rem.rem0_875,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(Rem.rem0_5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedTime == null
                                        ? 'Pilih waktu'
                                        : _selectedTime!.format(context),
                                    style: GoogleFonts.poppins(
                                      color: _selectedTime == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    size: Rem.rem1_25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _locationController,
                        labelText: "Lokasi",
                        hintText: "Masukkan lokasi kegiatan",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1_5),
                      // Toggle Pengeluaran
                      Container(
                        padding: const EdgeInsets.all(Rem.rem1),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(Rem.rem0_75),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: AppColors.primaryColor,
                              size: Rem.rem1_5,
                            ),
                            const SizedBox(width: Rem.rem0_75),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tambahkan Pengeluaran',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Rem.rem1,
                                    ),
                                  ),
                                  Text(
                                    'Aktifkan jika kegiatan ini memiliki biaya',
                                    style: GoogleFonts.poppins(
                                      fontSize: Rem.rem0_875,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isPengeluaran,
                              onChanged: (value) {
                                setState(() {
                                  _isPengeluaran = value;
                                });
                              },
                              activeColor: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      // Fields Pengeluaran (tampil jika toggle aktif)
                      if (_isPengeluaran) ...[
                        const SizedBox(height: Rem.rem1_5),
                        Container(
                          padding: const EdgeInsets.all(Rem.rem1_5),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(Rem.rem0_75),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange.shade700,
                                    size: Rem.rem1_25,
                                  ),
                                  const SizedBox(width: Rem.rem0_5),
                                  Text(
                                    'Informasi Pengeluaran',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Rem.rem1_125,
                                      color: Colors.orange.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Rem.rem1),
                              CustomTextFormField(
                                controller: _namaPengeluaranController,
                                labelText: "Nama Pengeluaran *",
                                hintText: "Masukkan nama pengeluaran",
                                validator: (value) {
                                  if (_isPengeluaran &&
                                      (value == null || value.isEmpty)) {
                                    return 'Nama pengeluaran harus diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Rem.rem1),
                              CustomDropdown<String>(
                                labelText: "Kategori Pengeluaran",
                                hintText: "Pilih kategori",
                                initialSelection: _selectedKategoriPengeluaran,
                                items: _kategoriPengeluaranList
                                    .map(
                                      (kategori) => DropdownMenuEntry(
                                        value: kategori,
                                        label: kategori,
                                      ),
                                    )
                                    .toList(),
                                onSelected: (value) {
                                  setState(() {
                                    _selectedKategoriPengeluaran = value;
                                  });
                                },
                              ),
                              const SizedBox(height: Rem.rem1),
                              CustomTextFormField(
                                controller: _nominalController,
                                labelText: "Nominal *",
                                hintText: "Masukkan nominal",
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (_isPengeluaran &&
                                      (value == null || value.isEmpty)) {
                                    return 'Nominal harus diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Rem.rem1),
                              CustomTextFormField(
                                controller: _verifikatorController,
                                labelText: "Verifikator",
                                hintText: "Masukkan nama verifikator",
                              ),
                              const SizedBox(height: Rem.rem1),
                              Text(
                                "Bukti Pengeluaran",
                                style: GoogleFonts.poppins(
                                  fontSize: Rem.rem1,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: Rem.rem0_5),
                              FilePickerButton(
                                file: _buktiFile,
                                fileName: _buktiFileName,
                                fileType: FileType.image,
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
                                icon: Icons.upload_file,
                                iconColor: Colors.orange,
                                buttonText: 'Upload Bukti Pengeluaran',
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _personInChargeController,
                        labelText: "Penanggung Jawab",
                        hintText: "Masukkan nama penanggung jawab",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penanggung jawab harus diisi';
                          }
                          return null;
                        },
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
                                'Simpan Kegiatan',
                                style: GoogleFonts.poppins(fontSize: Rem.rem1),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
