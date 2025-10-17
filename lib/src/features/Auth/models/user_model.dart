import 'package:decora/src/features/Auth/models/address_model.dart';
import 'package:decora/src/features/Auth/models/preferences_model.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? phone;
  final List<AddressModel>? addresses;
  final PreferencesModel? preferences;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.phone,
    this.addresses,
    this.preferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'addresses': addresses?.map((a) => a.toMap()).toList() ?? [],
      'preferences': preferences?.toMap() ?? {},
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      phone: map['phone'],
      addresses:
          (map['addresses'] as List?)
              ?.map((a) => AddressModel.fromMap(Map<String, dynamic>.from(a)))
              .toList() ??
          [],
      preferences: map['preferences'] != null
          ? PreferencesModel.fromMap(
              Map<String, dynamic>.from(map['preferences']),
            )
          : null,
    );
  }
}
