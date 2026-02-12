import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/read_also_model.dart';
import 'package:nortus/src/features/news/data/models/related_news_model.dart';
import 'package:nortus/src/features/news/data/models/content_image_model.dart';
import 'package:nortus/src/features/news/data/models/three_image_grid_model.dart';
import 'package:nortus/src/features/news/data/models/video_placeholder_model.dart';

class NewsDetailsModel {
  final int id;
  final String title;
  final NewsImageModel image;
  final String imageCaption;
  final List<String> categories;
  final DateTime publishedAt;
  final String newsResume;
  final String estimatedReadingTime;
  final List<NewsAuthorModel> authors;
  final String description;
  final List<ContentImageModel> contentImages;
  final ThreeImageGridModel? threeImageGrid;
  final VideoPlaceholderModel? videoPlaceholder;
  final List<RelatedNewsModel> relatedNews;
  final ReadAlsoModel? readAlso;

  const NewsDetailsModel({
    required this.id,
    required this.title,
    required this.image,
    required this.imageCaption,
    required this.categories,
    required this.publishedAt,
    required this.newsResume,
    required this.estimatedReadingTime,
    required this.authors,
    required this.description,
    this.contentImages = const [],
    this.threeImageGrid,
    this.videoPlaceholder,
    required this.relatedNews,
    this.readAlso,
  });

  static NewsDetailsModel fromJson(Map<String, dynamic> json) {
    return NewsDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      image: NewsImageModel.fromJson(
        json['image'] as Map<String, dynamic>? ?? {},
      ),
      imageCaption: json['imageCaption'] as String? ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      publishedAt:
          DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      newsResume: json['newsResume'] as String? ?? '',
      estimatedReadingTime: json['estimatedReadingTime'] as String? ?? '',
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => NewsAuthorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
      contentImages:
          (json['contentImages'] as List<dynamic>?)
              ?.map((e) =>
                  ContentImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      threeImageGrid:
          json['threeImageGrid'] != null
              ? ThreeImageGridModel.fromJson(
                  json['threeImageGrid'] as Map<String, dynamic>)
              : null,
      videoPlaceholder:
          json['videoPlaceholder'] != null
              ? VideoPlaceholderModel.fromJson(
                  json['videoPlaceholder'] as Map<String, dynamic>)
              : null,
      relatedNews:
          (json['relatedNews'] as List<dynamic>?)
              ?.map((e) => RelatedNewsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      readAlso:
          json['readAlso'] != null
              ? ReadAlsoModel.fromJson(json['readAlso'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image.toJson(),
      'imageCaption': imageCaption,
      'categories': categories,
      'publishedAt': publishedAt.toIso8601String(),
      'newsResume': newsResume,
      'estimatedReadingTime': estimatedReadingTime,
      'authors': authors.map((e) => e.toJson()).toList(),
      'description': description,
      'contentImages': contentImages.map((e) => e.toJson()).toList(),
      'threeImageGrid': threeImageGrid?.toJson(),
      'videoPlaceholder': videoPlaceholder?.toJson(),
      'relatedNews': relatedNews.map((e) => e.toJson()).toList(),
      'readAlso': readAlso?.toJson(),
    };
  }
}
