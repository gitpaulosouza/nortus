import 'package:nortus/src/features/news/data/models/news_author_model.dart';

class RelatedNewsModel {
  final int id;
  final String title;
  final String imageUrl;
  final List<String> categories;
  final DateTime publishedAt;
  final List<NewsAuthorModel> authors;

  const RelatedNewsModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.categories,
    required this.publishedAt,
    required this.authors,
  });

  factory RelatedNewsModel.fromJson(Map<String, dynamic> json) {
    return RelatedNewsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      publishedAt:
          DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
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
      'imageUrl': imageUrl,
      'categories': categories,
      'publishedAt': publishedAt.toIso8601String(),
      'authors': authors.map((e) => e.toJson()).toList(),
    };
  }
}
