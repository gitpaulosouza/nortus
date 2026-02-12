import 'package:nortus/src/features/user/data/models/user_model.dart';

class UserListResponseModel {
  final List<UserModel> users;

  const UserListResponseModel({required this.users});

  static UserListResponseModel fromJson(dynamic json) {
    if (json is! List) {
      return const UserListResponseModel(users: []);
    }

    final users = <UserModel>[];

    for (final item in json) {
      if (item is! Map<String, dynamic>) continue;

      try {
        if (item['data'] is Map<String, dynamic>) {
          users.add(UserModel.fromJson(item['data'] as Map<String, dynamic>));
          continue;
        }

        users.add(UserModel.fromJson(item));
      } catch (_) {
        continue;
      }
    }

    return UserListResponseModel(users: users);
  }

  dynamic toJson() => users.map((user) => user.toJson()).toList();

  UserModel? get firstOrNull => users.isNotEmpty ? users.first : null;

  bool get isEmpty => users.isEmpty;
}
