class PropertyFormModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String city;
  final bool isResidential; // true: Residential, false: Commercial
  final String adType; // "Sale/Resale" or "Rent"

  const PropertyFormModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.isResidential,
    required this.adType,
  });

  // CopyWith method to create a new instance with updated fields
  PropertyFormModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? city,
    bool? isResidential,
    String? adType,
  }) {
    return PropertyFormModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      isResidential: isResidential ?? this.isResidential,
      adType: adType ?? this.adType,
    );
  }

  // Convert to Map (for API or JSON usage)
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'isResidential': isResidential,
      'adType': adType,
    };
  }

  // Create an instance from Map (for API or JSON usage)
  factory PropertyFormModel.fromMap(Map<String, dynamic> map) {
    return PropertyFormModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      city: map['city'] ?? '',
      isResidential: map['isResidential'] ?? true,
      adType: map['adType'] ?? 'Sale/Resale',
    );
  }
}
