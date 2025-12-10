import 'dart:io';

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String nik;
  final String phoneNumber;
  final String gender;
  final int? addressId;
  final String? address;
  final String status;
  final File? identityPhoto;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.nik,
    required this.phoneNumber,
    required this.gender,
    this.addressId,
    this.address,
    required this.status,
    this.identityPhoto,
  });

  Map<String, String> toFields() {
    final fields = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'nik': nik,
      'phone_number': phoneNumber,
      'gender': gender,
      'status': status,
    };

    if (addressId != null) {
      fields['address_id'] = addressId.toString();
    }
    if (address != null && address!.isNotEmpty) {
      fields['address'] = address!;
    }

    return fields;
  }
}
