import 'package:nortus/src/features/user/data/models/user_model.dart';

class UserResponseModel {
  final UserModel data;

  const UserResponseModel({required this.data});

  static UserResponseModel fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};
    return UserResponseModel(data: UserModel.fromJson(dataJson));
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson()};
  }
}
