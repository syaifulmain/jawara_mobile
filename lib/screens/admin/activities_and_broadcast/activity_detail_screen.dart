import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../enums/activity_category.dart';
import '../../../models/activity_model.dart';
import '../../../models/activity/create_activity_request_model.dart';
import '../../../providers/activity_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityId;

  const ActivityDetailScreen({Key? key, required this.activityId})
    : super(key: key);

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _personInChargeController = TextEditingController();
  ActivityCategory? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isEditMode = false;
  Activity? _activity;

  // Pengeluaran fields
  bool _isPengeluaran = false;
  final _namaPengeluaranController = TextEditingController();
  String? _selectedKategoriPengeluaran;
  final _nominalController = TextEditingController();
  final _verifikatorController = TextEditingController();
  File? _buktiFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_activity == null) {
      _loadActivity();
    }
  }

  void _loadActivity() {
    final activityProvider = context.read<ActivityProvider>();

    _activity = activityProvider.activities.firstWhere(
      (a) => a.id.toString() == widget.activityId,
    );

    if (_activity != null) {
      _nameController.text = _activity!.name;
      _descriptionController.text = _activity!.description ?? '';
      _locationController.text = _activity!.location;
      _personInChargeController.text = _activity!.personInCharge;
      _selectedCategory = _activity!.category;
      _selectedDate = _activity!.date;
      _selectedTime = TimeOfDay.fromDateTime(_activity!.date);

      // Load pengeluaran data
      _isPengeluaran = _activity!.isPengeluaran;
      if (_isPengeluaran) {
        _namaPengeluaranController.text = _activity!.namaPengeluaran ?? '';
        _selectedKategoriPengeluaran = _activity!.kategori;
        _nominalController.text = _activity!.nominal?.toString() ?? '';
        _verifikatorController.text = _activity!.verifikator ?? '';
      }
    }
  }

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
    if (!_isEditMode) return;

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
    if (!_isEditMode) return;

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

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _loadActivity();
      }
    });
  }

  Future<void> _updateActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua field')));
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

    final success = await activityProvider.updateActivity(
      token,
      widget.activityId,
      request,
    );

    if (success) {
      if (mounted) {
        // Refresh data dari server untuk memastikan sinkronisasi
        await activityProvider.fetchActivities(authProvider.token!);

        // Update selectedActivity juga jika sesuai
        if (activityProvider.selectedActivity?.id == widget.activityId) {
          await activityProvider.fetchActivityById(
            authProvider.token!,
            widget.activityId,
          );
          _activity = activityProvider.selectedActivity;
        }

        setState(() {
          _isEditMode = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kegiatan berhasil diperbarui')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              activityProvider.errorMessage ?? 'Gagal memperbarui kegiatan',
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteActivity() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kegiatan'),
        content: const Text('Apakah Anda yakin ingin menghapus kegiatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

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

    final success = await activityProvider.deleteActivity(
      token,
      widget.activityId,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kegiatan berhasil dihapus')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              activityProvider.errorMessage ?? 'Gagal menghapus kegiatan',
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
          _isEditMode ? 'Edit Kegiatan' : 'Detail Kegiatan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: 'Edit',
            ),
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteActivity,
              tooltip: 'Hapus',
            ),
        ],
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
                        readOnly: !_isEditMode,
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
                        readOnly: !_isEditMode,
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
                        initialSelection: _selectedCategory,
                        enabled: _isEditMode, // Tambahkan parameter enabled
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
                            onTap: _isEditMode
                                ? () => _selectDate(context)
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Rem.rem1,
                                vertical: Rem.rem0_875,
                              ),
                              decoration: BoxDecoration(
                                color: _isEditMode
                                    ? Colors.white
                                    : Colors.grey.shade100,
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
                                        : DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(_selectedDate!),
                                    style: GoogleFonts.poppins(
                                      color: _selectedDate == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    size: Rem.rem1_25,
                                    color: _isEditMode
                                        ? Colors.black
                                        : Colors.grey,
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
                            onTap: _isEditMode
                                ? () => _selectTime(context)
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Rem.rem1,
                                vertical: Rem.rem0_875,
                              ),
                              decoration: BoxDecoration(
                                color: _isEditMode
                                    ? Colors.white
                                    : Colors.grey.shade100,
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
                                  Icon(
                                    Icons.access_time,
                                    size: Rem.rem1_25,
                                    color: _isEditMode
                                        ? Colors.black
                                        : Colors.grey,
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
                        readOnly: !_isEditMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _personInChargeController,
                        labelText: "Penanggung Jawab",
                        hintText: "Masukkan nama penanggung jawab",
                        readOnly: !_isEditMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penanggung jawab harus diisi';
                          }
                          return null;
                        },
                      ),
                      if (_isEditMode) ...[
                        const SizedBox(height: Rem.rem1_5),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onPressed: _toggleEditMode,
                                child: const Text('Batal'),
                                isOutlined:
                                    true, // <-- PENTING: Untuk gaya Outline
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                onPressed: provider.isLoading
                                    ? null
                                    : _updateActivity,
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
                                        style: GoogleFonts.poppins(
                                          fontSize: Rem.rem1,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
