import 'package:equatable/equatable.dart';
import 'package:nortus/src/features/user/data/models/adress_user_model.dart';

DateTime _parseDate(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return DateTime.now();
    }
  }
  return DateTime.now();
}

int _parseId(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String language;
  final String dateFormat;
  final String timezone;
  final AdressUserModel address;
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

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    language,
    dateFormat,
    timezone,
    address,
    updatedAt,
  ];

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseId(json['id']),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      language: json['language'] as String? ?? '',
      dateFormat: json['dateFormat'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      address: AdressUserModel.fromJson(
        json['address'] as Map<String, dynamic>? ?? {},
      ),
      updatedAt: _parseDate(json['updatedAt']),
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
