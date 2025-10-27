import 'package:decora/src/features/Auth/models/address_model.dart';
import 'package:decora/src/features/Auth/models/preferences_model.dart';

class UserModel {
  final String id;
  String? name;
  final String? email;
  String? photoUrl;
  String? phone;
  List<AddressModel>? addresses;
  final PreferencesModel? preferences;
  List<String> favourites;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.phone,
    this.addresses,
    this.preferences,
    this.favourites = const [],
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
      'favourites': favourites,
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
      favourites:
          (map['favourites'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
