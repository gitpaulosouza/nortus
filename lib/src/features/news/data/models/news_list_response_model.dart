import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/data/models/news_pagination_model.dart';

class NewsListResponseModel {
  final NewsPaginationModel pagination;
  final List<NewsModel> data;

  const NewsListResponseModel({required this.pagination, required this.data});

  factory NewsListResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsListResponseModel(
      pagination: NewsPaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
