import 'package:nortus/src/features/user/data/models/user_address_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String language;
  final String dateFormat;
  final String timezone;
  final UserAddressModel address;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.language,
    required this.dateFormat,
    required this.timezone,
    required this.address,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      language: json['language'] as String? ?? '',
      dateFormat: json['dateFormat'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      address:
          json['address'] != null
              ? UserAddressModel.fromJson(
                json['address'] as Map<String, dynamic>,
              )
              : const UserAddressModel(
                zipCode: '',
                country: '',
                street: '',
                number: '',
                complement: '',
                neighborhood: '',
                city: '',
                state: '',
              ),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'language': language,
      'dateFormat': dateFormat,
      'timezone': timezone,
      'address': address.toJson(),
    };
  }
}
