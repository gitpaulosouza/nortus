import 'package:equatable/equatable.dart';

class ReadAlsoModel extends Equatable {
  final int id;
  final String title;

  const ReadAlsoModel({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];

  static ReadAlsoModel fromJson(Map<String, dynamic> json) {
    return ReadAlsoModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
