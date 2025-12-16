import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/auth/register_request_model.dart';
import '../../../models/address/address_list_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/address_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/file_picker_button.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGender;
  String? _selectedStatus;
  AddressListModel? _selectedAddress;
  File? _identityPhoto;
  String? _identityPhotoName;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  void _loadAddresses() {
    final authProvider = context.read<AuthProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (authProvider.token != null) {
      addressProvider.fetchAddresses(authProvider.token!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih jenis kelamin')));
      return;
    }

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih status')));
      return;
    }

    final request = RegisterRequest(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text,
      nik: _nikController.text,
      phoneNumber: _phoneController.text,
      gender: _selectedGender!,
      addressId: _selectedAddress?.id,
      address: _addressController.text.isNotEmpty
          ? _addressController.text
          : null,
      status: _selectedStatus!,
      identityPhoto: _identityPhoto,
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.register(request);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengguna berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userProvider.errorMessage ?? 'Gagal menambahkan pengguna',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Tambah Pengguna',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Informasi Akun',
                    children: [
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: "Email",
                        hintText: "Masukkan email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email harus diisi';
                          }
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _passwordController,
                        labelText: "Password",
                        hintText: "Masukkan password",
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password harus diisi';
                          }
                          if (value.length < 8) {
                            return 'Password minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _passwordConfirmationController,
                        labelText: "Konfirmasi Password",
                        hintText: "Masukkan ulang password",
                        obscureText: _obscurePasswordConfirmation,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordConfirmation
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordConfirmation =
                                  !_obscurePasswordConfirmation;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password harus diisi';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem1_5),
                  _buildSection(
                    title: 'Data Pribadi',
                    children: [
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: "Nama Lengkap",
                        hintText: "Masukkan nama lengkap",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _nikController,
                        labelText: "NIK",
                        hintText: "Masukkan NIK (16 digit)",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIK harus diisi';
                          }
                          if (value.length != 16) {
                            return 'NIK harus 16 digit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _phoneController,
                        labelText: "Nomor Telepon",
                        hintText: "Masukkan nomor telepon",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomDropdown<String>(
                        labelText: "Jenis Kelamin",
                        hintText: "-- PILIH JENIS KELAMIN --",
                        initialSelection: _selectedGender,
                        items: const [
                          DropdownMenuEntry(value: 'M', label: 'Laki-laki'),
                          DropdownMenuEntry(value: 'F', label: 'Perempuan'),
                        ],
                        onSelected: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      Text(
                        "Foto Identitas",
                        style: GoogleFonts.poppins(
                          fontSize: Rem.rem1,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: Rem.rem0_5),
                      FilePickerButton(
                        file: _identityPhoto,
                        fileName: _identityPhotoName,
                        fileType: FileType.image,
                        onFilePicked: (file, fileName) {
                          setState(() {
                            _identityPhoto = file;
                            _identityPhotoName = fileName;
                          });
                        },
                        onFileRemoved: () {
                          setState(() {
                            _identityPhoto = null;
                            _identityPhotoName = null;
                          });
                        },
                        icon: Icons.add_photo_alternate,
                        iconColor: Colors.blue,
                        buttonText: 'Upload Foto KTP',
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem1_5),
                  _buildSection(
                    title: 'Alamat & Status',
                    children: [
                      Consumer<AddressProvider>(
                        builder: (context, addressProvider, _) {
                          return CustomDropdown<AddressListModel>(
                            labelText: "Alamat Domisili",
                            hintText: "-- PILIH ALAMAT --",
                            initialSelection: _selectedAddress,
                            items: addressProvider.addresses.map((address) {
                              return DropdownMenuEntry(
                                value: address,
                                label: address.alamat,
                              );
                            }).toList(),
                            onSelected: (value) {
                              setState(() {
                                _selectedAddress = value;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomTextFormField(
                        controller: _addressController,
                        labelText: "Alamat (jika tidak ada di pilihan)",
                        hintText: "Masukkan detail alamat",
                        maxLines: 3,
                      ),
                      const SizedBox(height: Rem.rem1),
                      CustomDropdown<String>(
                        labelText: "Status",
                        hintText: "-- PILIH STATUS --",
                        initialSelection: _selectedStatus,
                        items: const [
                          DropdownMenuEntry(value: 'owner', label: 'Pemilik'),
                          DropdownMenuEntry(value: 'tenant', label: 'Penyewa'),
                        ],
                        onSelected: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem2),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () => context.pop(),
                          isOutlined: true,
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(fontSize: Rem.rem1),
                          ),
                        ),
                      ),
                      const SizedBox(width: Rem.rem1),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          onPressed: userProvider.isLoading ? null : _addUser,
                          child: userProvider.isLoading
                              ? const SizedBox(
                                  height: Rem.rem1_25,
                                  width: Rem.rem1_25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Simpan Pengguna',
                                  style: GoogleFonts.poppins(
                                    fontSize: Rem.rem1,
                                  ),
                                ),
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Rem.rem1_5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Rem.rem0_75),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1_25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1_5),
          ...children,
        ],
      ),
    );
  }
}
