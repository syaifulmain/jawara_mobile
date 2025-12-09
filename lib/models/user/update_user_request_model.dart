class UpdateUserRequestModel {
  final String? email;
  final String? phone;
  final String? password;
  final String? passwordConfirmation;

  UpdateUserRequestModel({
    this.email,
    this.phone,
    this.password,
    this.passwordConfirmation,
  });

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequestModel(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      passwordConfirmation: json['password_confirmation'] as String? ?? json['passwordConfirmation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email' : email,
      'phone' : phone,
      'password' : password,
      'password_confirmation' : passwordConfirmation,
    };
  }

  UpdateUserRequestModel copyWith({
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) {
    return UpdateUserRequestModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  /// Simple helper to check password confirmation matches (if provided).
  bool get isPasswordConfirmed {
    if (password == null && passwordConfirmation == null) return true;
    return password != null && password == passwordConfirmation;
  }
}
