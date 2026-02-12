import 'package:equatable/equatable.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

class UserResponseModel extends Equatable {
  final UserModel data;

  const UserResponseModel({required this.data});

  @override
  List<Object?> get props => [data];

  static UserResponseModel fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};
    return UserResponseModel(data: UserModel.fromJson(dataJson));
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson()};
  }
}
