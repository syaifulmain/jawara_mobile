class AddressRequestModel {
  final String address;

  AddressRequestModel({
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}
