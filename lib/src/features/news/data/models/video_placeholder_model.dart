class VideoPlaceholderModel {
  final String imageUrl;
  final String caption;

  const VideoPlaceholderModel({
    required this.imageUrl,
    required this.caption,
  });

  static VideoPlaceholderModel fromJson(Map<String, dynamic> json) {
    return VideoPlaceholderModel(
      imageUrl: json['imageUrl'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'caption': caption,
    };
  }
}
