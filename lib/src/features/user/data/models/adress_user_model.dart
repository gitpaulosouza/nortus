import 'package:equatable/equatable.dart';

class AdressUserModel extends Equatable {
  final String zipCode;
  final String country;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  const AdressUserModel({
    required this.zipCode,
    required this.country,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  @override
  List<Object?> get props => [
    zipCode,
    country,
    street,
    number,
    complement,
    neighborhood,
    city,
    state,
  ];

  static AdressUserModel fromJson(Map<String, dynamic> json) {
    return AdressUserModel(
      zipCode: json['zipCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: json['number'] as String? ?? '',
      complement: json['complement'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zipCode': zipCode,
      'country': country,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
    };
  }
}
