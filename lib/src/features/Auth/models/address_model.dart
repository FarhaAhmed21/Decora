class AddressModel {
  final String id;
  final String city;
  final String street;
  final String building;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.city,
    required this.street,
    required this.building,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'street': street,
      'building': building,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      street: map['street'] ?? '',
      building: map['building'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}
