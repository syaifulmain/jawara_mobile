import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/user/update_user_request_model.dart';
import '../../../models/user/user_detail_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custom_button.dart';

class UserDetailScreen extends StatefulWidget {
  final String id;

  const UserDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isEditMode = false;
  UserDetailModel? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() async {
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    if (authProvider.token != null) {
      await userProvider.fetchUserDetail(authProvider.token!, widget.id);
      _user = userProvider.selectedUser;
      
      if (_user != null && mounted) {
        _initializeFields();
      }
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    if (authProvider.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan. Silakan login ulang.'), backgroundColor: Colors.red),
      );
      return;
    }

    // Prepare request model. If phone is empty, send null to allow partial update.
    final phoneValue = _phoneController.text.trim();
    final passwordValue = _passwordController.text;
    
    print('Updating user with phone: $phoneValue, password: ${passwordValue.isNotEmpty ? '***' : '(unchanged)'}');

    final req = UpdateUserRequestModel(
      email: _emailController.text.trim(),
      phone: phoneValue.isEmpty ? null : phoneValue,
      password: passwordValue.isEmpty ? null : passwordValue,
      passwordConfirmation: passwordValue.isEmpty ? null : passwordValue,
    );

    final success = await authProvider.updateUser(authProvider.token!, widget.id, req);

    print(success);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui'), backgroundColor: Colors.green),
      );
      // refresh local user data and exit edit mode
      setState(() {
        _isEditMode = false;
      });
      // reload detail from provider to ensure fresh data
      _loadDetail();
    } else {
      final msg = authProvider.errorMessage ?? 'Gagal memperbarui pengguna';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    }
  }

  void _initializeFields() {
    if (_user == null) return;
    
    setState(() {
      _emailController.text = _user!.email;
      _phoneController.text = _user!.phone ?? '';
      _passwordController.text = ''; // Password is kept empty unless changed
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _initializeFields(); // Reset fields to original data if canceled
      }
    });
  }

  // Future<void> _updateUser() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   // TODO: Implement update logic in Provider and Service
  //   // For now, just a mock implementation
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Fitur update pengguna belum diimplementasikan di API')),
  //   );
  //
  //   setState(() {
  //     _isEditMode = false;
  //   });
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Pengguna' : 'Detail Pengguna',
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
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading && !_isEditMode) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.errorMessage != null && _user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${userProvider.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // If we are in edit mode, use the _user from local state to avoid flicker during rebuilds
          // If not in edit mode, always try to use the latest from provider if available
          final displayUser = _isEditMode ? _user : (userProvider.selectedUser ?? _user);

          if (displayUser == null) {
            return const Center(child: Text('Data pengguna tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeader(displayUser),
                  const SizedBox(height: Rem.rem2),
                  if (_isEditMode) 
                    _buildEditForm()
                  else
                    _buildInfoCard(displayUser),
                  
                  if (_isEditMode) ...[
                    const SizedBox(height: Rem.rem2),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _toggleEditMode,
                            child: const Text('Batal'),
                            isOutlined: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            onPressed: userProvider.isLoading ? null : _updateUser,
                            child: userProvider.isLoading
                                ? const SizedBox(
                                    height: Rem.rem1_25,
                                    width: Rem.rem1_25,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : Text(
                                    'Simpan',
                                    style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(UserDetailModel user) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: user.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              user.isActive ? 'Aktif' : 'Tidak Aktif',
              style: GoogleFonts.poppins(
                color: user.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(UserDetailModel user) {
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
            'Informasi Akun',
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1_25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Email', user.email),
          const Divider(height: 24),
          _buildInfoRow('Nomor Telepon', user.phone ?? '-'),
          const Divider(height: 24),
          _buildInfoRow('Peran (Role)', user.role.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
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
            'Edit Informasi Akun',
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1_25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1_5),
          CustomTextFormField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Masukkan email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!value.contains('@')) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: Rem.rem1),
          CustomTextFormField(
            controller: _phoneController,
            labelText: 'Nomor Telepon',
            hintText: 'Masukkan nomor telepon',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: Rem.rem1),
          CustomTextFormField(
            controller: _passwordController,
            labelText: 'Password Baru (Opsional)',
            hintText: 'Kosongkan jika tidak ingin mengubah',
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: Rem.rem0_875,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: Rem.rem1,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
