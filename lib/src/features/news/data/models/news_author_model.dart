import 'package:equatable/equatable.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';

class NewsAuthorModel extends Equatable {
  final String name;
  final NewsImageModel image;
  final String description;

  const NewsAuthorModel({
    required this.name,
    required this.image,
    required this.description,
  });

  @override
  List<Object?> get props => [name, image, description];

  static NewsAuthorModel fromJson(Map<String, dynamic> json) {
    return NewsAuthorModel(
      name: json['name'] as String? ?? '',
      image: NewsImageModel.fromJson(
        json['image'] as Map<String, dynamic>? ?? {},
      ),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image.toJson(), 'description': description};
  }
}
