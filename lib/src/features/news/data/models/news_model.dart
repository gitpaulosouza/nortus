import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';

class NewsModel {
  final int id;
  final String title;
  final NewsImageModel image;
  final List<String> categories;
  final DateTime publishedAt;
  final String summary;
  final List<NewsAuthorModel> authors;

  const NewsModel({
    required this.id,
    required this.title,
    required this.image,
    required this.categories,
    required this.publishedAt,
    required this.summary,
    required this.authors,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      image: NewsImageModel.fromJson(
        json['image'] as Map<String, dynamic>? ?? {},
      ),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      publishedAt:
          DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      summary: json['summary'] as String? ?? '',
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => NewsAuthorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image.toJson(),
      'categories': categories,
      'publishedAt': publishedAt.toIso8601String(),
      'summary': summary,
      'authors': authors.map((e) => e.toJson()).toList(),
    };
  }
}
