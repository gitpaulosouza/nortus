import 'package:equatable/equatable.dart';

class NewsImageModel extends Equatable {
  final String src;
  final String alt;

  const NewsImageModel({required this.src, required this.alt});

  @override
  List<Object?> get props => [src, alt];

  static NewsImageModel fromJson(Map<String, dynamic> json) {
    return NewsImageModel(
      src: json['src'] as String? ?? '',
      alt: json['alt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'src': src, 'alt': alt};
  }
}
